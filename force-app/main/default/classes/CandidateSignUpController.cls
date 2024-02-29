/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CandidateSignUpController {
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

  public CandidateSignUpController() {
    String expid = ApexPages.currentPage().getParameters().get('expid');
    if (expId != null) {
      Site.setExperienceId(expId);
    }
  }

  private boolean isValidPassword() {
    return password == confirmPassword;
  }

  public PageReference registerUser() {
    PageReference pageRef = new PageReference('startUrl');
    system.debug('inside method');
    Candidate_Details__c existingCandidate = [SELECT Id FROM Candidate_Details__c WHERE Candidate_Email__c = :email LIMIT 1];
    
    if(existingCandidate != null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An account with this email already exists.'));
        return null; 
    }
    Candidate_Details__c candidate = new Candidate_Details__c();
    string username = email;

    candidate.Candidate_Email__c = username;
    candidate.Password__c = password;
    candidate.Name = firstName + ' ' + lastName;

    try {
      insert candidate;
      return pageRef;
    } catch (DMLException ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }
}
