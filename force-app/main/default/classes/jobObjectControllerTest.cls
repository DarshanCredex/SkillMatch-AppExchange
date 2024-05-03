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
public class jobObjectControllerTest {
  @isTest
  static void TestGetDraftJobList() {
    Job__c job = TestDataFactory.createDraft();
    user u = TestDataFactory.createDummyUser();
    list<Job__c> result = jobObjectController.getDraftJobList(u.id);
    System.assertEquals(1, result.size());
  }
  @isTest
  static void TestGetPostedJobListBasedOnId() {
    Job__c job = TestDataFactory.createJob();
    list<job__c> result = jobObjectController.getPostedJobListBasedOnId(job.id);
    System.assertEquals(1, result.size());
  }
  @isTest
  static void TestGetTestTimings() {
    Job__c job = TestDataFactory.createJob();
    string result = jobObjectController.getTestTimings(job.id);
    System.assertEquals('15 mins', result);
  }
  @isTest
  static void TestGetCompanyName() {
    user u = TestDataFactory.createDummyUser();
    string result = jobObjectController.getCompanyName(u.id);
    System.assertEquals('ABC', result);
  }
  @isTest
  static void TestDeleteJob() {
    Job__c job = TestDataFactory.createJob();
    test.startTest();
    jobObjectController.deleteJob(job.id);
    test.stopTest();
    System.assertEquals(
      0,
      [SELECT Id FROM Job__c WHERE Id = :job.id LIMIT 1].size()
    );
  }

  @isTest
  static void testPostJob() {
    String jobTitle = 'Software Engineer';
    String description = 'Develop software applications.';
    Decimal salaryRange = 10000.00;
    String companyName = 'Acme Corporation';
    String city = 'San Francisco';
    String country = 'USA';
    String experienceValue = '1 to 3 years';
    String typeValue = 'Temporary';
    String industryValue = 'Information Technology';
    String summary = 'Looking for a skilled software engineer.';
    String skills = 'Java, Python, SQL';
    String timing = '15 mins';
    Date publishStartDate = Date.today();
    Date publishEndDate = Date.today().addDays(30);

    jobObjectController.postJob(
      'Draft',
      jobTitle,
      description,
      salaryRange,
      companyName,
      city,
      country,
      experienceValue,
      typeValue,
      industryValue,
      summary,
      skills,
      timing,
      publishStartDate,
      publishEndDate
    );

    Job__c[] insertedJobs = [
      SELECT Id
      FROM Job__c
      WHERE Title_of_position__c = :jobTitle
      LIMIT 1
    ];

    System.assertNotEquals(0, insertedJobs.size());
  }
}
