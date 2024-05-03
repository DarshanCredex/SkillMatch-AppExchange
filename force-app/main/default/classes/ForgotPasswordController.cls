/**
* An apex page controller that exposes the site forgot password functionality
*/
public with sharing class ForgotPasswordController {
    public String email {get; set;}   
    
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(email);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {  			
            return pr;
        }
        return null;
    }
    
    public PageReference onCancel() {
        PageReference page = Page.CandidateLoginSetup;
        page.setRedirect(true);
        return page;
    }
}