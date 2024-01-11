/**
 * @description       : used for fetching candidate details who have applied for a job using our junction object - job applicant
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JobApplicantController {
  @AuraEnabled(cacheable=true)
  public static list<Candidate_Details__c> fetchCandidateNames(string jobId) {
    system.debug('jobId----->' + jobId);

    list<Job_Applicants__c> candidateIdList = new List<Job_Applicants__c>();
    list<Candidate_Details__c> candidateRecords = new List<Candidate_Details__c>();

    try {
      for (Job_Applicants__c applicant : [
        SELECT CandidateId__c
        FROM Job_Applicants__c
        WHERE Job_Id__c = :jobId
      ]) {
        candidateIdList.add(applicant);
      }
      system.debug('candidateIdList-------->' + candidateIdList);
      string query = 'select About__c, Candidate_Email__c, City__c, Country__c, CreatedById, Experience__c, LastModifiedById, Name, OwnerId, Phone_Number__c, Skills__c from Candidate_Details__c where id in :candidateIdList';
      candidateRecords = Database.query(query);
    } catch (Exception e) {
      system.debug(
        'errror------>' + e.getMessage() + '------->' + e.getLineNumber()
      );
    }
    system.debug('candidateRecords--------->'+candidateRecords);
    return candidateRecords;
  }
}
