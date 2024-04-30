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
private class JobApplicantControllerTest {

  @isTest
  static void TestGetApplicantsList() {
    user dummyUser = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    List<JobApplicantController.applicantWrapper> result = JobApplicantController.getApplicantsList(
      dummyUser.id
    );

    System.assertEquals(1, result.size());
  }

  @isTest
  static void TestGetNumberOfJobsPosted() {
    user dummyUser = TestDataFactory.createDummyUser();
    Job__c job = TestDataFactory.createJob();
    integer result = JobApplicantController.getNumberOfJobsPosted(dummyUser.id);
    System.assertEquals(1, result);
  }

  @isTest
  static void TestGetNumberOfApplicants() {
    user dummyUser = TestDataFactory.createDummyUser();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    integer result = JobApplicantController.getNumberOfApplicants(dummyUser.id);

    System.assertEquals(1, result);
  }

  @isTest
  static void TestFetchJobDetails() {
    Job__c job = TestDataFactory.createJob();
    list<job__c> result = JobApplicantController.fetchJobDetails(job.id);
    System.assertEquals(1, result.size());
    System.assertEquals('Information Technology', result[0].Industry__c);
  }

  @isTest
  static void TestChangeStatus() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    JobApplicantController.changeStatus(
      'Rejected',
      new List<Id>{ candidate.Id },
      job.id
    );

    Job_Applicants__c updatedApplicant = [
      SELECT Application_Status__c
      FROM Job_Applicants__c
      WHERE id = :applicant.id
    ];

    System.assertEquals('Rejected', updatedApplicant.Application_Status__c);
  }
  @isTest
  static void TestGetApplicantStatus() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    string result = JobApplicantController.getApplicantStatus(candidate.id, job.id);

    System.assertEquals('Pending', result);
  }

  @isTest
  static void TestCalculateMatchPercentage() {
    integer result = JobApplicantController.calculateMatchPercentage(
      new Set<string>{ 'apex, javascript, lwc' },
      new Set<string>{ 'apex, javascript, lwc' },
      'apex, javascript, lwc'
    );

    System.assertEquals(100, result);
  }

  @isTest
  static void TestFetchCandidateNames() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    list<JobApplicantController.CandidateWrapper> result = JobApplicantController.fetchCandidateNames(
      job.id
    );

    System.assertEquals(1, result.size());
  }
}