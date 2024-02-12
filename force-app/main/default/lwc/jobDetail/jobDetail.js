import { LightningElement, wire, track } from 'lwc';
import getJobDetails from '@salesforce/apex/JobDetailController.getJobDescription';
import { CurrentPageReference } from 'lightning/navigation';

export default class JobDetail extends LightningElement {

    @track jobId;
    @track jobDetails;

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        console.log(currentPageReference);
        if (currentPageReference && currentPageReference.state.id) {
            this.jobId = currentPageReference.state.id;
            console.log('inside page reference---',this.jobId);
        }
    }

    @wire(getJobDetails, { jobId: '$jobId' })
    getJobDetail({data, error}){
        if(data){
            console.log('data-->',data);
            this.jobDetails = data;
        }else if(error){
            console.log('Error in getting the job details');
        }
    }
}