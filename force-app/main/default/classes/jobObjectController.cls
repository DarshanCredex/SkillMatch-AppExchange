/**
 * @description       : this class creates a job record in the database
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class jobObjectController {
  @AuraEnabled
  public static void postJob(
    string jobTitle,
    string description,
    Decimal salaryRange,
    string companyName,
    string city,
    string country,
    string experienceValue,
    string typeValue,
    string industryValue,
    string summary
  ) {
    system.debug('start');
    system.debug('jobTitle' + jobTitle);

    try {
      list<job__c> jobRecordsList = new List<job__c>();
      job__c newJob = new job__c();

      newJob.Title_of_position__c = jobTitle;
      newJob.Description__c = description;
      newJob.Summary__c = summary;
      newJob.Salary__c = salaryRange;
      newJob.Industry__c = industryValue;
      newJob.Experience__c = experienceValue;
      newJob.Country__c = country;
      newJob.Company_Name__c = companyName;
      newJob.Type__c = typeValue;
      newJob.City__c = city;
      newJob.Status__c = 'Completed';

      jobRecordsList.add(newJob);

      system.debug('jobRecordsList--------->' + jobRecordsList);

      if (!jobRecordsList.isEmpty()) {
        insert jobRecordsList;
      }
    } catch (Exception e) {
      system.debug(
        'errror------>' + e.getMessage() + '------->' + e.getLineNumber()
      );
    }
  }
  @AuraEnabled
  public static void saveToDraft(
    string jobTitle,
    string description,
    Decimal salaryRange,
    string companyName,
    string city,
    string country,
    string experienceValue,
    string typeValue,
    string industryValue,
    string summary
  ) {
    System.debug('start');
    try {
      list<job__c> jobRecordsList = new List<job__c>();
      job__c newJob = new job__c();

      newJob.Title_of_position__c = jobTitle;
      newJob.Description__c = description;
      newJob.Summary__c = summary;
      newJob.Salary__c = salaryRange;
      newJob.Industry__c = industryValue;
      newJob.Experience__c = experienceValue;
      newJob.Country__c = country;
      newJob.Company_Name__c = companyName;
      newJob.Type__c = typeValue;
      newJob.City__c = city;
      newJob.Status__c = 'Draft';

      jobRecordsList.add(newJob);

      system.debug('jobRecordsList--------->' + jobRecordsList);

      if (!jobRecordsList.isEmpty()) {
        insert jobRecordsList;
      }
    } catch (Exception e) {
      system.debug(
        'errror------>' + e.getMessage() + '------->' + e.getLineNumber()
      );
    }
  }
  @AuraEnabled(cacheable=true)
  public static list<job__c> getDraftJobList() {
    System.debug('start');

    list<job__c> draftJobList = new List<job__c>();

    for (job__c job : [
      SELECT
        Title_of_position__c,
        Description__c,
        Summary__c,
        Salary__c,
        Industry__c,
        Experience__c,
        Country__c,
        Company_Name__c,
        Type__c,
        City__c,
        Status__c,
        Id
      FROM Job__c
      WHERE Status__c = 'Draft'
    ]) {
      draftJobList.add(job);
    }
    System.debug('draftJobList-------->' + draftJobList);
    return draftJobList;
  }
}