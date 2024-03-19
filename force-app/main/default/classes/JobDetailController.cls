public with sharing class JobDetailController {
    
    @AuraEnabled
    public static Boolean createJobApplicants(Id userId, Id jobId) {
        System.debug('userId---->'+userId);
        System.debug('jobId---->'+jobId);
        if(userId != null){
            List<Candidate_Details__c> candidate = [Select Id From Candidate_Details__c Where User__c =: userId Limit 1];
            if(candidate.size() > 0){
                Job_Applicants__c applicant = new Job_Applicants__c();
                applicant.CandidateId__c = candidate[0].Id;
                applicant.Job_Id__c = jobId;
                applicant.Application_Status__c = 'Pending';
                try{
                    Insert applicant; 
                    return true;
                }catch(DMLException e){
                    return false;
                }
            }
        }
        return false;
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean checkJobStatus(String userId, String jobId){
        System.debug('jobId---->'+jobId);
        System.debug('userId---->'+userId);
        if(userId != null && jobId != null){
        List<Candidate_Details__c> CandidateId = [Select Id FROM Candidate_Details__c WHERE User__c = :userId Limit 1];
        if(CandidateId.size() > 0){
            String candId = CandidateId[0].Id;
        List<Job_Applicants__c> jobApplication = [Select Id From Job_Applicants__c Where CandidateId__c =: candId AND Job_Id__c =: jobId Limit 1];
        if(jobApplication.size() > 0){
            return true;
        }
        }
        }
        return false;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<JobDetailWrapper> getJobDescription(String jobId) {
        System.debug('jobId---->'+jobId);
        Job__c jobDetail = [SELECT Id, Experience__c, Skills_Required__c, Industry__c, CreatedDate, City__c, Country__c, Location__c, Salary__c, Description__c, Title_of_position__c, Type__c, Company_Name__c, Summary__c FROM Job__c Where Id =: jobId Limit 1];
        
        return new List<JobDetailWrapper>{new JobDetailWrapper(jobDetail)};
            }
    
    public class JobDetailWrapper {
        @AuraEnabled
        public Id jobId { get; set; }
        @AuraEnabled
        public Integer daysAgo { get; private set; }
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String company { get; set; }
        @AuraEnabled
        public String experienceLevel { get; set; }
        @AuraEnabled
        public List<String> skills { get; private set; }
        @AuraEnabled
        public String jobType { get; set; }
        @AuraEnabled
        public String summary { get; set; }
        @AuraEnabled
        public String desciption { get; set; }
        @AuraEnabled
        public Decimal salary { get; set; }
        @AuraEnabled
        public System.Location location { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public String country { get; set; }
        
        public JobDetailWrapper(Job__c job) {
            this.jobId = job.Id;
            this.daysAgo = calculateDaysAgo(job.CreatedDate);
            this.title = job.Title_of_position__c;
            this.company = job.Company_Name__c;
            this.skills = separateSkills(job.Skills_Required__c);
            this.experienceLevel = job.Experience__c;
            this.jobType = job.Type__c;
            this.summary = job.Summary__c;
            this.desciption = job.Description__c;
            this.salary = job.Salary__c;
            this.location = job.Location__c;
            this.city = job.City__c;
            this.country = job.Country__c;
        }
        
        private List<String> separateSkills(String skill) {
            Set<String> skillsSet = new Set<String>();
            if(String.isNotBlank(skill)){
                skillsSet.addAll(skill.Split(','));
            }
            return new List<String>(skillsSet);
        }
        
        private Integer calculateDaysAgo(Datetime createdDate) {
            Datetime currentDate = Datetime.now();
            Long millisecondsAgo = currentDate.getTime() - createdDate.getTime();
            Integer daysAgo = (millisecondsAgo / (1000 * 60 * 60 * 24)).intValue();
            return daysAgo;
        }
    }
}