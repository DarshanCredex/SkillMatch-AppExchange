/**
 * @description       : candidate profile controller
 * @author            : Darshan Yadav
 * @group             :
 * @last modified on  : 04-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class CandidateProfileController {
  @AuraEnabled(cacheable=true)
  public static Candidate_Details__c getCandidateDetails(Id userId) {
    try {
      List<Candidate_Details__c> currentCandidate = [
        SELECT
          Id,
          Profile_Picture__c,
          Name,
          Candidate_Email__c,
          CTC__c,
          Date_of_birth__c,
          About__c,
          Phone_Number__c,
          Skills__c,
          Experience__c,
          City__c,
          Country__c,
          (
            SELECT
              Id,
              Name,
              Organisation__c,
              From_Date__c,
              To_Date__c,
              City__c,
              Country__c
            FROM Work_Experience__r
            ORDER BY From_Date__c DESC
          )
        FROM Candidate_Details__c
        WHERE User__c = :userId
      ];
      if (currentCandidate.size() > 0) {
        return currentCandidate[0];
      } else {
        return new Candidate_Details__c();
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static Map<ID, String> getResume(Id userId) {
    list<Candidate_Details__c> candidateDetails = [
      SELECT Id
      FROM Candidate_Details__c
      WHERE User__c = :userId
      LIMIT 1
    ];
    List<ContentDocumentLink> files = [
      SELECT ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :candidateDetails[0].Id
      LIMIT 1
    ];
    List<ID> fileIDs = new List<ID>();
    for (ContentDocumentLink docLink : files) {
      fileIDs.add(docLink.ContentDocumentId);
    }

    List<ContentVersion> docs = [
      SELECT ContentDocumentId, FileExtension, Title
      FROM ContentVersion
      WHERE ContentDocumentId IN :fileIDs
    ];
    Map<ID, String> mapIdTitle = new Map<ID, String>();
    for (ContentVersion docLink : docs) {
      mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
    }
    return mapIdTitle;
  }
}
