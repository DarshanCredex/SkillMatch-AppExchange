/**
 * @description       : apex controller for the testing environment component
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class testingEnvironmentController {
  @AuraEnabled(cacheable=true)
  public static string getTestTimings(Id jobId) {
    try {
      return [SELECT Test_Timing__c FROM Job__c WHERE id = :jobId LIMIT 1][0]
      .Test_Timing__c;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static list<Question__c> fetchQuestions(Id jobId) {
    try {
      list<Question__c> questionsList = new List<Question__c>();
      questionsList = [
        SELECT
          id,
          Question_Name__c,
          Type__c,
          Weightage__c,
          (SELECT id, Answers__c, Name, Checkbox__c FROM Options__r)
        FROM Question__c
        WHERE Job__c = :jobId
      ];
      return questionsList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
