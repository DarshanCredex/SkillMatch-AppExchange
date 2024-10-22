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
private class JobListControllerTest {
  @isTest
  static void testGetTypeValues() {
    list<string> typeValues = JobListController.getTypeValues();

    System.assertEquals(3, typeValues.size());
    System.assert(typeValues.contains('Contract'));
  }

  @isTest
  static void testGetIndustryValues() {
    list<string> industryValues = JobListController.getIndustryValues();

    System.assertEquals(10, industryValues.size());
    System.assert(industryValues.contains('Information Technology'));
  }

  @isTest
  static void testExperienceValues() {
    list<string> experienceValues = JobListController.getExperienceValues();

    System.assertEquals(5, experienceValues.size());
    System.assert(experienceValues.contains('no experience needed'));
  }

  @isTest
  static void testGetJobList() {
    List<Job__c> testJobs = new List<Job__c>();
    Job__c job = TestDataFactory.createJob();
    testJobs.add(job);

    System.assertEquals(
      JobListController.getJobList(
          'Sales Manager',
          'Gurgaon',
          new List<string>{ 'Temporary' },
          new List<string>{ '1 to 3 years' },
          new List<string>{ 'Information Technology' }
        )
        .size(),
      1
    );
  }
}
