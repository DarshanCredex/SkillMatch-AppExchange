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
  private static user createDummyUser() {
    User dummyUser = new User(
      FirstName = 'Test',
      LastName = 'User',
      Email = 'test@example.com',
      Username = 'te1212121st@example.com',
      Alias = 'testu',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Los_Angeles',
      CompanyName = 'ABC',
      ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
      .Id
    );
    insert dummyUser;
    return dummyUser;
  }
  private static Candidate_Details__c createCandidateDetails() {
    Candidate_Details__c candidate = new Candidate_Details__c(
      About__c = 'About the candidate',
      City__c = 'City',
      Country__c = 'Country',
      Candidate_Email__c = 'candidate@example.com',
      Gender__c = 'Male',
      Name = 'John Doe',
      Phone_Number__c = '1234567890',
      Skills__c = 'Java, JavaScript',
      Experience__c = 5,
      Job_Title__c = 'Software Engineer'
    );
    insert candidate;
    return candidate;
  }

  private static Job__c createJob() {
    Job__c job = new Job__c(
      Title_of_position__c = 'Sales Manager',
      City__c = 'Gurgaon',
      Country__c = 'India',
      Type__c = 'Temporary',
      Experience__c = '1 to 3 years',
      Industry__c = 'Information Technology',
      Status__c = 'Completed',
      Company_Name__c = 'ABC'
    );
    insert job;
    return job;
  }

  private static Job_Applicants__c createJobApplicant(
    Id candidateId,
    Id jobId
  ) {
    Job_Applicants__c applicant = new Job_Applicants__c(
      CandidateId__c = candidateId,
      Job_Id__c = jobId,
      Application_Status__c = 'Pending'
    );
    insert applicant;
    return applicant;
  }

  @isTest
  static void TestGetApplicantsList() {
    user dummyUser = createDummyUser();
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();
    Job_Applicants__c applicant = createJobApplicant(candidate.id, job.id);

    List<Candidate_Details__c> result = JobApplicantController.getApplicantsList(
      dummyUser.id
    );

    System.assertEquals(1, result.size());
  }

  @isTest
  static void TestGetNumberOfJobsPosted() {
    user dummyUser = createDummyUser();
    Job__c job = createJob();
    integer result = JobApplicantController.getNumberOfJobsPosted(dummyUser.id);
    System.assertEquals(1, result);
  }

  @isTest
  static void TestGetNumberOfApplicants() {
    user dummyUser = createDummyUser();
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();
    Job_Applicants__c applicant = createJobApplicant(candidate.id, job.id);

    integer result = JobApplicantController.getNumberOfApplicants(dummyUser.id);

    System.assertEquals(1, result);
  }

  @isTest
  static void TestFetchJobDetails() {
    Job__c job = createJob();
    list<job__c> result = JobApplicantController.fetchJobDetails(job.id);
    System.assertEquals(1, result.size());
    System.assertEquals('Information Technology', result[0].Industry__c);
  }

  @isTest
  static void TestChangeStatus() {
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();
    Job_Applicants__c applicant = createJobApplicant(candidate.id, job.id);

    JobApplicantController.changeStatus(
      'Rejected',
      new List<Id>{ candidate.Id }
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
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();
    Job_Applicants__c applicant = createJobApplicant(candidate.id, job.id);

    string result = JobApplicantController.getApplicantStatus(candidate.id);

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
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();
    Job_Applicants__c applicant = createJobApplicant(candidate.id, job.id);

    list<JobApplicantController.CandidateWrapper> result = JobApplicantController.fetchCandidateNames(
      job.id
    );

    System.assertEquals(1, result.size());
  }
}