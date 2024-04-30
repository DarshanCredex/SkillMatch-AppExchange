/**
 * @description       : this class includes datasets for the analytics component
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-12-2024
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
  public static List<DataSet> getApplicantDataset(string userId) {
    List<DataSet> dataSet = new List<DataSet>();
    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;

    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c where Company_Name__c = :companyname]) {
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
      List<AggregateResult> results = [
        SELECT COUNT(Id) cnt, City__c
        FROM Candidate_Details__c
        WHERE Id IN :jobApplicantIdList
        GROUP BY City__c
      ];
      for (AggregateResult ar : results) {
        String City = (String) ar.get('City__c');
        Integer total = (Integer) ar.get('cnt');
        dataSet.add(new DataSet(City, total));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' at line----> ' + e.getLineNumber()
      );
    }
    return dataSet;
  }

  @AuraEnabled(cacheable=true)
  public static List<DataSet> AgeWithNumberOfApplicants(string userId) {
    List<DataSet> dataset = new List<DataSet>();
    
    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;

    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c WHERE status__c = 'Completed' AND Company_Name__c = :companyname]) {
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
      }

      Map<String, Integer> ageMap = new Map<String, Integer>();

      for (Date dob : dobList) {
        String ageGroup = calculateAge.calculateAgeMethod(dob);
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
    return dataset;
  }
  @AuraEnabled(cacheable=true)
  public static List<DataSet> applicantGender(string userId) {
    List<DataSet> dataset = new List<DataSet>();
    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;
    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c WHERE status__c = 'Completed' AND Company_Name__c = :companyname]) {
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
    return dataset;
  }

  @AuraEnabled(cacheable=true)
  public static list<dataset> industryJobsDataset(string userId) {
    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;
    List<DataSet> dataset = new List<DataSet>();
    try {
      list<AggregateResult> results = [
        SELECT count(id) cnt, Industry__c
        FROM Job__c
        WHERE status__c = 'Completed' AND Company_Name__c =:companyname
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
    return dataset;
  }
  @AuraEnabled(cacheable=true)
  public static List<Dataset> numberOfApplicantsVsJobs(string userId) {
    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;
    List<Dataset> dataset = new List<Dataset>();
    try {
      List<Id> jobIdList = new List<Id>();
      for (Job__c job : [SELECT Id FROM Job__c WHERE Status__c = 'Completed' AND Company_Name__c =:companyname]) {
        jobIdList.add(job.Id);
      }

      List<Job__c> jobNames = [
        SELECT Title_of_position__c, Id
        FROM Job__c
        WHERE Id IN :jobIdList
      ];

      Map<Id, Integer> jobApplicantsCountMap = new Map<Id, Integer>();
      for (AggregateResult aggResult : [
        SELECT Job_Id__c, COUNT(Id) applicantsCount
        FROM Job_Applicants__c
        WHERE Job_Id__c IN :jobIdList
        GROUP BY Job_Id__c
      ]) {
        jobApplicantsCountMap.put(
          (Id) aggResult.get('Job_Id__c'),
          (Integer) aggResult.get('applicantsCount')
        );
      }
      for (Job__c job : jobNames) {
        Integer applicantsCount = jobApplicantsCountMap.containsKey(job.Id)
          ? jobApplicantsCountMap.get(job.Id)
          : 0;
        if (applicantsCount > 0) {
          dataset.add(new Dataset(job.Title_of_position__c, applicantsCount));
        }
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' -------> ' + e.getLineNumber()
      );
    }
    return dataset;
  }

  @AuraEnabled(cacheable=true)
  public static list<dataset> numberOfApplicantsShortlistedAndRejected(string userId) {

    user u = [select companyName from user where id = :userId limit 1];
    string companyname = u.CompanyName;

    List<Dataset> dataset = new List<Dataset>();
    try {
      list<AggregateResult> results = [
        SELECT count(id) cnt, Application_Status__c
        FROM Job_Applicants__c where Job_Id__c in (select id from Job__c where Company_Name__c = :companyname)
        GROUP BY Application_Status__c
      ];

      for (AggregateResult result : results) {
        string status = (string) result.get('Application_Status__c');
        integer count = (integer) result.get('cnt');
        dataset.add(new dataset(status, count));
      }
    } catch (Exception e) {
      System.debug(
        'Error--------> ' + e.getMessage() + ' -------> ' + e.getLineNumber()
      );
    }
    return dataset;
  }
}