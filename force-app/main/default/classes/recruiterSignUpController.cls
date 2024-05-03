/**
 * @description       : recruiter sign up page controller
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 05-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public without sharing class recruiterSignUpController {
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
  public string CompanyName { get; set; }

  public recruiterSignUpController() {
    String expid = ApexPages.currentPage().getParameters().get('expid');
    if (expId != null) {
      Site.setExperienceId(expId);
    }
  }

  @TestVisible
  private boolean isValidPassword() {
    return password == confirmPassword;
  }

  public PageReference registerUser() {
    Id profileId = [SELECT Id FROM Profile WHERE Name = 'Recruiter' LIMIT 1].Id;

    Id accountId = [
      SELECT id
      FROM account
      WHERE name = 'SkillMatch Recruiter'
    ][0]
    .id;
    String userName = email;

    User u = new User();
    u.Username = userName;
    u.Email = email;
    u.FirstName = firstName;
    u.LastName = lastName;
    u.CommunityNickname = firstName + lastName;
    u.ProfileId = profileId;
    u.CompanyName = CompanyName;
    String userId;
    userId = Site.createExternalUser(u, accountId, password);
    return null;
  }

  public PageReference onLogin() {
    return page.recruiterLoginPage;
  }
}