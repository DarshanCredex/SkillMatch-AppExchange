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

@isTest(seealldata=true)
public class recruiterSignUpControllerTest {
  @isTest
  static void TestIsValidPassword() {
    recruiterSignUpController controller = new recruiterSignUpController();
    controller.email = 'test@salesforce.com';
    controller.password = '123456';
    controller.confirmPassword = '123456';
    System.assert(controller.isValidPassword());
  }
  @isTest
  static void testOnLogin() {
    recruiterSignUpController controller = new recruiterSignUpController();
    controller.email = 'test@salesforce.com';
    controller.password = '123456';
    controller.confirmPassword = '123456';
    System.assert(controller.onLogin() != null);
  }

  @isTest
  static void TestRegisterUser_Success() {
    Account acc = new Account(name = 'SkillMatch Recruiter');
    insert acc;
    List<Account> accounts = [SELECT Id FROM Account LIMIT 1];

    System.assert(!accounts.isEmpty());
    Id accountId = accounts[0].Id;

    Contact con = new Contact(accountId = acc.id);

    String firstName = 'Test';
    string lastName = 'Testing';
    string email = 'test@skillmatch.com';
    string password = '123456';
    string confirmPassword = '123456';
    string communityNickname = 'testin';
    string CompanyName = 'ABC';

    recruiterSignUpController controller = new recruiterSignUpController();
    System.assert(controller.registerUser()==null);
  }

   @isTest
  static void TestRegisterUser_Fail() {
    Account acc = new Account(name = 'SkillMatch Recruiter');
    insert acc;
    List<Account> accounts = [SELECT Id FROM Account LIMIT 1];

    System.assert(!accounts.isEmpty());
    Id accountId = accounts[0].Id;

    Contact con = new Contact(accountId = acc.id);

    String firstName = 'Test';
    string lastName = 'Testing';
    string email = 'test@skillmatch.com';
    string password = '123456';
    string confirmPassword = '1234221156';
    string communityNickname = 'testin';
    string CompanyName = 'ABC';

    recruiterSignUpController controller = new recruiterSignUpController();
     System.assert(controller.registerUser()==null);
  }
}
