/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class loginLwcController {
    @AuraEnabled(cacheable=true)
    public static Boolean loginLwcControllerMethod(String email, String password) {
        Boolean authenticated = false;
        system.debug('email---->'+email);
        Candidate_Details__c candidate = [
            SELECT password__c
            FROM Candidate_Details__c
            WHERE Candidate_Email__c = :email
            LIMIT 1
        ];
        
        if (candidate != null && candidate.password__c == password) {
            authenticated = true;
        }
        
        return authenticated;
    }
}