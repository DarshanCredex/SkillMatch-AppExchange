/**
 * @description       : to retrive the list of all the jobs posted by HR(posted as well as drafts)
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 03-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/

public with sharing class GetPostedJobList {
  @AuraEnabled(cacheable=true)
  public static list<job__c> getPostedJobList(string userId) {
    system.debug('start');
    user u = [select companyName, id from user where id = :userId];
    string companyName= u.CompanyName;

    list<job__c> postedJobList = new List<job__c>();

    for (job__c job : [
      SELECT
        Title_of_position__c,
        Salary__c,
        Experience__c,
        Company_Name__c,
        City__c,
        Country__c,
        Publish_end_date__c,
        Publish_start_date__c,
        id
      FROM Job__c
      WHERE Status__c = 'Completed' AND Company_Name__c = :companyName
    ]) {
      postedJobList.add(job);
    }
    system.debug('postedJobList------->' + postedJobList);
    return postedJobList;
  }
  @AuraEnabled(cacheable=true)
  public static list<job__c> getDraftedJobList(string userId) {
    system.debug('start');

    user u = [select companyName, id from user where id = :userId];
    string companyName= u.CompanyName;
    list<job__c> draftedJobList = new List<job__c>();

    for (job__c job : [
      SELECT
        Title_of_position__c,
        Salary__c,
        Experience__c,
        Company_Name__c,
        City__c,
        Country__c,
        Publish_end_date__c,
        Publish_start_date__c,
        id
      FROM Job__c
      WHERE Status__c = 'Draft' AND Company_Name__c = :companyName
    ]) {
      draftedJobList.add(job);
    }
    system.debug('draftedJobList------->' + draftedJobList);
    return draftedJobList;
  }
}