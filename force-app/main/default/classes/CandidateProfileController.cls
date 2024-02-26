public with sharing class CandidateProfileController {

    @AuraEnabled
    public static void attachFileToCandidate(Id userId, String fileName, String base64Data, String contentType) {
    System.debug('userId-->'+userId);
    System.debug('fileName-->'+fileName);
    System.debug('base64Data-->'+base64Data);
    System.debug('contentType-->'+contentType);    
    try {
            List<Candidate_Details__c> currentCandidate = [SELECT Id FROM Candidate_Details__c WHERE User__c = :userId];
            Attachment attachment = new Attachment();
            attachment.ParentId = currentCandidate[0].Id;
            attachment.Name = fileName;
            attachment.Body = EncodingUtil.base64Decode(base64Data);
            attachment.ContentType = contentType;
            insert attachment;
        } catch (Exception e) {
            throw new AuraHandledException('Error attaching file: ' + e.getMessage());
        }
    }

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