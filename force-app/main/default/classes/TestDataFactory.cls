/**
 * @description       : test data for apex unit tests
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 05-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
@isTest
public class TestDataFactory {
  public static User createDummyUser() {
    User dummyUser = new User(
      FirstName = 'Test',
      LastName = 'User',
      Email = 'test@example.com',
      Username = 'te1212121st@example.com',
      Alias = 'testu',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Los_Angeles',
      CompanyName = 'ABC',
      ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
      .Id
    );
    insert dummyUser;
    return dummyUser;
  }

  public static Candidate_Details__c createCandidateDetails() {
    Candidate_Details__c candidate = new Candidate_Details__c(
      About__c = 'About the candidate',
      City__c = 'City',
      Country__c = 'Country',
      Candidate_Email__c = 'candidate@example.com',
      Gender__c = 'Male',
      Name = 'John Doe',
      Phone_Number__c = '1234567890',
      Skills__c = 'Java, JavaScript',
      Experience__c = 5,
      Job_Title__c = 'Software Engineer'
    );
    insert candidate;
    return candidate;
  }

  public static Job__c createJob() {
    Job__c job = new Job__c(
      Title_of_position__c = 'Sales Manager',
      City__c = 'Gurgaon',
      Country__c = 'India',
      Type__c = 'Temporary',
      Experience__c = '1 to 3 years',
      Industry__c = 'Information Technology',
      Status__c = 'Completed',
      Company_Name__c = 'ABC'
    );
    insert job;
    return job;
  }

  public static Job__c createDraft() {
    Job__c job = new Job__c(
      Title_of_position__c = 'Sales Manager',
      City__c = 'Gurgaon',
      Country__c = 'India',
      Type__c = 'Temporary',
      Experience__c = '1 to 3 years',
      Industry__c = 'Information Technology',
      Status__c = 'Draft',
      Company_Name__c = 'ABC'
    );
    insert job;
    return job;
  }

  public static Job_Applicants__c createJobApplicant(Id candidateId, Id jobId) {
    Job_Applicants__c applicant = new Job_Applicants__c(
      CandidateId__c = candidateId,
      Job_Id__c = jobId,
      Application_Status__c = 'Pending'
    );
    insert applicant;
    return applicant;
  }

  public static List<Work_Experience__c> createWorkExperienceList(
    Id candidateId
  ) {
    List<Work_Experience__c> workExpList = new List<Work_Experience__c>{
      new Work_Experience__c(
        CandidateId__c = candidateId,
        City__c = 'City1',
        Country__c = 'Country1',
        Name = 'Work Experience 1',
        From_Date__c = Date.newInstance(2020, 1, 1),
        To_Date__c = Date.newInstance(2022, 12, 31),
        Is_Current_Company__c = false,
        Organisation__c = 'Company A',
        Skills__c = 'Java, SQL'
      )
    };
    insert workExpList;
    return workExpList;
  }

  public static List<Question__c> createSubjectiveQuestion(id jobId) {
    List<Question__c> questionList = new List<Question__c>{
      new Question__c(
        Job__c = jobId, 
        Question_Name__c = 'Test Question',
        Type__c = 'Subjective',
        Weightage__c = 2
      )
    };
    insert questionList;
    return questionList;
  }

  public static List<Options__c> createSubjectiveOptions(id questionId){
    list<options__c> optionsList = new List<Options__c>{
      new Options__c(
        Question__c = questionId,
        Answers__c = 'Test Answer'
      )
    };
    insert optionsList;
    return optionsList;
  }
}
