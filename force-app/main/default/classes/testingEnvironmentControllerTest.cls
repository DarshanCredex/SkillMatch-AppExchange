/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
private class testingEnvironmentControllerTest {
  @isTest
  static void TestGetTestTimings() {
    Job__c job = TestDataFactory.createJob();
    job.Test_Timing__c = '15 mins';
    update job;

    string result = testingEnvironmentController.getTestTimings(job.id);

    System.assert(result != null);
    System.assertEquals('15 mins', result);
  }

  @isTest
  static void TestFetchQuestions() {
    Job__c job = TestDataFactory.createJob();
    List<Question__c> questions = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    list<Options__c> options = TestDataFactory.createSubjectiveOptions(
      questions[0].id
    );
    list<Question__c> result = testingEnvironmentController.fetchQuestions(
      job.id
    );
    System.assert(result.size() == 1);
  }

  @isTest
  static void TestGetObjectiveResponse() {
    Job__c job = TestDataFactory.createJob();
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    list<Question__c> question = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    list<options__c> options = TestDataFactory.createSubjectiveOptions(
      question[0].id
    );

    List<id> optionId = new List<id>{ options[0].id };

    Test.startTest();
    testingEnvironmentController.getObjectiveResponse(optionId, u.id, job.id);
    Test.stopTest();

    integer result = [
      SELECT COUNT()
      FROM Response__c
      WHERE Question__c = :question[0].id
    ];
    System.debug(result);
    System.assert(result != 0);
  }

  @isTest
  static void TestGetSubjectiveResponse() {
    Job__c job = TestDataFactory.createJob();
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    list<Question__c> question = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    list<options__c> options = TestDataFactory.createSubjectiveOptions(
      question[0].id
    );

    Map<id, string> subjectiveResponseMap = new Map<id, string>();
    subjectiveResponseMap.put(question[0].Id, options[0].Answers__c);

    Test.startTest();
    testingEnvironmentController.getSubjectiveResponse(
      u.id,
      subjectiveResponseMap
    );
    Test.stopTest();

    System.assert(
      [SELECT COUNT() FROM Response__c WHERE Question__c = :question[0].id] != 0
    );
  }

  @isTest
  static void TestChangeAssesmentStatus() {
    Job__c job = TestDataFactory.createJob();

    user u = TestDataFactory.createDummyUser();

    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );

    testingEnvironmentController.changeAssesmentStatus(u.id, job.id);

    string result;

    for (Job_Applicants__c app : [
      SELECT Assesment_Status__c
      FROM Job_Applicants__c
      WHERE id = :applicant.id
    ]) {
      result = app.Assesment_Status__c;
    }

    System.assert(result == 'Given');
  }

  @isTest
  static void TestGetAssesmentStatus() {
    Job__c job = TestDataFactory.createJob();
    user u = TestDataFactory.createDummyUser();

    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    applicant.Assesment_Status__c = 'Given';
    update applicant;

    string result = testingEnvironmentController.getAssesmentStatus(
      u.id,
      job.id
    );

    System.assert(result == 'Given');
  }

  @isTest
  static void TestGetFeedbackFromCandidate() {
    Job__c job = TestDataFactory.createJob();
    user u = TestDataFactory.createDummyUser();

    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );

    string feedback = 'Testing';
    string result;

    testingEnvironmentController.getFeedbackFromCandidate(
      feedback,
      u.id,
      job.id
    );

    for (Job_Applicants__c applicants : [
      SELECT Feedback__c
      FROM Job_Applicants__c
      WHERE id = :applicant.id
    ]) {
      result = applicants.Feedback__c;
    }

    System.assert(result == feedback);
  }
}
