/**
 * @description       : populate the candidate object based on data from UI
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class populateCandidateObject {
  @AuraEnabled(cacheable=true)
  public static void populateCandidateObjectMethod(string name, integer experience, string skills, string email) {
    
    system.debug('name--->' + name);
    system.debug('skills--->' + skills);
    system.debug('email------>' + email);

    try {
      list<Candidate_Details__c> candidateList = [select name, Experience__c, Skills__c, Candidate_Email__c from Candidate_Details__c limit 1];

      Candidate_Details__c newCandidate = new Candidate_Details__c();

      newCandidate.Name = name;
      newCandidate.Experience__c = experience;
      newCandidate.Skills__c = skills;
      newCandidate.Candidate_Email__c = email;

      candidateList.add(newCandidate);

      if (!candidateList.isEmpty()) {
        insert candidateList;
      }
    }
    catch(Exception e){
        system.debug('errror------>'+e.getMessage()+'------->'+e.getLineNumber());
    }
  }
}
