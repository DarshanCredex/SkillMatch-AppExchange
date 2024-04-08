/**
* @description       : This class is used for fetching the applcant data and work experience
* @author            : Rudransh Shukla
* @group             :
* @last modified on  : 03-29-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class GetApplicantData {
    @AuraEnabled(cacheable=true)
    public static list<Candidate_Details__c> GetApplicantDataMethod(
        string applicantId
    ) {
        system.debug('applicantId------>' + applicantId);
        list<Candidate_Details__c> candidateDetails = [
            SELECT
            Id,
            About__c,
            City__c,
            Country__c,
            CTC__c,
            Date_of_birth__c,
            Candidate_Email__c,
            Gender__c,
            Name,
            Phone_Number__c,
            Skills__c,
            Experience__c,
            Job_Title__c,
            Profile_Picture__c
            FROM Candidate_Details__c
            WHERE id = :applicantId
        ];
        return candidateDetails;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Work_Experience__c> GetWorkExperienceData(
        string applicantId
    ) {
        system.debug('applicantId------>' + applicantId);
        list<Work_Experience__c> workExpList = [
            SELECT
            CandidateId__c,
            City__c,
            Country__c,
            CreatedById,
            Name,
            From_Date__c,
            Is_Current_Company__c,
            LastModifiedById,
            Organisation__c,
            Skills__c,
            To_Date__c,
            Id
            FROM Work_Experience__c
            WHERE CandidateId__c = :applicantId
            ORDER BY To_Date__c DESC
        ];
        
        system.debug('workExpList' + workExpList);
        return workExpList;
    }
    
    @AuraEnabled(cacheable = true)
    public static List<Job__c> getAppliedJobById(String candidateId) {
        List<Job__c> appliedJobs = new List<Job__c>();
        try {
            List<Job_Applicants__c> jobApplicants = [
                SELECT Job_Id__c
                FROM Job_Applicants__c
                WHERE CandidateId__c = :candidateId
                LIMIT 1
            ];
            
            Set<Id> jobIds = new Set<Id>();
            for (Job_Applicants__c jobApplicant : jobApplicants) {
                jobIds.add(jobApplicant.Job_Id__c);
            }
            
            appliedJobs = [
                SELECT Title_of_position__c
                FROM Job__c
                WHERE Id IN :jobIds
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return appliedJobs;
    }
   // @AuraEnabled(cacheable=true)
    /*public static List<ContentDocumentLink> getResume(string applicantId) {
        System.debug('applicantId------->' + applicantId);
        List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
        try {
            cdls = [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :applicantId
            ];
        } catch (Exception e) {
            system.debug(e.getMessage() + e.getLineNumber());
        }
        system.debug('cdls------->' + cdls);
        return cdls;
    }*/
@AuraEnabled(cacheable=true)
    public static ApplicantDetailsWrapper getResume(Id applicantId) {
        ApplicantDetailsWrapper wrapper = new ApplicantDetailsWrapper();
        
        // Query to retrieve related notes and attachments for the selected job applicant
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, LinkedEntityId 
                                                   FROM ContentDocumentLink 
                                                   WHERE LinkedEntityId = :applicantId];
        
        Set<Id> documentIds = new Set<Id>();
        for(ContentDocumentLink link : documentLinks) {
            documentIds.add(link.ContentDocumentId);
        }
        
        List<ContentDocument> documents = [SELECT Id, Title, FileType, ContentSize, LatestPublishedVersionId 
                                           FROM ContentDocument 
                                           WHERE Id IN :documentIds];

        for(ContentDocument document : documents) {
            wrapper.documents.add(new ContentDocumentWrapper(document.Id, document.Title, document.FileType, document.ContentSize, document.LatestPublishedVersionId));
        }
        system.debug('wrapper------------------>'+ wrapper);
        return wrapper;
    }
    
    // Wrapper class to hold related notes and attachments data
    public class ApplicantDetailsWrapper {
        @AuraEnabled public List<ContentDocumentWrapper> documents { get; set; }
        
        public ApplicantDetailsWrapper() {
            documents = new List<ContentDocumentWrapper>();
        }
    } 
    // Wrapper class for ContentDocument
    public class ContentDocumentWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String Title { get; set; }
        @AuraEnabled public String FileType { get; set; }
        @AuraEnabled public Integer ContentSize { get; set; }
        @AuraEnabled public Id LatestPublishedVersionId { get; set; }
        
        public ContentDocumentWrapper(Id Id, String Title, String FileType, Integer ContentSize, Id LatestPublishedVersionId) {
            this.Id = Id;
            this.Title = Title;
            this.FileType = FileType;
            this.ContentSize = ContentSize;
            this.LatestPublishedVersionId = LatestPublishedVersionId;
        }
    }
}