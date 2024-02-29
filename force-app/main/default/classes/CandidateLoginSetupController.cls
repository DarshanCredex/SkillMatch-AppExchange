/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-28-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class CandidateLoginSetupController {
  public static String email { get; set; }
  public String password { get; set; }
  public Boolean hasError { get; set; }

  public CandidateLoginSetupController() {
    hasError = false;
  }

  public PageReference doLogin() {
    string emailNew;
    List<Candidate_Details__c> candidates = [
      SELECT Password__c
      FROM Candidate_Details__c
      WHERE Candidate_Email__c = :email
      LIMIT 1
    ];
    // Cache.Session.put('local.myPartition.emailId', email);
    // emailNew = (String) Cache.Session.get('local.myPartition.emailId');
    // system.debug('email (get)----->'+emailNew);
    // system.debug('put into cache');

    if (!candidates.isEmpty()) {
      Candidate_Details__c candidate = candidates[0];
      if (password == candidate.Password__c) {
        // return site.login(
        //   'medatwal.sagar07@gmail.com',
        //   'Sfdc@1234',
        //   '/Candidate'
        // ); // temp workaround

        return new PageReference('/');
      }
    }

    hasError = true;
    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.Severity.ERROR,
        'Invalid email or password.'
      )
    );
    return null;
  }

  public PageReference onSignup() {
    return Page.CandidateSignUp;
  }

  public PageReference forgotPassword() {
    return Page.ForgotPassword;
  }

  @AuraEnabled(Cacheable=true)
  public static string returnEmail() {
    try {
      system.debug('email------->' + email);
      return email;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
