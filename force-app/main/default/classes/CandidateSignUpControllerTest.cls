@isTest
public class CandidateSignUpControllerTest {
    
    @IsTest(SeeAllData=true) static void testRegisterUser() {
        // Create test data
        Account testAccount = TestDataFactory.createAccount();
        Contact testContact = TestDataFactory.createContact(testAccount.Id);
        
        CandidateSignUpController controller = new CandidateSignUpController();
        
        controller.email = 'test@force.com';
        controller.firstName = 'John';
        controller.lastName = 'Doe';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);            
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }
    @IsTest
    static void testIsValidPassword() {
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
    }
}