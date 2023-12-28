import { LightningElement, wire } from 'lwc';
import getJobs from '@salesforce/apex/JobListController.getJobList';
import alternateCompanyLogo from '@salesforce/resourceUrl/Alternate_Company_Logo';
export default class JobList extends LightningElement {
    @wire(getJobs)
    jobList;
    companyLogo = alternateCompanyLogo;
}