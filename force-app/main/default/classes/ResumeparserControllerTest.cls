@isTest
private class ResumeparserControllerTest {
    @isTest
    static void testSaveFile() {
        
        User testUser = TestDataFactory.createDummyUser();
       
        ResumeparserController controller = new ResumeparserController();
        controller.setuserId(testUser.Id);

        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
        candidate.User__c = testUser.Id;
        update candidate;	
        
        Blob testBlob = Blob.valueOf('Test Content');
        String testBase64 = EncodingUtil.base64Encode(testBlob);
        controller.fileName = 'test.pdf';
        controller.base64 = testBase64;

        Test.startTest();
        controller.saveFile();
        Test.stopTest();

        System.assertEquals(true, controller.uploadSuccess);

        List<ContentDocumentLink> contentDocLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :candidate.Id];
        System.assertNotEquals(0, contentDocLinks.size());
    }

    @isTest
    static void testUpdateParsedSkillsVF() {
        
        User testUser = TestDataFactory.createDummyUser();

        ResumeparserController controller = new ResumeparserController();
        controller.setuserId(testUser.Id);

        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
        candidate.User__c = testUser.Id;
        update candidate;

        controller.parsedText = 'Test Parsed Text';

        Test.startTest();
        controller.updateParsedSkillsVF();
        Test.stopTest();

        Candidate_Details__c updatedCandidate = [SELECT ParsedSkills__c FROM Candidate_Details__c WHERE Id = :candidate.Id];
        System.assertEquals('Test Parsed Text', updatedCandidate.ParsedSkills__c);
    }
    @isTest
    static void testGetData() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
        candidate.User__c = testUser.Id;
        update candidate;

      
        ResumeparserController controller = new ResumeparserController();
        controller.setuserId(testUser.Id);

       
        Test.startTest();
        Candidate_Details__c result = ResumeparserController.getData(testUser.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testAcceptedFormats() {
        ResumeparserController controller = new ResumeparserController();
        List<String> formats = controller.acceptedFormats();
        System.assertEquals(1, formats.size());
        System.assertEquals('.pdf', formats[0]);
    }
    @isTest
    static void testGetUserId() {
        User testUser = TestDataFactory.createDummyUser();
        ResumeparserController controller = new ResumeparserController();
		
        controller.setuserId(testUser.Id);
        System.assertEquals(testUser.Id, controller.getuserId());
    }
	 @isTest
    static void testPassUserId() {
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
        candidate.User__c = testUser.Id;
        update candidate;
        ResumeparserController controller = new ResumeparserController();
        controller.setuserId(testUser.Id);
        Test.startTest();
        controller.passUserId();
        Test.stopTest();
        Candidate_Details__c queriedCandidate = [SELECT Id FROM Candidate_Details__c WHERE User__c = :testUser.Id];
        System.assertNotEquals(null, queriedCandidate);
    }
    @isTest
    static void testGetSetBase64() {
        ResumeparserController controller = new ResumeparserController();
        System.assertEquals(null, controller.getBase64());
        String testBase64 = 'testBase64Data';
        controller.setbase64(testBase64);
        System.assertEquals(testBase64, controller.getBase64());
    }
	@isTest
    static void testSaveFile_DeleteContentDocument() {
       
        User testUser = TestDataFactory.createDummyUser();

        ResumeparserController controller = new ResumeparserController();
        controller.setuserId(testUser.Id);

        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
        candidate.User__c = testUser.Id;
        update candidate;

        ContentVersion newContentVersion = new ContentVersion();
        newContentVersion.Title = 'Test Content';
        newContentVersion.VersionData = Blob.valueOf('Test Content');
        newContentVersion.PathOnClient = 'test.pdf';
        insert newContentVersion;
        
        ContentDocumentLink newContentDocLink = new ContentDocumentLink();
        newContentDocLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newContentVersion.Id].ContentDocumentId;
        newContentDocLink.LinkedEntityId = candidate.Id;
        insert newContentDocLink;

        controller.fileName = 'test.pdf';
        controller.base64 = EncodingUtil.base64Encode(Blob.valueOf('Test Content'));
        
        controller.saveFile();

		ContentVersion newContentVersionFile2 = new ContentVersion();
        newContentVersionFile2.Title = 'Test Content2';
        newContentVersionFile2.VersionData = Blob.valueOf('Test Content2');
        newContentVersionFile2.PathOnClient = 'test2.pdf';
        insert newContentVersionFile2;
        
        ContentDocumentLink newContentDocLinkFile2 = new ContentDocumentLink();
        newContentDocLinkFile2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newContentVersionFile2.Id].ContentDocumentId;
        newContentDocLinkFile2.LinkedEntityId = candidate.Id;
        insert newContentDocLinkFile2;

        controller.fileName = 'test2.pdf';
        controller.base64 = EncodingUtil.base64Encode(Blob.valueOf('Test Content2'));
		Test.startTest();
        controller.saveFile();
        Test.stopTest();

        List<ContentDocumentLink> contentDocLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :candidate.Id];
        System.assertNotEquals(2, contentDocLinks.size());
    }

}