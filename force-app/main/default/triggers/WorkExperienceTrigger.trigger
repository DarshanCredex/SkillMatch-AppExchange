trigger WorkExperienceTrigger on Work_Experience__c (after insert, after update, after undelete) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate) {
            WorkExperienceTriggerHandler.checkIsCurrentCompany(Trigger.New, Trigger.oldMap);
        }
        else if(Trigger.isInsert || Trigger.isUndelete){
            WorkExperienceTriggerHandler.checkIsCurrentCompany(Trigger.New, null);
        }
    }
}