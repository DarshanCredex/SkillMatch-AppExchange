@isTest
public class CandidateAppliedJobsControllerTest {
    static TestMethod void testGetAppliedJobs() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
        testCandidate.User__c = testUser.Id;
        update testCandidate;
        Job__c testJob = TestDataFactory.createJob();
        Job_Applicants__c testJobApplicant = TestDataFactory.createJobApplicant(testCandidate.Id, testJob.Id);
        system.debug('testJobApplicant----->'+ testJobApplicant);
        CandidateAppliedJobsController.JobWrapper result = CandidateAppliedJobsController.getAppliedJobs('', '', testUser.Id, '');
        system.debug('result.jobWrapperList----->'+ result.jobWrapperList);
        System.assertEquals(1, result.jobWrapperList.size());
        
        
        CandidateAppliedJobsController.JobListWrapper jobWrapper = result.jobWrapperList[0];
        System.assertEquals(testJob.Id, jobWrapper.jobId);
        System.assertEquals('Sales Manager', jobWrapper.title);
        System.assertEquals('ABC', jobWrapper.company);
        System.assertEquals('Temporary', jobWrapper.jobType);
        System.assertEquals('Gurgaon', jobWrapper.city);
        System.assertEquals('India', jobWrapper.country);
        System.assertEquals('Pending', jobWrapper.status);
        System.assertEquals(false, jobWrapper.questionsPresent);
        System.assertEquals(false, jobWrapper.assesmentStatus);
    }
    
    static TestMethod void testGetPendingJobListForHomePage() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
         testCandidate.User__c = testUser.Id;
        update testCandidate;
        Job__c testJob = TestDataFactory.createJob();
        Job_Applicants__c testJobApplicant = TestDataFactory.createJobApplicant(testCandidate.Id, testJob.Id);
        
        
        List<Job__c> result = CandidateAppliedJobsController.getPendingJobListForHomePage(testUser.Id);
		system.debug('result---->'+ result);        
        
        System.assertEquals(1, result.size());
        System.assertEquals(testJob.Id, result[0].Id);
        System.assertEquals('Sales Manager', result[0].Title_of_position__c);
        System.assertEquals('ABC', result[0].Company_Name__c);
        System.assertEquals('Gurgaon', result[0].City__c);
        System.assertEquals('India', result[0].Country__c);
        System.assertEquals('Temporary', result[0].Type__c);
    }
    
    static TestMethod void testGetAppliedJobListForHomePage() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
        testCandidate.User__c = testUser.Id;
        update testCandidate;
        Job__c testJob = TestDataFactory.createJob();
        Job_Applicants__c testJobApplicant = TestDataFactory.createJobApplicant(testCandidate.Id, testJob.Id);
        testJobApplicant.Application_Status__c='Accepted';
        update testJobApplicant;
        List<Job__c> result = CandidateAppliedJobsController.getAppliedJobListForHomePage(testUser.Id);
        System.assertEquals(1, result.size());
        System.assertEquals(testJob.Id, result[0].Id);
        System.assertEquals('Sales Manager', result[0].Title_of_position__c);
        System.assertEquals('ABC', result[0].Company_Name__c);
        System.assertEquals('Gurgaon', result[0].City__c);
        System.assertEquals('India', result[0].Country__c);
        System.assertEquals('Temporary', result[0].Type__c);
       
    }
    
    static TestMethod void testNumberOfShorlistedJobs() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
         testCandidate.User__c = testUser.Id;
        update testCandidate;
        Job__c testJob = TestDataFactory.createJob();
        Job_Applicants__c testJobApplicant = TestDataFactory.createJobApplicant(testCandidate.Id, testJob.Id);
        testJobApplicant.Application_Status__c = 'Accepted';
        update testJobApplicant;
        
        
        Integer result = CandidateAppliedJobsController.numberOfShorlistedJobs(testUser.Id);
        
        
        System.assertEquals(1, result);
    }
    
    static TestMethod void testNumberOfPendingJobs() {
        
        User testUser = TestDataFactory.createDummyUser();
        Candidate_Details__c testCandidate = TestDataFactory.createCandidateDetails();
         testCandidate.User__c = testUser.Id;
        update testCandidate;
        Job__c testJob = TestDataFactory.createJob();
        Job_Applicants__c testJobApplicant = TestDataFactory.createJobApplicant(testCandidate.Id, testJob.Id);
        testJobApplicant.Application_Status__c = 'Pending';
        update testJobApplicant;
        
        
        Integer result = CandidateAppliedJobsController.numberOfPendingJobs(testUser.Id);
        
        
        System.assertEquals(1, result);
    }
}