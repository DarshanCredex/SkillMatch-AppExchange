public class CandidateLoginSetupController {
    
    public String username { get; set; }
    public String password { get; set; }
    
    public CandidateLoginSetupController(){
        username = '';
        password = '';
    }
    
    public PageReference doLogin() {
        try {
            return Site.login(username, password, '/Candidate');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid username or password.'));
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