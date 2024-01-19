/**
 * @description       : recruiter login page controller class
 * @author            : Rudransh Shukla
 * @group             : 
 * @last modified on  : 01-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class recruiterLoginController {
    public String username { get; set; }
    public String password { get; set; }

    public recruiterLoginController(){
        username = '';
        password = '';
    }

    public PageReference doLogin() {
        try {
            return Site.login(username, password, '/Recruiter');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid username or password.'));
            return null;
        }
    }

    public PageReference onSignup() {
        return Page.recruiterSignUp;
    }
    
    public PageReference forgotPassword() {
        return Page.ForgotPassword;
    }
}