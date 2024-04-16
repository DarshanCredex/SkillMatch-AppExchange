public with sharing class resumeparserController {
    public String userId;
   public String getuserId(){
        return userId;
    }
    public void setuserId(String userId){
        this.userId = userId;
    }
    public String acceptedFormats { get; set; } 
    public String parsedText { get; set; }
    public List<String> acceptedFormats() {
        return new List<String>{'.pdf'};
            }
    public String base64;
    public String getBase64(){
        return base64;
    }
    public void setbase64(String base64){
        this.base64 = base64;
    }
    public String fileName {get; set;}
    public void passUserId() {
        
        System.debug('userId------------------->'+ userId);
        
    }
    public void saveFile(){
        System.debug('userId------------------->'+ userId);
    Candidate_Details__c candidateId = [SELECT Id FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1];
     System.debug('candidateId------------------->'+ candidateId);
    if(candidateId != null){
        // Query for existing ContentDocumentLinks related to the candidate
        List<ContentDocumentLink> existingContentDocLinks = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :candidateId.Id Limit 50000];
         System.debug('existingContentDocLinks----------------------'+ existingContentDocLinks);
        if(!existingContentDocLinks.isEmpty()){
            // Delete existing attachments
            List<Id> contentDocumentIdsToDelete = new List<Id>();
            for(ContentDocumentLink cdLink : existingContentDocLinks){
                contentDocumentIdsToDelete.add(cdLink.ContentDocumentId);
            }
             System.debug('contentDocumentIdsToDelete----------------------'+ contentDocumentIdsToDelete);
            try {
                delete [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIdsToDelete];
                System.debug('Old attachments deleted');
            } catch(Exception e) {
                System.debug('Error deleting attachments: ' + e.getMessage());
            }
        }
        System.debug('base64--------------------- > ' + base64);
        // Create new attachment
        ContentVersion newContentVersion = new ContentVersion();																	
        newContentVersion.Title = this.fileName;
        newContentVersion.VersionData = EncodingUtil.base64decode(this.base64);
        newContentVersion.PathOnClient = fileName;
        insert newContentVersion;
        System.debug('this.base64- > ' + this.base64);
        // Create new ContentDocumentLink
        ContentDocumentLink newContentDocLink = new ContentDocumentLink();
        newContentDocLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newContentVersion.Id].ContentDocumentId;
        newContentDocLink.LinkedEntityId = candidateId.Id;
        insert newContentDocLink;
        System.debug('New attachment created');
    } else {
        System.debug('Candidate not found');
    }
}

    
    public void updateParsedSkillsVF() {
        try {
            System.debug('parsedText' + parsedText);
            Candidate_Details__c candidateId = [SELECT Id, ParsedSkills__c FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1];
            
            if(candidateId != null){
                candidateId.ParsedSkills__c = parsedText;
                update candidateId;
                System.debug('Parsed skills updated successfully.');
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            // Handle errors appropriately, e.g., display error message to user
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Candidate_Details__c getData(Id userId) {
        try{
            List<Candidate_Details__c> currentCandidate = [SELECT Id, Profile_Picture__c, Name, Candidate_Email__c, CTC__c, Date_of_birth__c, About__c, Phone_Number__c, Skills__c, Experience__c, City__c, Country__c,
                                                           (SELECT Id, Name, Organisation__c, From_Date__c, To_Date__c, City__c, Country__c FROM Work_Experience__r ORDER BY From_Date__c DESC) FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1]; 
            if (!currentCandidate.isEmpty()){
                return currentCandidate[0];
            } else {
                return new Candidate_Details__c();
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}