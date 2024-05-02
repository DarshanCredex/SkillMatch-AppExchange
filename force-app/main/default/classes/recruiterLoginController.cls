/**
 * @description       : recruiter login page controller class
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 05-02-2024
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
    return Site.login(email, password, '/HR/s');
  }

  public PageReference onSignup() {
    return Page.recruiterSignUp;
  }

  public PageReference forgotPassword() {
    return Page.recruiterForgotPassword;
  }
}
