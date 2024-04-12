/**
 * @description       : controller for job Applicants custom object
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JobApplicantController {
  public class applicantWrapper {
    @AuraEnabled
    public List<Candidate_Details__c> candidateDetails { get; set; }
    @AuraEnabled
    public string jobName { get; set; }
    @AuraEnabled
    public id jobId { get; set; }
  }

  public class CandidateWrapper {
    @AuraEnabled
    public Integer matchPercentage { get; set; }
    @AuraEnabled
    public String About { get; set; }
    @AuraEnabled
    public String Candidate_Email { get; set; }
    @AuraEnabled
    public String City { get; set; }
    @AuraEnabled
    public String Country { get; set; }
    @AuraEnabled
    public Id CreatedById { get; set; }
    @AuraEnabled
    public Decimal Experience { get; set; }
    @AuraEnabled
    public Id LastModifiedById { get; set; }
    @AuraEnabled
    public String Name { get; set; }
    @AuraEnabled
    public Id OwnerId { get; set; }
    @AuraEnabled
    public String Phone_Number { get; set; }
    @AuraEnabled
    public String Skills { get; set; }
    @AuraEnabled
    public String Id { get; set; }
    @AuraEnabled
    public boolean isAccepted { get; set; }
    @AuraEnabled
    public string Status { get; set; }
    @AuraEnabled
    public string AssesmentStatus { get; set; }

    public CandidateWrapper(
      Candidate_Details__c candidate,
      Integer matchPercentage,
      String Status,
      String AssesmentStatus
    ) {
      this.matchPercentage = matchPercentage;
      this.About = candidate.About__c;
      this.Candidate_Email = candidate.Candidate_Email__c;
      this.City = candidate.City__c;
      this.Country = candidate.Country__c;
      this.CreatedById = candidate.CreatedById;
      this.Experience = candidate.Experience__c;
      this.LastModifiedById = candidate.LastModifiedById;
      this.Name = candidate.Name;
      this.OwnerId = candidate.OwnerId;
      this.Phone_Number = candidate.Phone_Number__c;
      this.Skills = candidate.Skills__c;
      this.Id = candidate.Id;
      this.isAccepted = false;
      this.Status = Status;
      this.AssesmentStatus = assesmentStatus;
    }
  }
  @AuraEnabled(cacheable=true)
  public static List<CandidateWrapper> fetchCandidateNames(id jobId) {
    List<Job_Applicants__c> candidateIdList = new List<Job_Applicants__c>();
    List<CandidateWrapper> candidateRecords = new List<CandidateWrapper>();

    // Required Skills of job
    List<Job__c> jobs = [
      SELECT Skills_Required__c
      FROM Job__c
      WHERE Id = :jobId
    ];
    Set<String> requiredSkills = new Set<String>();
    for (Job__c job : jobs) {
      if (String.isNotBlank(job.Skills_Required__c)) {
        requiredSkills.addAll(job.Skills_Required__c.split(','));
      }
    }
    for (Job_Applicants__c applicant : [
      SELECT CandidateId__c
      FROM Job_Applicants__c
      WHERE Job_Id__c = :jobId
    ]) {
      candidateIdList.add(applicant);
    }
    List<Id> candidateIds = new List<Id>();
    for (Job_Applicants__c applicant : candidateIdList) {
      candidateIds.add(applicant.CandidateId__c);
    }
    for (Candidate_Details__c candidate : [
      SELECT
        Id,
        About__c,
        Candidate_Email__c,
        City__c,
        Country__c,
        CreatedById,
        Experience__c,
        LastModifiedById,
        Name,
        OwnerId,
        Phone_Number__c,
        Skills__c,
        ParsedSkills__c
      FROM Candidate_Details__c
      WHERE Id IN :candidateIds
    ]) {
      Set<String> candidateSkills = new Set<String>();
      if (String.isNotBlank(candidate.Skills__c)) {
        candidateSkills.addAll(candidate.Skills__c.split(';'));
      }
      Integer matchPercentage = calculateMatchPercentage(
        requiredSkills,
        candidateSkills,
        candidate.ParsedSkills__c
      );
      string Status = getApplicantStatus(candidate.Id, jobId);
      System.debug('status assessment--->' + Status);
      string assessmentStatus = getAssessmentStatus(candidate.Id);

      candidateRecords.add(
        new CandidateWrapper(
          candidate,
          matchPercentage,
          status,
          assessmentStatus
        )
      );
    }
    return candidateRecords;
  }
  @AuraEnabled(cacheable=true)
  public static List<applicantWrapper> getApplicantsList(id userId) {
     List<applicantWrapper> appliedCandidateWrapperList = new List<applicantWrapper>();
    List<Candidate_Details__c> appliedCandidateDetailsList = new List<Candidate_Details__c>();
    string jobName = '';
    user u = [SELECT companyName FROM user WHERE id = :userId LIMIT 1];
    string companyname = u.CompanyName;
    try {
      List<Job_Applicants__c> applicantList = [
        SELECT CandidateId__c, Job_Id__c
        FROM Job_Applicants__c
        WHERE
          Application_Status__c = 'Pending'
          AND Job_Id__c IN (
            SELECT id
            FROM Job__c
            WHERE Company_Name__c = :companyname
          )
        LIMIT 3
      ];

      List<Id> candidateIds = new List<Id>();
      List<Id> jobIds = new List<Id>();
      for (Job_Applicants__c applicant : applicantList) {
        candidateIds.add(applicant.CandidateId__c);
        jobIds.add(applicant.Job_Id__c);
      }
      if (!candidateIds.isEmpty()) {
        appliedCandidateDetailsList = [
          SELECT Name, Candidate_Email__c, City__c, Country__c, Experience__c
          FROM Candidate_Details__c
          WHERE Id IN :candidateIds
        ];
      }

      Map<Id, Candidate_Details__c> candidateMap = new Map<Id, Candidate_Details__c>(
        [
          SELECT
            Id,
            Name,
            Candidate_Email__c,
            City__c,
            Country__c,
            Experience__c,
            About__c,
            Skills__c,
            Phone_Number__c
          FROM Candidate_Details__c
          WHERE Id IN :candidateIds
        ]
      );

      Map<Id, Job__c> jobMap = new Map<Id, Job__c>(
        [
          SELECT Id, Title_of_position__c
          FROM Job__c
          WHERE Id IN :jobIds
        ]
      );

      for (Job_Applicants__c applicant : applicantList) {
        Candidate_Details__c candidate = candidateMap.get(
          applicant.CandidateId__c
        );
        Job__c job = jobMap.get(applicant.Job_Id__c);

        applicantWrapper wrapper = new applicantWrapper();
        wrapper.candidateDetails = new List<Candidate_Details__c>();
        wrapper.candidateDetails.add(candidate);
        wrapper.jobName = job.Title_of_position__c;
        wrapper.jobId = job.Id;

        appliedCandidateWrapperList.add(wrapper);
      }
      System.debug('appliedCandidateWrapperList-------->'+appliedCandidateWrapperList);
      return appliedCandidateWrapperList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static integer getNumberOfJobsPosted(id userId) {
    user u = [SELECT companyName FROM user WHERE id = :userId LIMIT 1];
    string companyname = u.CompanyName;
    return [
      SELECT COUNT()
      FROM Job__c
      WHERE Status__c = 'Completed' AND Company_Name__c = :companyname
    ];
  }

  @AuraEnabled(cacheable=true)
  public static integer getNumberOfApplicants(id userId) {
    user u = [SELECT companyName FROM user WHERE id = :userId LIMIT 1];
    string companyname = u.CompanyName;
    return [
      SELECT COUNT()
      FROM Job_Applicants__c
      WHERE Job_Id__r.Company_Name__c = :companyName
    ];
  }

  @AuraEnabled(cacheable=true)
  public static list<job__c> fetchJobDetails(string jobId) {
    list<Job__c> jobList = new List<Job__c>();
    try {
      for (Job__c job : [
        SELECT
          Id,
          City__c,
          Company_Name__c,
          Country__c,
          CreatedById,
          Description__c,
          Experience__c,
          External_Application_Link__c,
          Industry__c,
          Name,
          LastModifiedById,
          Location__c,
          OwnerId,
          Publish_end_date__c,
          Publish_start_date__c,
          Salary__c,
          Status__c,
          Summary__c,
          Title_of_position__c,
          Type__c
        FROM Job__c
        WHERE id = :jobId
      ]) {
        jobList.add(job);
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return jobList;
  }
  @AuraEnabled
  public static void changeStatus(
    String value,
    List<Id> applicantId,
    id jobId
  ) {
    List<Job_Applicants__c> applicantListToUpdate = new List<Job_Applicants__c>();

    try {
      List<Job_Applicants__c> applicants = [
        SELECT Id, Application_Status__c
        FROM Job_Applicants__c
        WHERE CandidateId__c IN :applicantId AND Job_Id__c = :jobId
      ];
      for (Job_Applicants__c applicant : applicants) {
        applicant.Application_Status__c = value;
        applicantListToUpdate.add(applicant);
      }
      if (!applicantListToUpdate.isEmpty()) {
        update applicantListToUpdate;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static string getApplicantStatus(id applicantId, id jobId) {
    string status;
    for (Job_Applicants__c applicant : [
      SELECT Application_Status__c
      FROM Job_Applicants__c
      WHERE CandidateId__c = :applicantId AND Job_Id__c = :jobId
    ]) {
      status = applicant.Application_Status__c;
    }
    return status;
  }

  public static string getAssessmentStatus(id applicantId) {
    string status;
    for (Job_Applicants__c applicant : [
      SELECT Assesment_Status__c
      FROM Job_Applicants__c
      WHERE CandidateId__c = :applicantId
    ]) {
      status = applicant.Assesment_Status__c;
    }
    return status;
  }

  @AuraEnabled(cacheable=true)
  public static decimal getScore(id jobid, id candidateid) {
    Decimal score;
    id applicantid = [
      SELECT id
      FROM Job_Applicants__c
      WHERE CandidateId__c = :candidateid AND Job_Id__c = :jobid
    ][0]
    .id;
    for (Job_Applicants__c applicant : [
      SELECT Total_Score__c
      FROM Job_Applicants__c
      WHERE CandidateId__c = :applicantid
    ]) {
      score = applicant.Total_Score__c;
    }
    return score;
  }

  @TestVisible
  private static Integer calculateMatchPercentage(
    Set<String> requiredSkills,
    Set<String> candidateSkills,
    String resumeParsedSkills
  ) {
    List<String> candidateSkillsLower = new List<String>();
    if (String.isNotBlank(resumeParsedSkills)) {
      resumeParsedSkills = resumeParsedSkills.deleteWhitespace().toLowerCase();
    }
    for (String skill : candidateSkills) {
      candidateSkillsLower.add(skill.deleteWhitespace().toLowerCase());
    }
    List<String> requiredSkillsLower = new List<String>();
    for (String skill : requiredSkills) {
      requiredSkillsLower.add(skill.deleteWhitespace().toLowerCase());
    }
    Integer commonSkillsCount = 0;
    for (String skill : requiredSkillsLower) {
      Pattern pattern = Pattern.compile(Pattern.quote(skill));
      Matcher matcher = pattern.matcher(
        candidateSkillsLower.toString() + resumeParsedSkills
      );
      if (matcher.find()) {
        commonSkillsCount++;
      }
    }
    if (requiredSkillsLower.size() > 0) {
      Integer matchPercentage =
        (commonSkillsCount * 100) / requiredSkillsLower.size();

      return matchPercentage;
    } else {
      return 0;
    }
  }
}
