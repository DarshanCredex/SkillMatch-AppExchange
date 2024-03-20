/**
 * @description       : questions and options custom object controller class
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 03-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class QuestionsController {
  @AuraEnabled(cacheable=true)
  public static list<string> questionTypeValue() {
    String fieldName = 'Type__c';
    String objectApiName = 'Question__c';
    JobPicklistController controller = new JobPicklistController();
    List<String> picklistValues = controller.getPicklistValues(
      objectApiName,
      fieldName
    );
    return picklistValues;
  }

  @AuraEnabled
  public static void insertQuestionAndOptions(
    string questionName,
    Decimal weightage,
    string type,
    string optionA,
    string optionB,
    string optionC,
    string optionD,
    boolean checkbox_1,
    boolean checkbox_2,
    boolean checkbox_3,
    boolean checkbox_4,
    Id jobId,
    string answer
  ) {
    try {
      Question__c question = new Question__c();
      question.Question_Name__c = questionName;
      question.Weightage__c = weightage;
      question.Type__c = type;
      question.Job__c = jobId;

      insert question;

      string questionId = question.Id;
      list<Options__c> optionsList = new List<Options__c>();
      if (question.Type__c == 'Objective') {
        Options__c option_A = new Options__c();
        Options__c option_B = new Options__c();
        Options__c option_C = new Options__c();
        Options__c option_D = new Options__c();

        option_A.Answers__c = optionA;
        option_A.Checkbox__c = checkbox_1;
        option_A.Question__c = questionId;

        option_B.Answers__c = optionB;
        option_B.Checkbox__c = checkbox_2;
        option_B.Question__c = questionId;

        option_C.Answers__c = optionC;
        option_C.Checkbox__c = checkbox_3;
        option_C.Question__c = questionId;

        option_D.Answers__c = optionD;
        option_D.Checkbox__c = checkbox_4;
        option_D.Question__c = questionId;

        optionsList.add(option_A);
        optionsList.add(option_B);
        optionsList.add(option_C);
        optionsList.add(option_D);
      } else if (question.Type__c == 'Subjective') {
        Options__c option = new Options__c();
        option.Answers__c = answer;
        option.Question__c = jobId;
        optionsList.add(option);
      }

      insert optionsList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
