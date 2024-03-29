/**
 * @description       : handler class for work experience trigger
 * @author            : Sagar Medatwal
 * @group             : 
 * @last modified on  : 03-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class WorkExperienceTriggerHandler {
    public static void checkIsCurrentCompany(List<Work_Experience__c> workExpList, Map<Id, Work_Experience__c> workExpMap) {
        if (workExpList != null && !workExpList.isEmpty()) {
            Map<Id, Work_Experience__c> candidateCurrentWorkMap = new Map<Id, Work_Experience__c>();
            for(Work_Experience__c work : workExpList){
                if(workExpMap != null){
                    Work_Experience__c currentWork = workExpMap.get(work.Id);
                    if((work.Is_Current_Company__c != currentWork.Is_Current_Company__c) && work.Is_Current_Company__c == true){
                        candidateCurrentWorkMap.put(work.CandidateId__c, work);
                    }
                }else{
                    candidateCurrentWorkMap.put(work.CandidateId__c, work);
                }
            }
            if (!candidateCurrentWorkMap.isEmpty()) {
                List<Work_Experience__c> allCurrentWorkExp = [SELECT Id, CandidateId__c FROM Work_Experience__c WHERE CandidateId__c IN :candidateCurrentWorkMap.keySet() AND Is_Current_Company__c = true];
                if (!allCurrentWorkExp.isEmpty()) {
                    for (Work_Experience__c currentWorkExp : allCurrentWorkExp) {
                        Work_Experience__c latestCurrentWork = candidateCurrentWorkMap.get(currentWorkExp.CandidateId__c);
                        if (latestCurrentWork != null && latestCurrentWork.Id != currentWorkExp.Id) {
                            currentWorkExp.Is_Current_Company__c = false;
                        }
                    }
                    update allCurrentWorkExp;
                }
            }
        }
    }
}