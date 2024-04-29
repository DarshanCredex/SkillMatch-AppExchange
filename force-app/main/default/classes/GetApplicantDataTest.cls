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
private class GetApplicantDataTest {
  // Test Data
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

  private static List<Work_Experience__c> createWorkExperienceList(
    Id candidateId
  ) {
    List<Work_Experience__c> workExpList = new List<Work_Experience__c>{
      new Work_Experience__c(
        CandidateId__c = candidateId,
        City__c = 'City1',
        Country__c = 'Country1',
        Name = 'Work Experience 1',
        From_Date__c = Date.newInstance(2020, 1, 1),
        To_Date__c = Date.newInstance(2022, 12, 31),
        Is_Current_Company__c = false,
        Organisation__c = 'Company A',
        Skills__c = 'Java, SQL'
      )
    };
    insert workExpList;
    return workExpList;
  }

  @isTest
  static void TestGetApplicantDataMethod() {
    Candidate_Details__c candidate = createCandidateDetails();

    List<Candidate_Details__c> result = GetApplicantData.GetApplicantDataMethod(
      candidate.Id
    );

    System.assertEquals(1, result.size());
    System.assertEquals('1234567890', result[0].Phone_Number__c);
  }

  @isTest
  static void TestGetAppliedJobById() {
    Candidate_Details__c candidate = createCandidateDetails();
    Job__c job = createJob();

    user user = createDummyUser();

    List<Job__c> result = GetApplicantData.getAppliedJobById(job.id, user.id);

    System.assertEquals(1, result.size());
  }

  @isTest
  static void TestGetWorkExperienceData() {
    Candidate_Details__c candidate = createCandidateDetails();
    list<Work_Experience__c> workexpList = createWorkExperienceList(
      candidate.id
    );

    list<Work_Experience__c> result = GetApplicantData.GetWorkExperienceData(
      candidate.id
    );

    System.assertEquals(1, result.size());
  }

  @isTest
  static void testGetResume() {
    Candidate_Details__c candidate = createCandidateDetails();
    ContentVersion contentVersion = new ContentVersion(
      Title = 'Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );

    insert contentVersion;

    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument limit 1
    ];
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.LinkedEntityId = candidate.id;
    cdl.ContentDocumentId = documents[0].Id;
    cdl.shareType = 'V';
    insert cdl;

    Test.startTest();
    Map<Id, String> result = GetApplicantData.getResume(candidate.Id);
    Test.stopTest();
    System.assertEquals(1, result.size());
  }
}
