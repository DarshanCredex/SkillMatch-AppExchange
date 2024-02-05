public class WorkExperienceTriggerHandler {
    
    public static void checkIsCurrentCompany (List <Work_Experience__c> workExpList, Map<Id, Work_Experience__c> workExpMap) {
        if(!workExpList.isEmpty()){
            
            Set<Id> workId = new Set<Id>();
            
            for(Work_Experience__c work : workExpList){
                if(workExpMap != null){
                    Work_Experience__c currentWork = workExpMap.get(work.Id);
                    if((work.Is_Current_Company__c != currentWork.Is_Current_Company__c) && work.Is_Current_Company__c == true){
                        workId.add(work.CandidateId__c);
                    }
                }else{
                    workId.add(work.CandidateId__c);
                }
            }
            
            List<Work_Experience__c> allWorkExp = new List<Work_Experience__c>();
            allWorkExp = [Select Id, CandidateId__c, Is_Current_Company__c From Work_Experience__c Where CandidateId__c In: workId And Is_Current_Company__c = true Limit 50000];
            
            Map<Id, List<Work_Experience__c>> candidateWorkExperienceMap = new Map<Id, List<Work_Experience__c>>();
            if(!allWorkExp.isEmpty()){
                for(Work_Experience__c workExp : allWorkExp){
                    List<Work_Experience__c> tempWorkExp = new List<Work_Experience__c>();
                    if(candidateWorkExperienceMap.containsKey(workExp.CandidateId__c)){
                        tempWorkExp = candidateWorkExperienceMap.get(workExp.CandidateId__c);
                        tempWorkExp.add(workExp);
                    }else{
                        tempWorkExp.add(workExp);
                        candidateWorkExperienceMap.put(workExp.CandidateId__c, tempWorkExp);
                    }
                }
            }
            List<Work_Experience__c> workExpListToUpdate = new List<Work_Experience__c>();
            if(candidateWorkExperienceMap != null){
                for(List<Work_Experience__c> tempRelatedWorkExp : candidateWorkExperienceMap.values()){
                    workExpListToUpdate.addAll(tempRelatedWorkExp);
                }
                for(Work_Experience__c relatedWorkExp : workExpListToUpdate){
                    relatedWorkExp.Is_Current_Company__c = false;
                    //workExpListToUpdate.add(relatedWorkExp);
                }
            }
            if(!workExpListToUpdate.isEmpty()){
                Update workExpListToUpdate;
            }
        }
    }
}