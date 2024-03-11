/**
 * @description       : recruiter sign up page controller
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 03-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class recruiterSignUpController {
  public String firstName { get; set; }
  public String lastName { get; set; }
  public String email { get; set; }
  public String password {
    get;
    set {
      password = value == null ? value : value.trim();
    }
  }
  public String confirmPassword {
    get;
    set {
      confirmPassword = value == null ? value : value.trim();
    }
  }
  public String communityNickname {
    get;
    set {
      communityNickname = value == null ? value : value.trim();
    }
  }
  public string CompanyName{get; set;}

  public recruiterSignUpController() {
    String expid = ApexPages.currentPage().getParameters().get('expid');
    if (expId != null) {
      Site.setExperienceId(expId);
    }
  }

  private boolean isValidPassword() {
    return password == confirmPassword;
  }

  public PageReference registerUser() {
    if (!isValidPassword()) {
      ApexPages.Message msg = new ApexPages.Message(
        ApexPages.Severity.ERROR,
        Label.site.passwords_dont_match
      );
      ApexPages.addMessage(msg);
      return null;
    }
    Id profileId = [SELECT Id FROM Profile WHERE Name = 'Recruiter' LIMIT 1].Id;

    String accountId = '0015h00001cwIQIAA2';
    System.debug(email);
    String userName = email;

    system.debug(email + 'Username');
    User u = new User();
    u.Username = userName;
    u.Email = email;
    u.FirstName = firstName;
    u.LastName = lastName;
    u.CommunityNickname = firstName + lastName;
    u.ProfileId = profileId;
    u.CompanyName = CompanyName;
    String userId;

    try {
      System.debug('User' + userId);
      userId = Site.createExternalUser(u, accountId, password);
    } catch (Site.ExternalUserCreateException ex) {
      system.debug(
        'exception message----->' +
          ex.getMessage() +
          '------>' +
          ex.getLineNumber()
      );
      List<String> errors = ex.getDisplayMessages();
      for (String error : errors) {
        ApexPages.addMessage(
          new ApexPages.Message(ApexPages.Severity.ERROR, error)
        );
      }
      System.debug(ex.getMessage());
    }

    if (userId != null) {
      if (password != null && password.length() > 1) {
        return Site.login(
          userName,
          password,
          ApexPages.currentPage().getParameters().get('startURL')
        );
      } else {
        PageReference page = System.Page.CommunitiesSelfRegConfirm;
        page.setRedirect(true);
        return page;
      }
    }
    return null;
  }

  public PageReference onLogin(){
    return page.recruiterLoginPage;
  }
}