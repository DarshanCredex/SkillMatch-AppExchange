public with sharing class CandidateProfileController {
    @AuraEnabled
    public static void createWorkExperience(String organisation, Boolean isCurrentCompany, Date fromDate, Date toDate, String City, String Country) {
        try {
            Work_Experience__c experience = new Work_Experience__c(
                Organisation__c = organisation,
                Is_Current_Company__c = isCurrentCompany,
                From_Date__c = fromDate,
                To_Date__c = toDate,
                City__c = City,
                Country__c = Country
            );
            insert experience;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Candidate_Details__c getCandidateDetails(Id userId) {
        System.debug('userId---->'+userId);
        Candidate_Details__c currentCandidate = new Candidate_Details__c();
        currentCandidate = [SELECT Id, Name, Candidate_Email__c, CTC__c, Date_of_birth__c, About__c, Phone_Number__c, Skills__c, Experience__c, City__c, Country__c,
                            (Select Id, Name, Organisation__c, From_Date__c, To_Date__c, City__c, Country__c From Work_Experience__r) FROM Candidate_Details__c WHERE OwnerId = :userId Limit 1];
        return currentCandidate;
    }

    @AuraEnabled
    public static void updateCandidateDetails(Candidate_Details__c candidate) {
        try {
            update candidate;
        } catch (DmlException e) {
            System.debug('Error updating candidate:' + e.getMessage());
        }
    }
}