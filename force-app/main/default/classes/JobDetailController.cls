public with sharing class JobDetailController {
    
    @AuraEnabled(cacheable=true)
    public static JobDetailWrapper getJobDescription(String jobId) {
        System.debug('jobId---->'+jobId);
        Job__c jobDetail = [SELECT Id, Experience__c, Industry__c, CreatedDate, City__c, Country__c, Location__c, Salary__c, Title_of_position__c, Type__c, Company_Name__c, Summary__c FROM Job__c Where Id =: jobId Limit 1];
        
        return new JobDetailWrapper(jobDetail);
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
        public String jobType { get; set; }
        @AuraEnabled
        public String summary { get; set; }
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
            this.jobType = job.Type__c;
            this.summary = job.Summary__c;
            this.salary = job.Salary__c;
            this.location = job.Location__c;
            this.city = job.City__c;
            this.country = job.Country__c;
        }
        
        private Integer calculateDaysAgo(Datetime createdDate) {
            Datetime currentDate = Datetime.now();
            Long millisecondsAgo = currentDate.getTime() - createdDate.getTime();
            Integer daysAgo = (millisecondsAgo / (1000 * 60 * 60 * 24)).intValue();
            return daysAgo;
        }
    }
}