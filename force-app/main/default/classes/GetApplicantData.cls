/**
 * @description       : This class is used for fetching the applcant data and work experience
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class GetApplicantData {
  @AuraEnabled(cacheable=true)
  public static list<Candidate_Details__c> GetApplicantDataMethod(
    string applicantId
  ) {
    system.debug('applicantId------>' + applicantId);
    list<Candidate_Details__c> candidateDetails = [
      SELECT
        Id,
        About__c,
        City__c,
        Country__c,
        CTC__c,
        Date_of_birth__c,
        Candidate_Email__c,
        Gender__c,
        Name,
        Phone_Number__c,
        Skills__c,
        Experience__c,
        Job_Title__c,
        Profile_Picture__c
      FROM Candidate_Details__c
      WHERE id = :applicantId
    ];
    return candidateDetails;
  }

  @AuraEnabled(cacheable=true)
  public static list<Work_Experience__c> GetWorkExperienceData(
    string applicantId
  ) {
    system.debug('applicantId------>' + applicantId);
    list<Work_Experience__c> workExpList = [
      SELECT
        CandidateId__c,
        City__c,
        Country__c,
        CreatedById,
        Name,
        From_Date__c,
        Is_Current_Company__c,
        LastModifiedById,
        Organisation__c,
        Skills__c,
        To_Date__c,
        Id
      FROM Work_Experience__c
      WHERE CandidateId__c = :applicantId
      ORDER BY To_Date__c DESC
    ];

    system.debug('workExpList' + workExpList);
    return workExpList;
  }

  @AuraEnabled(cacheable=true)
  public static list<Job__c> getAppliedJobById(id jobId, id userId) {
    user u = [SELECT companyName, id FROM user WHERE id = :userId];
    string companyName = u.CompanyName;
    try {
      return [
        SELECT Title_of_position__c
        FROM Job__c
        WHERE Company_Name__c = :companyName AND id = :jobid
        LIMIT 1
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static Map<ID, String> getResume(String applicantId) {
    list<Candidate_Details__c> candidateDetails = [
      SELECT Id
      FROM Candidate_Details__c
      WHERE id = :applicantId
      LIMIT 1
    ];
    List<ContentDocumentLink> files = [
      SELECT ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :candidateDetails[0].Id
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
