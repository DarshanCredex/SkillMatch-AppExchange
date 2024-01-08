/**
 * @description       : this class creates a job record in the database
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class jobObjectController {
  @AuraEnabled
  public static void jobObjectControllerMehtod(
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
      newJob.Status__c = 'Post';

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
}