@isTest
private class CandidateLoginSetupControllerTest {
    @isTest
    static void testDoLogin_Successful() {
        
        User testUser = TestDataFactory.createDummyUser();
        CandidateLoginSetupController controller = new CandidateLoginSetupController();
        controller.email = testUser.Email;
        controller.password = ''; 
        
        Test.startTest();
        System.runAs(testUser) {
            PageReference pageRef = controller.doLogin();
            
            System.assertEquals(null, pageRef);
        }
        Test.stopTest();
    }
    @isTest
    static void testOnSignup() {
        CandidateLoginSetupController controller = new CandidateLoginSetupController();
        Test.startTest();
        PageReference pageRef = controller.onSignup();
        System.assertEquals(Page.CandidateSignUp.getUrl(), pageRef.getUrl());
        Test.stopTest();
    }
    
    @isTest
    static void testForgotPassword() {
        CandidateLoginSetupController controller = new CandidateLoginSetupController();
        Test.startTest();
        PageReference pageRef = controller.forgotPassword();
        System.assertEquals(Page.ForgotPassword.getUrl(), pageRef.getUrl());
        Test.stopTest();
    }
}