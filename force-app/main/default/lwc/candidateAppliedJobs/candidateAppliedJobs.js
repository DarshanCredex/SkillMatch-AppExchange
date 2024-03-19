import { LightningElement, api, track, wire } from 'lwc';

import alternateCompanyLogo from '@salesforce/resourceUrl/Alternate_Company_Logo';
import getAppliedJobs from '@salesforce/apex/CandidateAppliedJobsController.getAppliedJobs';
import { NavigationMixin } from 'lightning/navigation';
import UserId from '@salesforce/user/Id';
import emptyBox from "@salesforce/resourceUrl/empty_box";

export default class CandidateAppliedJobs extends NavigationMixin(LightningElement) {
    companyLogo = alternateCompanyLogo;
    @api candidateId;
    @track appliedJob = [];
    @track selectedJob;
    emptyBox = emptyBox;
    @track addAppliedCss = 'information active';
    @track addShortlistedCss = 'information';
    @track addPendingCss = 'information';
    @track isLoading = false;
    @track searchCompany = '';
    @track searchTitle = '';
    @track userId = UserId;
    @track selectedTab = 'Applied';
    @track errorMessage = false;
  
    handleSearchTitleChange(event) {
        this.searchTitle = event.target.value;
    }

    handleSearchLocationChange(event) {
        this.searchCompany = event.target.value;
    }

    @wire(getAppliedJobs, { searchTitle: '$searchTitle', searchCompany: '$searchCompany', userId: '$userId' })
    appliedJobList({data, error}){
        if(data){
            this.isLoading = true;
            console.log('Received data-->', data);
            this.appliedJob = data;
            if (this.selectedTab === 'Pending') {
                this.handleTabChange3();
            } else if (this.selectedTab === 'Shortlisted') {
                this.handleTabChange2();
            } else {
                this.handleTabChange();
            }
            this.isLoading = false;
        } else {
            console.log('Received error-->', error);
        }
    }

    handleJobDetail(event) {
        let jobId = event.currentTarget.id;
        jobId = jobId.split("-");
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: '/s/job-detail?id=' + jobId[0]
                }
            }).then(generatedUrl => {
                window.open(generatedUrl);
            });
    }

    handleTabChange() {
        this.isLoading = true;
        this.selectedTab = 'Applied';
        this.addAppliedCss = 'information active';
        this.addShortlistedCss = 'information';
        this.addPendingCss = 'information';
        this.selectedJob = this.appliedJob;
        console.log('selectedJob-->', this.selectedJob);
        if(this.selectedJob.jobWrapperList.length > 0){
            this.errorMessage = false;
        }else{
            this.errorMessage = true;
        }
        this.isLoading = false;
    }
    handleTabChange2() {
        this.isLoading = true;
        this.selectedTab = 'Shortlisted';
        this.addAppliedCss = 'information';
        this.addShortlistedCss = 'information active';
        this.addPendingCss = 'information';
        this.selectedJob = this.appliedJob;
        console.log('selectedJob21-->', this.selectedJob);
        try {
            const filteredJobList = this.selectedJob.jobWrapperList.filter(job => job.status === 'Shortlisted');
            // Create a new object with the filtered jobWrapperList
            const updatedSelectedJob = { ...this.selectedJob, jobWrapperList: filteredJobList };
            // Assign the new object to this.selectedJob
            this.selectedJob = updatedSelectedJob;
        } catch (e) {
            console.error('Error in filtering shortlisted jobs --> ', e.message);
        } finally {
            console.log('Selected Job after filter -->', this.selectedJob);
            if(this.selectedJob.jobWrapperList.length > 0){
                this.errorMessage = false;
            }else{
                this.errorMessage = true;
            }
        }
        this.isLoading = false;
    }
    handleTabChange3() {
        this.isLoading = true;
        this.selectedTab = 'Pending';
        this.addAppliedCss = 'information';
        this.addShortlistedCss = 'information';
        this.addPendingCss = 'information active';
        this.selectedJob = this.appliedJob;
        try {
            const filteredJobList = this.selectedJob.jobWrapperList.filter(job => job.status === 'Pending');
            // Create a new object with the filtered jobWrapperList
            const updatedSelectedJob = { ...this.selectedJob, jobWrapperList: filteredJobList };
            // Assign the new object to this.selectedJob
            this.selectedJob = updatedSelectedJob;
        } catch (e) {
            console.error('Error in filtering shortlisted jobs --> ', e.message);
        } finally {
            console.log('Selected Job after filter -->', this.selectedJob);
            if(this.selectedJob.jobWrapperList.length > 0){
                this.errorMessage = false;
            }else{
                this.errorMessage = true;
            }
        }
        this.isLoading = false;
    }
}