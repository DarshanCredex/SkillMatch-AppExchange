/**
 * @description       : recruiter login page controller class
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 02-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class recruiterLoginController {
  public String email { get; set; }
  public String password { get; set; }

  public recruiterLoginController() {
    email = '';
    password = '';
  }

  public PageReference doLogin() {
    system.debug('email' + email);
    system.debug('pass' + password);
    try {
      return Site.login(email, password, '/HR/s');
    } catch (Exception e) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Invalid email or password.'
        )
      );
      return null;
    }
  }

  public PageReference onSignup() {
    return Page.recruiterSignUp;
  }

  public PageReference forgotPassword() {
    return Page.recruiterForgotPassword;
  }
}