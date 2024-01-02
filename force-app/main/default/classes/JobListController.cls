public with sharing class JobListController {

    @AuraEnabled(cacheable=true)
    public static List<String> getTypeValues() {
        Schema.DescribeFieldResult fieldResult = Job__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> typeValues = fieldResult.getPicklistValues();
        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : typeValues) {
            values.add(entry.getLabel());
        }
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getIndustryValues() {
        Schema.DescribeFieldResult fieldResult = Job__c.Industry__c.getDescribe();
        List<Schema.PicklistEntry> industryValues = fieldResult.getPicklistValues();
        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : industryValues) {
            values.add(entry.getLabel());
        }
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getExperienceValues() {
        Schema.DescribeFieldResult fieldResult = Job__c.Experience__c.getDescribe();
        List<Schema.PicklistEntry> experienceValues = fieldResult.getPicklistValues();
        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : experienceValues) {
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<JobWrapper> getJobList() {
        // Replace this query with your actual logic to fetch jobs
        List<Job__c> jobs = [SELECT Id, City__c, Country__c, Location__c, Salary__c, Title_of_position__c, Type__c, Company_Name__c, Summary__c FROM Job__c];

        List<JobWrapper> wrappedJobs = new List<JobWrapper>();
        for (Job__c job : jobs) {
            wrappedJobs.add(new JobWrapper(job));
        }

        return wrappedJobs;
    }

    public class JobWrapper {
        @AuraEnabled
        public Id jobId { get; set; }
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

        public JobWrapper(Job__c job) {
            this.jobId = job.Id;
            this.title = job.Title_of_position__c;
            this.company = job.Company_Name__c;
            this.jobType = job.Type__c;
            this.summary = job.Summary__c;
            this.salary = job.Salary__c;
            this.location = job.Location__c;
            this.city = job.City__c;
            this.country = job.Country__c;
        }
    }
}