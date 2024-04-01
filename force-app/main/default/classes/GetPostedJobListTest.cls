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
private class GetPostedJobListTest {
  @isTest
  static void TestGetPostedJobList() {

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
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id 
    );
    insert dummyUser;

    Job__c job = new Job__c(
      Title_of_position__c = 'Sales Manager',
      City__c = 'Gurgaon',
      Country__c = 'India',
      Type__c = 'Temporary',
      Experience__c = '1 to 3 years',
      Industry__c = 'Information Technology',
      Status__c = 'Completed'
    );
    insert job;

    list<job__c> result = GetPostedJobList.getPostedJobList(dummyUser.Id);

    System.assertEquals(1, result.size());
  }

  @isTest
  static void TestGetDraftedJobList(){
    User dummyUser = new User(
        FirstName = 'Tewwst',
        LastName = 'Usewwr',
        Email = 'test@example.com',
        Username = 'te1212234dd2121st@example.com',
        Alias = 'tewstu',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        TimeZoneSidKey = 'America/Los_Angeles',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id 
    );
    insert dummyUser;

    Job__c job = new Job__c(
      Title_of_position__c = 'Sales Manager',
      City__c = 'Gurgaon',
      Country__c = 'India',
      Type__c = 'Temporary',
      Experience__c = '1 to 3 years',
      Industry__c = 'Information Technology',
      Status__c = 'Draft'
    );
    insert job;

    list<job__c> result = GetPostedJobList.getDraftedJobList(dummyUser.Id);
    System.assertEquals(1, result.size());
  }
}
