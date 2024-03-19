import { LightningElement, wire, track } from 'lwc';
import getJobDetails from '@salesforce/apex/JobDetailController.getJobDescription';
import { CurrentPageReference } from 'lightning/navigation';
import USER_ID from '@salesforce/user/Id';
import isGuest from '@salesforce/user/isGuest';
//import USER_PROFILE_ID from '@salesforce/schema/User.ProfileId';
//import { getRecord } from 'lightning/uiRecordApi';
import checkJobStatus from '@salesforce/apex/JobDetailController.checkJobStatus';
import createJobApplicants from '@salesforce/apex/JobDetailController.createJobApplicants';

export default class JobDetail extends LightningElement {

    @track userId;
    @track isGuestUser = isGuest;
    @track jobId;   
    @track jobDetails = [];
    @track jobStatus = false;

    /*@wire(getRecord, { recordId: USER_ID, fields: [USER_PROFILE_ID] })
    userDetails({ error, data }) {
        if (data) {
            this.userId = data.id;
            this.userProfileId = data.fields.ProfileId.value;

            console.log('userProfileName--->',this.userProfileName);
        } else if (error) {
            // Handle error
        }
    }*/

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        console.log(currentPageReference);
        if (currentPageReference && currentPageReference.state.id) {
            this.jobId = currentPageReference.state.id;
            console.log('inside page reference---',this.jobId);
        }
    }

    @wire(checkJobStatus, {userId: USER_ID, jobId: '$jobId'})
    checkJobStatus({ error, data }) {
        if (data) {
            this.jobStatus = data;
            console.log("status-->", data);
        } else {
            console.log("Error in getting status",error);
        }
    }

    @wire(getJobDetails, {jobId: '$jobId' })
    getJobDetail({ error, data }) {
        if (error) {
          console.error("error----->", error);
        }
        if (data) {
          this.jobDetails = data;
          console.log("this.jobDetails-------->", this.jobDetails);
        }
    }

    handleApply() {
        console.log("USER_ID-------->", USER_ID);
        console.log("this.jobId-------->", this.jobId);
        if (USER_ID != null && this.jobId != null) {
            createJobApplicants({ userId: USER_ID, jobId: this.jobId })
                .then(result => {
                    console.log('result-->', result);
                    this.jobStatus = result;
                })
                .catch(error => {
                    console.log('error-->', error);
                })

                refreshApex(this.checkJobStatus);
        }
    }
}