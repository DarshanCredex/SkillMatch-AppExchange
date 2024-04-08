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
public class JobDetailControllerTest {
  @isTest
  static void testGetJobDescription() {
    Account acc1 = new Account(Name = 'newAcc1');
    insert acc1;
    Contact conCase = new Contact(
      AccountId = acc1.id,
      LastName = 'portalTestUserv1'
    );
    insert conCase;

    Id profileId = [SELECT Id FROM Profile WHERE Name = 'Candidate'].Id;
    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now())
      .replace(' ', '')
      .replace(':', '')
      .replace('-', '');
    Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
    String uniqueName = orgId + dateString + randomInt;
    User tempUser = new User(
      FirstName = 'CredexUser',
      LastName = 'Test',
      email = uniqueName + '@sfdc' + orgId + '.org',
      Username = uniqueName + '@sfdc' + orgId + '.org',
      EmailEncodingKey = 'ISO-8859-1',
      Alias = uniqueName.substring(18, 23),
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US',
      ProfileId = profileId,
      contactId = conCase.Id
    );
    insert tempUser;

    List<Job__c> testJobs = new List<Job__c>();
    testJobs.add(
      new Job__c(
        Title_of_position__c = 'Java Developer',
        City__c = 'Noida',
        Country__c = 'India',
        Type__c = 'Temporary',
        Experience__c = '1 to 3 years',
        Industry__c = 'Information Technology',
        Status__c = 'Completed',
        Skills_Required__c = 'Salesforce'
      )
    );
    testJobs.add(
      new Job__c(
        Title_of_position__c = 'Sales Manager',
        City__c = 'Gurgaon',
        Country__c = 'India',
        Type__c = 'Temporary',
        Experience__c = '1 to 3 years',
        Industry__c = 'Information Technology',
        Status__c = 'Completed',
        Skills_Required__c = 'Salesforce'
      )
    );
    insert testJobs;

    String jobId = String.valueOf(testJobs[0].Id);

    Candidate_Details__c candidate = new Candidate_Details__c();
    candidate.Candidate_Email__c = uniqueName + '@sfdc' + orgId + '.org';
    candidate.User__c = tempUser.Id;
    insert candidate;
    Test.startTest();
    JobDetailController.getJobDescription(jobId);
    JobDetailController.createJobApplicants(tempUser.Id, testJobs[0].Id);
    JobDetailController.checkJobStatus(tempUser.Id, jobId);
    Test.stopTest();
    System.assertEquals(JobDetailController.getJobDescription(jobId).size(), 1);
  }
}