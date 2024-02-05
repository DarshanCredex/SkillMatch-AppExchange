/**
 * @description       : to retrive the list of all the jobs posted by HR
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 02-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/

public with sharing class GetPostedJobList {
    @AuraEnabled(cacheable=true)
  public static list<job__c> getPostedJobList() {
    system.debug('start');

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
      WHERE Status__c = 'Completed'
    ]) {
      postedJobList.add(job);
    }
    system.debug('postedJobList------->'+postedJobList);
    return postedJobList;
  }
}