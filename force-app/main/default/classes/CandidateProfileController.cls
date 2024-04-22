/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CandidateProfileController {
    
    @AuraEnabled(cacheable=true)
    public static Candidate_Details__c getCandidateDetails(Id userId) {
        System.debug('userId---->'+userId);
        //Candidate_Details__c currentCandidate = new Candidate_Details__c();
        try {
            List<Candidate_Details__c> currentCandidate = [SELECT Id, Profile_Picture__c, Name, Candidate_Email__c, CTC__c, Date_of_birth__c, About__c, Phone_Number__c, Skills__c, Experience__c, City__c, Country__c,
                                                           (Select Id, Name, Organisation__c, From_Date__c, To_Date__c, City__c, Country__c From Work_Experience__r Order By From_Date__c Desc) FROM Candidate_Details__c WHERE User__c = :userId];
            if (currentCandidate.size() > 0){
                return currentCandidate[0];
            }else{
                return new Candidate_Details__c();
            }
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}