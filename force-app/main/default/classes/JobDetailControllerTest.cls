/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
public class JobDetailControllerTest {
  @isTest
  static void TestCreateJobApplicants() {
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();

    Job__c job = TestDataFactory.createJob();
    user u = TestDataFactory.createDummyUser();
    candidate.User__c = u.id;
    update candidate;
    boolean result = JobDetailController.createJobApplicants(u.id, job.id);
    System.assertEquals(true, result);
  }

  @isTest
  static void TestCheckJobStatus() {
    user user = TestDataFactory.createDummyUser();
    Job__c job = TestDataFactory.createJob();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();

    candidate.User__c = user.id;
    update candidate;

    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(candidate.id, job.id);

    boolean result = JobDetailController.checkJobStatus(user.id, job.id);
    System.assertEquals(true, result);
  }

  @isTest
  static void TestGetJobDescription(){
    Job__c job = TestDataFactory.createJob();
    List<JobDetailController.JobDetailWrapper> result = JobDetailController.getJobDescription(job.id);
    System.assertEquals(1, result.size());
  }
}
