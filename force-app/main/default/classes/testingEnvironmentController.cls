/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class testingEnvironmentController {
    @AuraEnabled(cacheable=true)
  public static string getTestTimings(Id jobId) {
    try {
      return [SELECT Test_Timing__c FROM Job__c WHERE id = :jobId LIMIT 1][0].Test_Timing__c;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}