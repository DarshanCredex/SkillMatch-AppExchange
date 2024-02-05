import { LightningElement, track, api } from 'lwc';
import createExperience from '@salesforce/apex/CandidateProfileController.createWorkExperience';
import fetchCandidateDetails from '@salesforce/apex/CandidateProfileController.getCandidateDetails';
import updateCandidateDetails from '@salesforce/apex/CandidateProfileController.updateCandidateDetails';
import UserId from '@salesforce/user/Id';

export default class CandidateProfile extends LightningElement {
    @track isExpModalOpen = false;
    @track isEditModalOpen = false;
    @track isResumeModalOpen = false;
    @track isToDateDisabled = false;
    @track userId = UserId;
    @track candidateDetails;
    @api recordId;
    @api isLoading = false;

    handleCurrentCompanyChange(event) {
        this.isToDateDisabled = event.detail.checked;
    }
    handleAdd() {
        this.isLoading = true;
        this.isExpModalOpen = true;
        this.isLoading = false;
    }

    handleResume() {
        this.isResumeModalOpen = true;
    }

    handleEdit() {
        this.isEditModalOpen = true;
        this.isLoading = true;
        this.fetchCandidateDetails();
    }

    closeResumeModal() {
        this.isResumeModalOpen = false;
    }

    closeModal() {
        this.isExpModalOpen = false;
        this.isToDateDisabled = false;
        this.isLoading = false;
    }

    closeEditModal() {
        this.isEditModalOpen = false;
        this.isToDateDisabled = false;
        this.isLoading = false;
    }

    handleCancel() {
        this.isEditModalOpen = false;
        this.isLoading = false;
    }

    get acceptedFormats() {
        return ['.pdf'];
    }

    async fetchCandidateDetails() {
        console.log('userId--->', this.userId);
        this.candidateDetails = await fetchCandidateDetails({ userId: this.userId });
        this.isLoading = false;
        console.log('candidateDetails--->', JSON.stringify(this.candidateDetails));
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files.length;
        console.log('uploadedFiles--->', uploadedFiles);
        const evt = new ShowToastEvent({
            title: 'SUCCESS',
            message: uploadedFiles + ' File(s) uploaded  successfully',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    handleSave() {
        // Get the form data
        const formData = this.template.querySelector('lightning-record-edit-form').getValues();
        
        // Save the data to Salesforce
        updateCandidateDetails({ fields: formData })
          .then(result => {
            // Show a success message
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Success',
                message: 'Profile saved successfully',
                variant: 'success'
              })
            );
      
            // Reset the form
            this.template.querySelector('lightning-record-edit-form').reset();
          })
          .catch(error => {
            // Show an error message
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
              })
            );
          });
      }

    handleSubmitExperience() {
        // Access form data and call Apex method to create the record
        createExperience({
            organisation: this.template.querySelector('lightning-input-field[field-name="Organisation__c"]').value,
            isCurrentCompany: this.template.querySelector('lightning-input-field[field-name="Is_Current_Company__c"]').value,
            fromDate: this.template.querySelector('lightning-input-field[field-name="From_Date__c"]').value,
            toDate: this.template.querySelector('lightning-input-field[field-name="To_Date__c"]').value,
            City: this.template.querySelector('lightning-input-field[field-name="City__c"]').value,
            Country: this.template.querySelector('lightning-input-field[field-name="Country__c"]').value,
        })
            .then(() => {
                // Handle success, e.g., close modal, display success message, refresh list
                this.closeModal();
                this.dispatchEvent(new CustomEvent('experiencecreated'));
            })
            .catch(error => {
                // Handle errors, e.g., display error message
            });
    }
}