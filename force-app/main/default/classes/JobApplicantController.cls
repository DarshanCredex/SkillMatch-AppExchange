/**
 * @description       : controller for job Applicants custom object
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JobApplicantController {
  public class DataSet {
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public Integer count { get; set; }

    public DataSet(String label, Integer count) {
      this.label = label;
      this.count = count;
    }
  }

  @AuraEnabled(cacheable=true)
  public static List<Candidate_Details__c> fetchCandidateNames(string jobId) {
    system.debug('jobId----->' + jobId);

    List<Job_Applicants__c> candidateIdList = new List<Job_Applicants__c>();
    List<Candidate_Details__c> candidateRecords = new List<Candidate_Details__c>();

    try {
      for (Job_Applicants__c applicant : [
        SELECT CandidateId__c
        FROM Job_Applicants__c
        WHERE Job_Id__c = :jobId
      ]) {
        candidateIdList.add(applicant);
      }
      system.debug('candidateIdList-------->' + candidateIdList);
      String query = 'select About__c, Candidate_Email__c, City__c, Country__c, CreatedById, Experience__c, LastModifiedById, Name, OwnerId, Phone_Number__c, Skills__c from Candidate_Details__c where id in :candidateIdList';
      candidateRecords = Database.query(query);
    } catch (Exception e) {
      system.debug(
        'Error: ' + e.getMessage() + ' at line ' + e.getLineNumber()
      );
    }
    system.debug('candidateRecords--------->' + candidateRecords);
    return candidateRecords;
  }

  @AuraEnabled(cacheable=true)
  public static List<DataSet> getApplicantDataset() {
    List<DataSet> dataSet = new List<DataSet>();

    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c]) {
        jobIdList.add(job.Id);
      }

      List<Id> jobApplicantIdList = new List<Id>();
      for (Job_Applicants__c jobApplicant : [
        SELECT CandidateId__c
        FROM Job_Applicants__c
        WHERE Job_Id__c IN :jobIdList
      ]) {
        jobApplicantIdList.add(jobApplicant.CandidateId__c);
      }
      system.debug('jobApplicantIdList------------->' + jobApplicantIdList);
      List<AggregateResult> results = [
        SELECT COUNT(Id) cnt, City__c
        FROM Candidate_Details__c
        WHERE Id IN :jobApplicantIdList
        GROUP BY City__c
      ];

      system.debug('results--------->' + results);

      for (AggregateResult ar : results) {
        String City = (String) ar.get('City__c');
        Integer total = (Integer) ar.get('cnt');
        dataSet.add(new DataSet(City, total));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' at line ' + e.getLineNumber()
      );
    }

    System.debug('DataSet: ' + dataSet);
    return dataSet;
  }

  @AuraEnabled(cacheable=true)
  public static List<Candidate_Details__c> getApplicantsList() {
    List<Candidate_Details__c> appliedCandidateDetailsList = new List<Candidate_Details__c>();

    try {
      List<Job_Applicants__c> applicantList = [
        SELECT CandidateId__c
        FROM Job_Applicants__c
        ORDER BY CreatedDate
        LIMIT 3
      ];

      List<Id> candidateIds = new List<Id>();
      for (Job_Applicants__c applicant : applicantList) {
        candidateIds.add(applicant.CandidateId__c);
      }

      if (!candidateIds.isEmpty()) {
        appliedCandidateDetailsList = [
          SELECT Name, Candidate_Email__c, City__c, Country__c, Experience__c
          FROM Candidate_Details__c
          WHERE Id IN :candidateIds
        ];
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    System.debug(
      'appliedCandidateDetailsList------>' + appliedCandidateDetailsList
    );
    return appliedCandidateDetailsList;
  }

  @AuraEnabled(cacheable=true)
  public static integer getNumberOfJobsPosted() {
    return [SELECT COUNT() FROM Job__c WHERE Status__c = 'Completed'];
  }
  @AuraEnabled(cacheable=true)
  public static integer getNumberOfApplicants() {
    return [SELECT COUNT() FROM Job_Applicants__c];
  }
}
