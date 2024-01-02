import { LightningElement, wire } from 'lwc';
import getJobs from '@salesforce/apex/JobListController.getJobList';
import alternateCompanyLogo from '@salesforce/resourceUrl/Alternate_Company_Logo';
import getTypePicklistValues from '@salesforce/apex/JobListController.getTypeValues';
import getExperiencePicklistValues from '@salesforce/apex/JobListController.getExperienceValues';
import getIndustryPicklistValues from '@salesforce/apex/JobListController.getIndustryValues';

export default class JobList extends LightningElement {
    companyLogo = alternateCompanyLogo;
    sortValue = 'date';
    typeValues = [];
    experienceValues = [];
    industryValues = [];

    connectedCallback() {
        getTypePicklistValues()
            .then(result => {
                this.typeValues = result;
            })
            .catch(error => {
                console.error('Error fetching type picklist values:', error);
            });
        getExperiencePicklistValues()
            .then(result => {
                this.experienceValues = result;
            })
            .catch(error => {
                console.error('Error fetching experience picklist values:', error);
            });
        getIndustryPicklistValues()
            .then(result => {
                this.industryValues = result;
            })
            .catch(error => {
                console.error('Error fetching industry picklist values:', error);
            });
    }

    @wire(getJobs)
    jobList;

    //console.log('type option ---> ', this.propertyOrFunction);
    get sortOptions() {
        return [
            { label: 'Date', value: 'date' },
            { label: 'Closet', value: 'closet' },
        ];
    }

    getDaysAgo() {
        
        const createdDate = new Date(this.record.CreatedDate);

        // Get the current date
        const currentDate = new Date();

        // Calculate the difference in milliseconds
        const timeDifference = currentDate - createdDate;

        // Convert the difference to days
        const daysAgo = Math.floor(timeDifference / (1000 * 60 * 60 * 24));

        return daysAgo;
    }

    handleTypeChange(event) {
        const selectedTypeValues = event.target.checked ? [event.target.value] : [];
        // Store or process the selected values as needed
    }

    handleExperienceChange(event) {
        const selectedExperienceValues = event.target.checked ? [event.target.value] : [];
        // Store or process the selected values as needed
    }

    handleIndustryChange(event) {
        const selectedIndustryValues = event.target.checked ? [event.target.value] : [];
        // Store or process the selected values as needed
    }

    handleChange(event) {
        this.sortValue = event.detail.value;
    }
}