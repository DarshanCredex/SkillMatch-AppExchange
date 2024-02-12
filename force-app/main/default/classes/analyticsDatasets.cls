/**
 * @description       : this class includes datasets for the analytics component
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 02-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class analyticsDatasets {
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
  public static List<DataSet> AgeWithNumberOfApplicants() {
    List<DataSet> dataset = new List<DataSet>();

    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c WHERE status__c = 'Completed']) {
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

      List<Date> dobList = new List<Date>();

      for (Candidate_Details__c candidate : [
        SELECT Date_of_birth__c
        FROM Candidate_Details__c
        WHERE Date_of_birth__c != NULL AND Id IN :jobApplicantIdList
      ]) {
        dobList.add(candidate.Date_of_birth__c);
        system.debug('dobList------->' + dobList);
      }

      Map<String, Integer> ageMap = new Map<String, Integer>();

      for (Date dob : dobList) {
        calculateAge newInstance = new calculateAge();
        String ageGroup = newInstance.calculateAgeMethod(dob);
        if (ageMap.containsKey(ageGroup)) {
          ageMap.put(ageGroup, ageMap.get(ageGroup) + 1);
        } else {
          ageMap.put(ageGroup, 1);
        }
      }

      for (String age : ageMap.keySet()) {
        dataset.add(new DataSet(age, ageMap.get(age)));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' -------> ' + e.getLineNumber()
      );
    }
    System.debug('DataSet-------> ' + dataset);
    return dataset;
  }
  @AuraEnabled(cacheable=true)
  public static List<DataSet> applicantGender() {
    List<DataSet> dataset = new List<DataSet>();
    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c WHERE status__c = 'Completed']) {
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

      list<AggregateResult> listOfGender = [
        SELECT count(id) cnt, Gender__c
        FROM Candidate_Details__c
        WHERE id IN :jobApplicantIdList
        GROUP BY Gender__c
      ];

      for (AggregateResult result : listOfGender) {
        String gender = (string) result.get('Gender__c');
        Integer count = (integer) result.get('cnt');
        dataset.add(new dataset(gender, count));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' -------> ' + e.getLineNumber()
      );
    }
    system.debug('dataset------>' + dataset);
    return dataset;
  }

  @AuraEnabled(cacheable=true)
  public static list<dataset> industryJobsDataset() {
    List<DataSet> dataset = new List<DataSet>();
    try {
      list<AggregateResult> results = [
        SELECT count(id) cnt, Industry__c
        FROM Job__c
        WHERE status__c = 'Completed'
        GROUP BY Industry__c
      ];
      for (AggregateResult result : results) {
        string Industry = (string) result.get('Industry__c');
        integer count = (integer) result.get('cnt');
        dataset.add(new dataset(Industry, count));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' -------> ' + e.getLineNumber()
      );
    }
    system.debug('dataset----->' + dataset);
    return dataset;
  }
}