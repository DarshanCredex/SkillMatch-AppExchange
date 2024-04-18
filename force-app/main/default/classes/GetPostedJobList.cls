/**
 * @description       : to retrive the list of all the jobs posted by HR(posted as well as drafts)
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/

public with sharing class GetPostedJobList {
  public class jobWrapper {
    @AuraEnabled
    public Id Id { get; set; }
    @AuraEnabled
    public String title { get; set; }
    @AuraEnabled
    public String company { get; set; }
    @AuraEnabled
    public String jobType { get; set; }
    @AuraEnabled
    public String summary { get; set; }
    @AuraEnabled
    public Decimal salary { get; set; }
    @AuraEnabled
    public String status { get; set; }
    @AuraEnabled
    public String city { get; set; }
    @AuraEnabled
    public String country { get; set; }
    @AuraEnabled
    public date publishDate { get; set; }
    @AuraEnabled
    public date endDate { get; set; }
    @AuraEnabled
    public integer applicants { get; set; }
    @AuraEnabled
    public string experience { get; set; }

    public jobWrapper(Job__c job) {
      this.Id = job.Id;
      this.title = job.Title_of_position__c;
      this.company = job.Company_Name__c;
      this.jobType = job.Type__c;
      this.summary = job.Summary__c;
      this.salary = job.Salary__c;
      this.city = job.City__c;
      this.publishDate = job.Publish_start_date__c;
      this.endDate = job.Publish_end_date__c;
      this.country = job.Country__c;
      this.applicants = getApplicants(job.id);
      this.status = job.Status__c;
      this.experience = job.Experience__c;
    }
  }
  public static Integer getApplicants(Id jobId) {
    return [
      SELECT COUNT()
      FROM Job_Applicants__c
      WHERE Job_Id__c = :jobId
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<JobWrapper> getJobs(id userId) {
    user u = [SELECT companyName, id FROM user WHERE id = :userId];
    string companyName = u.CompanyName;
    list<jobWrapper> wrappedJobs = new List<jobWrapper>();
    try {
      list<Job__c> jobs = [
        SELECT
          id,
          City__c,
          Company_Name__c,
          Country__c,
          Description__c,
          Experience__c,
          Industry__c,
          Publish_end_date__c,
          Publish_start_date__c,
          Salary__c,
          Status__c,
          Summary__c,
          Title_of_position__c,
          Type__c
        FROM Job__c
        WHERE Company_Name__c = :companyname
      ];
      for (Job__c job : jobs) {
        wrappedJobs.add(new jobWrapper(job));
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return wrappedJobs;
  }
}
