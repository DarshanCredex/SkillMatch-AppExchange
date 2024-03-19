/**
* An apex page controller that supports self registration of users in communities that allow self registration
*/
public class CandidateSignUpController {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    
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
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        Id candidateProfile = [SELECT Id FROM Profile WHERE Name = 'Candidate' LIMIT 1].Id;
        String profileId = candidateProfile;
        
        //String roleEnum = 'Community User';
        //Id roleId = [SELECT Id FROM UserRole WHERE Name = :roleEnum LIMIT 1].Id;
        String accountId = '0015h00001ZN5iuAAD';
        
        String userName = email;
        
        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = firstName+lastName;
        u.ProfileId = profileId;
        String userId;
        
        try {
            userId = Site.createExternalUser(u, accountId, password);
            System.debug('userId--->'+userId);
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            System.debug(ex.getMessage());
        }
        
        if (userId != null) {
            Candidate_Details__c newCandidate = new Candidate_Details__c();
            newCandidate.Name = firstName + ' ' + lastName;
            newCandidate.Candidate_Email__c = Email;
            newCandidate.User__c = (Id)userId;
            try{
                insert newCandidate;
            }catch(DMLException ex) {
                throw new AuraHandledException(ex.getMessage());
            }
            return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
        }
        return null;
    }
}