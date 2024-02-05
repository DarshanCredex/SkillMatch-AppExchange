public class CandidateLoginSetupController {
    
    public String email { get; set; }
    public String password { get; set; }
    public Boolean hasError { get; set; }
    
    public CandidateLoginSetupController(){
        email = '';
        password = '';
    }
    
    public PageReference doLogin() {
        try {
            return Site.login(email, password, '/Candidate');
        } catch (Exception e) {
            System.debug('hasError--->'+hasError);
            hasError = true;
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email or password.'));
            return null;
        }
    }
    
    public PageReference onSignup() {
        return Page.CandidateSignUp;
    }
    
    public PageReference forgotPassword() {
        return Page.ForgotPassword;
    }
}