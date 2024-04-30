@isTest
public class CandidateProfileControllerTest {
    @isTest
    static void testGetCandidateDetails() {
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
        testCandidate.User__c = testUser.Id;
        update testCandidate;

        Test.startTest();
        Candidate_Details__c result = CandidateProfileController.getCandidateDetails(testUser.Id);
        Test.stopTest();

        System.assertEquals('John Doe', result.Name);
        // Add more assertions based on the returned Candidate_Details__c fields
    }

    @isTest
    static void testGetResume() {
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
        testCandidate.User__c = testUser.Id;
        update testCandidate;

        ContentVersion testContent = new ContentVersion(
            Title = 'Test Resume',
            PathOnClient = 'test.pdf',
            VersionData = Blob.valueOf('Test resume data'),
            IsMajorVersion = true
        );
        insert testContent;

        ContentDocument testDocument = [
            SELECT Id, Title
            FROM ContentDocument
            WHERE Id IN (
                SELECT ContentDocumentId
                FROM ContentVersion
                WHERE Id = :testContent.Id
            )
            LIMIT 1
        ];

        ContentDocumentLink testLink = new ContentDocumentLink(
            ContentDocumentId = testDocument.Id,
            LinkedEntityId = testCandidate.Id,
            ShareType = 'V'
        );
        insert testLink;

        Test.startTest();
        Map<Id, String> result = CandidateProfileController.getResume(testUser.Id);
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals('Test Resume', result.get(testDocument.Id));
    }

    @isTest
    static void testDeleteWorkExperience() {
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
        testCandidate.User__c = testUser.Id;
        update testCandidate;

        List<Work_Experience__c> workExpList = TestDataFactory.createWorkExperienceList(testCandidate.Id);

        Test.startTest();
        CandidateProfileController.deleteWorkExperience(workExpList[0].Id);
        Test.stopTest();

        System.assertEquals(0, [
            SELECT Id
            FROM Work_Experience__c
            WHERE Id = :workExpList[0].Id
        ].size());
    }
}