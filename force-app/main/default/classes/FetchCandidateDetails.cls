/**
 * @description       : used to fetch details from the candidate object and display on HR portal
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class FetchCandidateDetails {
  @AuraEnabled(cacheable=true)
  public static list<Candidate_Details__c> fetchAllCandidateDetails(
    string recordId
  ) {
    system.debug('start');
    system.debug('recordid------>' + recordid);
    string query =
      'select Candidate_Email__c, City__c, Country__c, Experience__c, Name, About__c, Phone_Number__c, Skills__c from Candidate_Details__c where id = \'' +
      recordid +
      '\'';
    List<Candidate_Details__c> objectRecords = new List<Candidate_Details__c>();

    try {
      objectRecords = Database.query(query);
    } catch (Exception e) {
      System.debug(
        'Error fetching data------->' +
          e.getMessage() +
          '------->' +
          e.getLineNumber()
      );
    }
    system.debug('objectRecords-------->' + objectRecords);
    return objectRecords;
  }
  @AuraEnabled(cacheable=true)
  public static list<Work_Experience__c> fetchWorkExperience(string recordId) {
    system.debug('start');
    string query =
      'select Organisation__c, To_Date__c, From_Date__c, City__c, Country__c, Skills__c from Work_Experience__c where CandidateId__c = \'' +
      recordId +
      '\'';
    list<Work_Experience__c> objectRecords = new List<Work_Experience__c>();
    try {
      objectRecords = Database.query(query);
    } catch (Exception e) {
      System.debug(
        'Error fetching data------->' +
          e.getMessage() +
          '------->' +
          e.getLineNumber()
      );
    }
    system.debug('objectRecords-------->' + objectRecords);
    return objectRecords;
  }
}
