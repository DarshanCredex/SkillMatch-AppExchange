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
private class analyticsDatasetsTest {
  @isTest
  static void TestGetApplicantDataset() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );

    List<analyticsDatasets.DataSet> result = analyticsDatasets.getApplicantDataset(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestAgeWithNumberOfApplicants() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );

    List<analyticsDatasets.DataSet> result = analyticsDatasets.AgeWithNumberOfApplicants(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestApplicantGender() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );

    List<analyticsDatasets.DataSet> result = analyticsDatasets.applicantGender(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestIndustryJobsDataset() {
    user u = TestDataFactory.createDummyUser();
    Job__c job = TestDataFactory.createJob();

    list<analyticsDatasets.dataset> result = analyticsDatasets.industryJobsDataset(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestNumberOfApplicantsVsJobs() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    List<analyticsDatasets.DataSet> result = analyticsDatasets.NumberOfApplicantsVsJobs(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestNumberOfApplicantsShortlistedAndRejected() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    List<analyticsDatasets.DataSet> result = analyticsDatasets.numberOfApplicantsShortlistedAndRejected(
      u.id
    );
    System.assert(result.size() != 0);
  }

  @isTest
  static void TestNumberOfApplicantsAssessmentStatusVsJob() {
    user u = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    candidate.user__c = u.id;
    update candidate;
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicantWithAssesmentGiven(
      candidate.id,
      job.id
    );
    List<analyticsDatasets.DataSet> result = analyticsDatasets.NumberOfApplicantsAssessmentStatusVsJob(
      u.id
    );
    System.assert(result.size() != 0);
  }

   @isTest
  static void TestnumberofQuestionsVsJobPosted() {
    user u = TestDataFactory.createDummyUser();
    
    Job__c job = TestDataFactory.createJob();
    List<Question__c> question = TestDataFactory.createSubjectiveQuestion(job.id);
    List<analyticsDatasets.DataSet> result = analyticsDatasets.numberofQuestionsVsJobPosted(
      u.id
    );
    System.assert(result.size() != 0);
  }

  


}
