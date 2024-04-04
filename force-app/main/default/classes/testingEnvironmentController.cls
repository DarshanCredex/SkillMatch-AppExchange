/**
 * @description       : apex controller for the testing environment component
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class testingEnvironmentController {
  @AuraEnabled(cacheable=true)
  public static string getTestTimings(Id jobId) {
    try {
      Job__c job = [SELECT Test_Timing__c FROM Job__c WHERE id = :jobId];
      return job.Test_Timing__c;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static list<Question__c> fetchQuestions(Id jobId) {
    try {
      list<Question__c> questionsList = new List<Question__c>();
      questionsList = [
        SELECT
          id,
          Question_Name__c,
          Type__c,
          Weightage__c,
          (SELECT id, Answers__c, Name, Checkbox__c FROM Options__r)
        FROM Question__c
        WHERE Job__c = :jobId
      ];
      return questionsList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static void calculateObjectiveScore(list<id> optionId) {
    Decimal score = 0;
    try {
      list<Options__c> optionsDetails = new List<Options__c>();
      optionsDetails = [
        SELECT Answers__c, Question__c, Checkbox__c, Question__r.Weightage__c
        FROM Options__c
        WHERE id IN :optionId
      ];
      for (Options__c option : optionsDetails) {
        if (option.Checkbox__c == true) {
          score = score + option.Question__r.Weightage__c;
        }
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void getObjectiveResponse(
    List<Id> optionId,
    Id userId,
    Id jobId
  ) {
    Id candidateId;
    Id applicantId;

    List<Candidate_Details__c> candidateDetails = [
      SELECT Id
      FROM Candidate_Details__c
      WHERE User__c = :userId
      LIMIT 1
    ];
    if (!candidateDetails.isEmpty()) {
      candidateId = candidateDetails[0].Id;
      List<Job_Applicants__c> jobApplicants = [
        SELECT Id
        FROM Job_Applicants__c
        WHERE CandidateId__c = :candidateId AND Job_Id__c = :jobId
        LIMIT 1
      ];
      if (!jobApplicants.isEmpty()) {
        applicantId = jobApplicants[0].Id;
        List<Options__c> optionsList = [
          SELECT Answers__c, Question__c
          FROM Options__c
          WHERE Id IN :optionId
        ];
        List<Response__c> responseList = new List<Response__c>();

        for (Options__c option : optionsList) {
          Response__c response = new Response__c();
          response.Response_Value__c = option.Answers__c;
          response.Job_Applicants__c = applicantId;
          response.Question__c = option.Question__c;
          responseList.add(response);
        }
        System.debug('responseList' + responseList);
        if (!responseList.isEmpty()) {
          insert responseList;
        }
      } else {
        System.debug('No Job Applicant found for Candidate');
      }
    } else {
      System.debug('No Candidate found for User');
    }
  }

  @AuraEnabled
  public static void getSubjectiveResponse(
    id userid,
    Map<Id, String[]> subjectiveResponseAndId
  ) {
    try {
      id candidateid = [
        SELECT id
        FROM Candidate_Details__c
        WHERE user__c = :userid
      ][0]
      .id;

      id applicantid = [
        SELECT id
        FROM Job_applicants__c
        WHERE CandidateId__c = :applicantid
      ][0]
      .id;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
