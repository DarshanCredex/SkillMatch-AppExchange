/**
 * @description       : insert candidate data in records
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 03-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public without sharing class registerCandidateController {
    @AuraEnabled
  public static void candidateResgisterMethod(
    string firstName,
    String lastName,
    string email,
    string password
  ) {
    try {
      list<Candidate_Details__c> candidateList = new List<Candidate_Details__c>();
      Candidate_Details__c candidate = new Candidate_Details__c();

      candidate.Name = firstName + ' ' + lastName;
      candidate.Candidate_Email__c = email;
      candidate.Password__c = password;

      candidateList.add(candidate);
      if (!candidateList.isEmpty()) {
        insert candidate;
      }
    } catch (Exception e) {
      system.debug(
        'errror------>' + e.getMessage() + '------->' + e.getLineNumber()
      );
    }
  }
}
