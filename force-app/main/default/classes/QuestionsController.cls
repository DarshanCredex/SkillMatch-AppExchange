/**
 * @description       : questions and options custom object controller class
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class QuestionsController {
    public class responseWrapper {
        @AuraEnabled
        public string candidateResponse { get; set; }
        @AuraEnabled
        public string question { get; set; }
        @AuraEnabled
        public Map<string, boolean> actualResponse { get; set; }
        @AuraEnabled
        public Id questionId { get; set; }
        @AuraEnabled
        public string type { get; set; }
        @AuraEnabled
        public decimal weightage { get; set; }
        
        public responseWrapper() {
            actualResponse = new Map<string, boolean>();
        }
    }
    
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
            
            Id questionId = question.Id;
            list<Options__c> optionsList = new List<Options__c>();
            if (question.Type__c == 'Objective') {
                /* Options__c option_A = new Options__c();
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
option.Question__c = questionId;
optionsList.add(option);
}

if (!optionsList.IsEmpty()) {
insert optionsList;
}
} catch (Exception e) {
throw new AuraHandledException(e.getMessage());
}
}*/
                if (String.isNotBlank(optionA)) {
                    optionsList.add(new Options__c(Answers__c = optionA, Checkbox__c = checkbox_1, Question__c = questionId));
                }
                if (String.isNotBlank(optionB)) {
                    optionsList.add(new Options__c(Answers__c = optionB, Checkbox__c = checkbox_2, Question__c = questionId));
                }
                if (String.isNotBlank(optionC)) {
                    optionsList.add(new Options__c(Answers__c = optionC, Checkbox__c = checkbox_3, Question__c = questionId));
                }
                if (String.isNotBlank(optionD)) {
                    optionsList.add(new Options__c(Answers__c = optionD, Checkbox__c = checkbox_4, Question__c = questionId));
                }
            } else if (type == 'Subjective' && String.isNotBlank(answer)) {
                optionsList.add(new Options__c(Answers__c = answer, Question__c = questionId));
            }
            
            if (!optionsList.isEmpty()) {
                insert optionsList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Question__c> fetchQuestions(Id jobId) {
        try {
            list<Question__c> questionsList = new List<Question__c>();
            
            questionsList = [
                SELECT
                id,
                Question_Name__c,
                Type__c,
                Weightage__c,
                (SELECT id, Answers__c, Name, Checkbox__c FROM Options__r)
                FROM Question__c
                WHERE Job__c = :jobId
            ];
            
            return questionsList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static string getResponsesAndQuestions(Id jobId, Id candidateId) {
        try {
            List<responseWrapper> result = new List<responseWrapper>();
            
            List<Job_Applicants__c> jobApplicantsList = [
                SELECT Id
                FROM Job_Applicants__c
                WHERE CandidateId__c = :candidateId AND Job_Id__c = :jobId
                LIMIT 1
            ];
            
            if (!jobApplicantsList.isEmpty()) {
                Id applicantId = jobApplicantsList[0].Id;
                
                List<Question__c> questionList = [
                    SELECT
                    Id,
                    Type__c,
                    Question_Name__c,
                    Weightage__c,
                    (SELECT Id, Answers__c, Checkbox__c FROM Options__r),
                    (
                        SELECT Id, Response_Value__c
                        FROM Responses__r
                        WHERE Job_Applicants__c = :applicantId
                    )
                    FROM Question__c
                    WHERE Job__c = :jobId
                ];
                
                for (Question__c ques : questionList) {
                    responseWrapper wrapper = new responseWrapper();
                    wrapper.question = ques.Question_Name__c;
                    wrapper.questionId = ques.Id;
                    wrapper.type = ques.Type__c;
                    wrapper.weightage = ques.Weightage__c;
                    
                    Map<String, Boolean> optionsMap = new Map<String, Boolean>();
                    for (Options__c option : ques.Options__r) {
                        if (option.Answers__c != null) {
                            optionsMap.put(option.Answers__c, false);
                        }
                        if (option.Checkbox__c != null) {
                            optionsMap.put(option.Answers__c, option.Checkbox__c);
                        }
                    }
                    
                    wrapper.actualResponse = optionsMap;
                    if (!ques.Responses__r.isEmpty()) {
                        wrapper.candidateResponse = ques.Responses__r[0].Response_Value__c;
                    }
                    
                    result.add(wrapper);
                }
            }
            return JSON.serialize(result);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void updateScore(integer score, id jobid, id candidateid) {
        try {
            id applicantid = [
                SELECT Id
                FROM Job_Applicants__c
                WHERE CandidateId__c = :candidateId AND Job_Id__c = :jobId
            ][0]
                .id;
            
            Job_Applicants__c applicant = [
                SELECT Total_Score__c, Assesment_Status__c
                FROM Job_Applicants__c
                WHERE id = :applicantid
            ];
            
            applicant.Total_Score__c = score;
            applicant.Assesment_Status__c = 'Evaluated';
            
            update applicant;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}