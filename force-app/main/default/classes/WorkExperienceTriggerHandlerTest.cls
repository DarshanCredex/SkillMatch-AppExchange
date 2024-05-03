@isTest
private class WorkExperienceTriggerHandlerTest {
    @isTest
    static void testCurrentCompanyLogic() {
        
        User user = TestDataFactory.createDummyUser();

        Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();

        List<Work_Experience__c> workExpList = new List<Work_Experience__c>{
            new Work_Experience__c(
                CandidateId__c = candidate.Id,
                City__c = 'City1',
                Country__c = 'Country1',
                Name = 'Work Experience 1',
                From_Date__c = Date.newInstance(2020, 1, 1),
                To_Date__c = Date.newInstance(2022, 12, 31),
                Is_Current_Company__c = true,
                Organisation__c = 'Company A',
                Skills__c = 'Java, SQL'
            ),
            new Work_Experience__c(
                CandidateId__c = candidate.Id,
                City__c = 'City2',
                Country__c = 'Country2',
                Name = 'Work Experience 2',
                From_Date__c = Date.newInstance(2023, 1, 1),
                To_Date__c = Date.newInstance(2024, 12, 31),
                Is_Current_Company__c = true, 
                Organisation__c = 'Company B',
                Skills__c = 'Java, SQL'
            )
        };
        insert workExpList;
        List<Work_Experience__c> currentWorkExp = [SELECT Id FROM Work_Experience__c WHERE CandidateId__c = :candidate.Id AND Is_Current_Company__c = true Limit 1];
        System.assertEquals(1, currentWorkExp.size(), 'More than one work experience is marked as current');
        Work_Experience__c olderWorkExp = [SELECT Id, Is_Current_Company__c FROM Work_Experience__c WHERE CandidateId__c = :candidate.Id AND Is_Current_Company__c = false LIMIT 1];
        System.assertNotEquals(null, olderWorkExp, 'No older work experience marked as not current');
    }
}