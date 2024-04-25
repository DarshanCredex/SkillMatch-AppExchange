/**
 * @description       : apex controller for the testing environment component
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-24-2024
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
    Map<Id, String> subjectiveResponseAndId
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
        WHERE CandidateId__c = :candidateid
      ][0]
      .id;

      list<response__c> responseList = new List<response__c>();

      for (Id questionId : subjectiveResponseAndId.keySet()) {
        string res = subjectiveResponseAndId.get(questionId);
        response__c response = new response__c(
          Response_Value__c = res,
          Job_Applicants__c = applicantid,
          Question__c = questionId
        );
        responseList.add(response);
      }

      if (!responseList.isEmpty()) {
        insert responseList;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void changeAssesmentStatus(Id userId, Id jobId) {
    try {
      List<Job_Applicants__c> applicants = [
        SELECT Id, Assesment_Status__c
        FROM Job_Applicants__c
        WHERE CandidateId__r.User__c = :userId AND Job_Id__c = :jobId
        LIMIT 1
      ];
      if (!applicants.isEmpty()) {
        Job_Applicants__c applicant = applicants[0];
        applicant.Assesment_Status__c = 'Given';
        update applicant;
      } else {
        throw new AuraHandledException(
          'Applicant not found for the provided user ID and job ID.'
        );
      }
    } catch (Exception e) {
      System.debug('Exception in changeAssesmentStatus: ' + e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static String getAssesmentStatus(Id userid, Id jobid) {
    String assessmentStatus = '';
    try {
      Id candidateId = [
        SELECT Id
        FROM Candidate_Details__c
        WHERE User__c = :userid
        LIMIT 1
      ][0]
      .Id;
      Job_Applicants__c applicant = [
        SELECT Assesment_Status__c
        FROM Job_Applicants__c
        WHERE CandidateId__c = :candidateId AND Job_Id__c = :jobid
        LIMIT 1
      ];
      if (applicant != null) {
        assessmentStatus = applicant.Assesment_Status__c;
      }
    } catch (Exception e) {
      throw new AuraHandledException(
        'Error fetching assessment status: ' + e.getMessage()
      );
    }
    return assessmentStatus;
  }

  @AuraEnabled
  public static void getFeedbackFromCandidate(
    String feedback,
    Id userId,
    Id jobId
  ) {
    List<Job_Applicants__c> applicants = [
      SELECT Id, Feedback__c
      FROM Job_Applicants__c
      WHERE CandidateId__r.User__c = :userId AND Job_Id__c = :jobId
      LIMIT 1
    ];
    if (!applicants.isEmpty()) {
      Job_Applicants__c applicant = applicants[0];
      applicant.Feedback__c = feedback;
      update applicant;
    } else {
      throw new AuraHandledException('No job applicant record found for the given user and job.');
    }
  }
}
