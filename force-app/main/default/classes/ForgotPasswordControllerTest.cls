/**
* An apex page controller that exposes the site forgot password functionality
*/
@IsTest public with sharing class ForgotPasswordControllerTest {
    @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.email = 'test@salesforce.com';     	
        
        System.assertEquals(controller.forgotPassword(),null); 
    }
    @istest
    public static void testOnCancel() {
        ForgotPasswordController controller = new ForgotPasswordController();
        
        PageReference returnPage = controller.onCancel();
        
        // Assert that the return page is the login setup page
        System.assertEquals(Page.CandidateLoginSetup.getUrl(), returnPage.getUrl());
    }
}