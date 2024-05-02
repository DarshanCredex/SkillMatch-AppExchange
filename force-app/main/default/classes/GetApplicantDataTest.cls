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
  @isTest
  static void TestGetApplicantDataMethod() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();

    List<Candidate_Details__c> result = GetApplicantData.GetApplicantDataMethod(
      candidate.Id
    );

    System.assertEquals(1, result.size());
    System.assertEquals('1234567890', result[0].Phone_Number__c);
  }

  @isTest
  static void TestGetAppliedJobById() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job__c job = TestDataFactory.createJob();
    user user = TestDataFactory.createDummyUser();
    List<Job__c> result = GetApplicantData.getAppliedJobById(job.id, user.id);
    System.assertEquals(1 ,result.size());
  }

  @isTest
  static void TestGetWorkExperienceData() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    list<Work_Experience__c> workexpList = TestDataFactory.createWorkExperienceList(
      candidate.id
    );

    list<Work_Experience__c> result = GetApplicantData.GetWorkExperienceData(
      candidate.id
    );

    System.assertEquals(1, result.size());
  }

  @isTest
  static void testGetResume() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    ContentVersion contentVersion = new ContentVersion(
      Title = 'Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );

    insert contentVersion;

    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
      LIMIT 1
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
