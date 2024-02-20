/**
 * @description       : This class is used for fetching the applcant data and work experience
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 02-20-2024
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
  public static List<ContentDocumentLink> getResume(string applicantId) {
    System.debug('applicantId------->' + applicantId);
    List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
    try {
      cdls = [
        SELECT ContentDocumentId
        FROM ContentDocumentLink
        WHERE LinkedEntityId = :applicantId
      ];
    } catch (Exception e) {
      system.debug(e.getMessage() + e.getLineNumber());
    }
    system.debug('cdls------->' + cdls);
    return cdls;
  }

  @AuraEnabled(cacheable = true)
  public static List<Job__c> getAppliedJobById(String candidateId) {
    List<Job__c> appliedJobs = new List<Job__c>();
    try {
      List<Job_Applicants__c> jobApplicants = [
        SELECT Job_Id__c
        FROM Job_Applicants__c
        WHERE CandidateId__c = :candidateId
        LIMIT 1
      ];

      Set<Id> jobIds = new Set<Id>();
      for (Job_Applicants__c jobApplicant : jobApplicants) {
        jobIds.add(jobApplicant.Job_Id__c);
      }

      appliedJobs = [
        SELECT Title_of_position__c
        FROM Job__c
        WHERE Id IN :jobIds
        LIMIT 1
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    System.debug('Applied Jobs------>' + appliedJobs);
    return appliedJobs;
  }

}
