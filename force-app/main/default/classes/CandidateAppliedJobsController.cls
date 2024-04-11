/**
 * @description       : candidate applied jobs controller class
 * @author            : Sagar Medatwal
 * @group             :
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class CandidateAppliedJobsController {
  public class JobWrapper {
    @AuraEnabled
    public Integer appliedCount { get; set; }
    @AuraEnabled
    public Integer shortListedCount { get; set; }
    @AuraEnabled
    public Integer pendingCount { get; set; }
    @AuraEnabled
    public List<JobListWrapper> jobWrapperList { get; set; }

    public JobWrapper() {
      jobWrapperList = new List<JobListWrapper>();
    }
  }

  public class JobListWrapper {
    @AuraEnabled
    public Id jobId { get; set; }
    @AuraEnabled
    public Integer daysAgo { get; private set; }
    @AuraEnabled
    public String title { get; set; }
    @AuraEnabled
    public String company { get; set; }
    @AuraEnabled
    public String jobType { get; set; }
    @AuraEnabled
    public Decimal salary { get; set; }
    @AuraEnabled
    public String city { get; set; }
    @AuraEnabled
    public String country { get; set; }
    @AuraEnabled
    public String status { get; set; }
    @AuraEnabled
    public boolean questionsPresent { get; set; }
    @AuraEnabled
    public boolean assesmentStatus { get; set; }

    public JobListWrapper(
      Job__c job,
      String jobStatus,
      boolean questionsPresent,
      boolean assesmentStatus
    ) {
      this.jobId = job.Id;
      this.daysAgo = calculateDaysAgo(job.CreatedDate);
      this.title = job.Title_of_position__c;
      this.company = job.Company_Name__c;
      this.jobType = job.Type__c;
      this.salary = job.Salary__c;
      this.city = job.City__c;
      this.country = job.Country__c;
      this.status = jobStatus;
      this.questionsPresent = questionsPresent;
      this.assesmentStatus = assesmentStatus;
    }

    private Integer calculateDaysAgo(Datetime createdDate) {
      Datetime currentDate = Datetime.now();
      Long millisecondsAgo = currentDate.getTime() - createdDate.getTime();
      Integer daysAgo = (millisecondsAgo / (1000 * 60 * 60 * 24)).intValue();
      return daysAgo;
    }
  }

  @AuraEnabled(cacheable=true)
  public static JobWrapper getAppliedJobs(
    String searchTitle,
    String searchCompany,
    Id userId,
    String statusFilter
  ) {
    List<Candidate_Details__c> candidateDetails = [
      SELECT
        Id,
        (SELECT Id, Application_Status__c, Job_Id__c FROM Job_Applicants__r)
      FROM Candidate_Details__c
      WHERE User__c = :userId
      LIMIT 1
    ];
    Set<Id> candidateApplicationId = new Set<Id>();
    Map<Id, String> jobStatusMap = new Map<Id, String>();
    JobWrapper wrappedAppliedJobs = new JobWrapper();
    wrappedAppliedJobs.appliedCount = 0;
    wrappedAppliedJobs.shortListedCount = 0;
    wrappedAppliedJobs.pendingCount = 0;

    if (candidateDetails.size() > 0) {
      List<Job_Applicants__c> jobApp = candidateDetails[0].Job_Applicants__r;
      if (jobApp.size() > 0) {
        wrappedAppliedJobs.appliedCount = jobApp.size();
        for (Job_Applicants__c application : jobApp) {
          jobStatusMap.put(
            application.Job_Id__c,
            application.Application_Status__c
          );
          candidateApplicationId.add(application.Job_Id__c);
          if (application.Application_Status__c == 'Accepted') {
            jobStatusMap.put(application.Job_Id__c, 'Shortlisted');
            wrappedAppliedJobs.shortListedCount++;
          } else if (application.Application_Status__c == 'Pending') {
            wrappedAppliedJobs.pendingCount++;
          }
        }
      }
    }

    String query = 'SELECT Id, CreatedDate, City__c, Country__c, Salary__c, Title_of_position__c, Type__c, Company_Name__c FROM Job__c Where Id IN :candidateApplicationId AND Status__c = \'Completed\'';

    List<String> dynamicConditions = new List<String>();
    searchTitle = '%' + searchTitle + '%';
    searchCompany = '%' + searchCompany + '%';
    if (String.isNotBlank(searchTitle)) {
      dynamicConditions.add('Title_of_position__c LIKE :searchTitle');
    }

    if (String.isNotBlank(searchCompany)) {
      dynamicConditions.add('Company_Name__c LIKE :searchCompany');
    }

    if (!dynamicConditions.isEmpty()) {
      query += ' AND ' + String.join(dynamicConditions, ' AND ');
    }

    List<Job__c> jobs = Database.query(query);

    List<JobListWrapper> wrappedJobs = new List<JobListWrapper>();
    for (Job__c job : jobs) {
      integer questionsCount = [
        SELECT COUNT()
        FROM Question__c
        WHERE job__c = :job.id
      ];
      boolean questionPresent = (questionsCount > 0);
      String jobStatus = jobStatusMap.get(job.Id);
      boolean assesmentStatus;
      string status = testingEnvironmentController.getAssesmentStatus(
        userId,
        job.Id
      );
      if (status == 'Pending') {
        assesmentStatus = false;
      } else {
        assesmentStatus = true;
      }

      System.debug('questionPresent----->' + questionPresent);
      wrappedJobs.add(
        new JobListWrapper(job, jobStatus, questionPresent, assesmentStatus)
      );
    }
    if (!wrappedJobs.isEmpty()) {
      wrappedAppliedJobs.jobWrapperList.addAll(wrappedJobs);
    }
    return wrappedAppliedJobs;
  }
}
