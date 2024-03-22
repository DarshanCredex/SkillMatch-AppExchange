public class resumeparserController {
    public String userId { get; set; }
    public String acceptedFormats { get; set; } 

    public List<String> acceptedFormats() {
        return new List<String>{'.pdf', '.png'};
            }
    @AuraEnabled(cacheable=true)
    public static Candidate_Details__c getData(Id userId) {
        
        system.debug('userId'+ userId);
        try{
            List<Candidate_Details__c> currentCandidate = [SELECT Id, Profile_Picture__c, Name, Candidate_Email__c, CTC__c, Date_of_birth__c, About__c, Phone_Number__c, Skills__c, Experience__c, City__c, Country__c,
                                                           (Select Id, Name, Organisation__c, From_Date__c, To_Date__c, City__c, Country__c From Work_Experience__r Order By From_Date__c Desc) FROM Candidate_Details__c WHERE User__c = :userId]; 
            if (currentCandidate.size() > 0){
                system.debug('Candidate_Details__c'+ currentCandidate[0].Id);
                return currentCandidate[0];
            }else{
                return new Candidate_Details__c();
            }
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}