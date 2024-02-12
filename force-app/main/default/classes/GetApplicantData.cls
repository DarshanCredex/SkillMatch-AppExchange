/**
 * @description       : This class is used for fetching the applcant data and work experience
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 02-12-2024
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
        Job_Title__c
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
    ];

    system.debug('workExpList'+workExpList);
    return workExpList;
  }
}
