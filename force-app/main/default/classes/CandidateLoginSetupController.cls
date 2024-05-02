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
            hasError = true;
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