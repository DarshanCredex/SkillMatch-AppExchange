/**
 * @description       : controller for job Applicants custom object
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JobApplicantController {
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

    public CandidateWrapper(
      Candidate_Details__c candidate,
      Integer matchPercentage,
      String Status
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
    }
  }

  @AuraEnabled(cacheable=true)
  public static List<CandidateWrapper> fetchCandidateNames(string jobId) {
    
    List<Job_Applicants__c> candidateIdList = new List<Job_Applicants__c>();
    List<CandidateWrapper> candidateRecords = new List<CandidateWrapper>();


    // Required Skills of job
    List<Job__c> jobs = [
      SELECT Skills_Required__c
      FROM Job__c
      WHERE Id = :jobId
    ];
    List<String> requiredSkills = new List<String>();

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
        candidate.Skills__c.split(';')
      );
      string Status = getApplicantStatus(candidate.Id);
      candidateRecords.add(
        new CandidateWrapper(candidate, matchPercentage, status)
      );
    }

    system.debug('candidateRecords---------->' + candidateRecords);
    return candidateRecords;
  }

  @AuraEnabled(cacheable=true)
  public static List<Candidate_Details__c> getApplicantsList(string userId) {
    List<Candidate_Details__c> appliedCandidateDetailsList = new List<Candidate_Details__c>();
    user u = [SELECT companyName FROM user WHERE id = :userId LIMIT 1];
    string companyname = u.CompanyName;

    try {
      List<Job_Applicants__c> applicantList = [
        SELECT CandidateId__c
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
      for (Job_Applicants__c applicant : applicantList) {
        candidateIds.add(applicant.CandidateId__c);
      }

      if (!candidateIds.isEmpty()) {
        appliedCandidateDetailsList = [
          SELECT Name, Candidate_Email__c, City__c, Country__c, Experience__c
          FROM Candidate_Details__c
          WHERE Id IN :candidateIds
        ];
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    System.debug(
      'appliedCandidateDetailsList------>' + appliedCandidateDetailsList
    );
    return appliedCandidateDetailsList;
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
    system.debug('jobId---->' + jobId);
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
    system.debug('jobList------->' + jobList);
    return jobList;
  }

  @AuraEnabled
  public static void changeStatus(String value, List<Id> applicantId) {
    List<Job_Applicants__c> applicantListToUpdate = new List<Job_Applicants__c>();

    try {
      List<Job_Applicants__c> applicants = [
        SELECT Id, Application_Status__c
        FROM Job_Applicants__c
        WHERE CandidateId__c IN :applicantId
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
  public static string getApplicantStatus(string applicantId) {
    string status;
    for (Job_Applicants__c applicant : [
      SELECT Application_Status__c
      FROM Job_Applicants__c
      WHERE CandidateId__c = :applicantId
    ]) {
      status = applicant.Application_Status__c;
    }
    return status;
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
      candidateSkillsLower.add(skill.normalizeSpace().toLowerCase());
    }

    List<String> requiredSkillsLower = new List<String>();
    for (String skill : requiredSkills) {
      requiredSkillsLower.add(skill.normalizeSpace().toLowerCase());
    }

    System.debug('candidateSkillsLower-------->' + candidateSkillsLower);
    System.debug('requiredSkillsLower-------->' + requiredSkillsLower);

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
