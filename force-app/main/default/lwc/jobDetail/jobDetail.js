import { LightningElement, wire, track } from 'lwc';
import getJobDetails from '@salesforce/apex/JobDetailController.getJobDescription';
import { CurrentPageReference } from 'lightning/navigation';

export default class JobDetail extends LightningElement {

    @track jobId = '';

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        console.log(currentPageReference);
        if (currentPageReference && currentPageReference.state.id) {
            this.jobId = currentPageReference.state.id;
            console.log('inside page reference---');
        }
    }

    @wire(getJobDetails, { jobId: '$urlId' })
    getJobDetail;
}