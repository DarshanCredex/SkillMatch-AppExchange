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
    public Boolean uploadSuccess { get; set; }
    public void passUserId() {
        Candidate_Details__c candidateId = [SELECT Id FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1];
        //perform multiple resume handling operation in this block 
    }
    public void saveFile(){
        Candidate_Details__c candidateId = [SELECT Id FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1];    
        if(candidateId != null){
            // Query for existing ContentDocumentLinks related to the candidate
            List<ContentDocumentLink> existingContentDocLinks = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :candidateId.Id Limit 50000];
            if(!existingContentDocLinks.isEmpty()){
                // Delete existing attachments
                List<Id> contentDocumentIdsToDelete = new List<Id>();
                for(ContentDocumentLink cdLink : existingContentDocLinks){
                    contentDocumentIdsToDelete.add(cdLink.ContentDocumentId);
                }
                try {
                    delete [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIdsToDelete];
                } catch(Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
            // Create new attachment
            ContentVersion newContentVersion = new ContentVersion();																	
            newContentVersion.Title = this.fileName;
            newContentVersion.VersionData = EncodingUtil.base64decode(this.base64);
            newContentVersion.PathOnClient = fileName;
            insert newContentVersion;
            
            // Create new ContentDocumentLink
            ContentDocumentLink newContentDocLink = new ContentDocumentLink();
            newContentDocLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newContentVersion.Id].ContentDocumentId;
            newContentDocLink.LinkedEntityId = candidateId.Id;
            insert newContentDocLink;
            uploadSuccess = true;
        } else {
            // System.debug('Candidate not found');
        }
    }
    public void updateParsedSkillsVF() {
        try {
            Candidate_Details__c candidateId = [SELECT Id, ParsedSkills__c FROM Candidate_Details__c WHERE User__c = :userId LIMIT 1];
            if(candidateId != null){
                candidateId.ParsedSkills__c = parsedText;
                update candidateId;
            }
        } catch (Exception e) {
            // Handle errors appropriately, e.g., display error message to user
            throw new AuraHandledException(e.getMessage());
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