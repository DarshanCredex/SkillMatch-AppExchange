import { LightningElement, track, api, wire } from 'lwc';
import fetchCandidateDetails from '@salesforce/apex/CandidateProfileController.getCandidateDetails';
import UserId from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
//import getData from '@salesforce/apex/resumeparserController.getData';
export default class CandidateProfile extends NavigationMixin(LightningElement) {
@track isExpModalOpen = false;
@track isEditModalOpen = false;
@track isResumeModalOpen = false;
@track isToDateDisabled = false;
@track isEditExpModalOpen = false;
@track userId = UserId;
@track candidateDetails;
@track candidateSkills;
@api recordId;
candidateDetailsWire;
@track experienceToUpdate;
@track experienceToUpdate;
@api isLoading = false;
@api isLoadingFullScreen = false
uploadedFile;
@track iframeLoading = true;

connectedCallback() {
    
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
}

@wire(fetchCandidateDetails, { userId: '$userId' }) list(result) {
    this.candidateDetailsWire = result;
    if (result.data) {
        this.candidateDetails = result.data;
        console.log('this.candidateDetails--->', JSON.stringify(this.candidateDetails)); 
        if(this.candidateDetails.Skills__c != undefined){
            this.candidateSkills = [...this.candidateDetails.Skills__c.split(',')];
        }
    } else if (result.error) {
        console.log("Error received in wire-----", result.error);
    }
    this.isLoadingFullScreen = false;
}

/*fetchCandidate() {
    fetchCandidateDetails({ userId: this.userId })
        .then(result => {
            console.log('result--->', result);
            this.candidateDetails = result;
            this.isLoadingFullScreen = false;
        })
        .catch(error => {
            console.error('Error:', error.message);
            this.isLoadingFullScreen = false;
        });
}*/

handleCurrentCompanyChange(event) {
    this.isToDateDisabled = event.detail.checked;
}
handleAdd() {
    this.isLoading = true;
    this.isExpModalOpen = true;
    this.isLoading = false;
}
get iframeSrc() {
    // Construct the URL for the VF page with the UserId passed as a query parameter
    console.log('useridfromlwc----->', this.userId);
    return `/apex/resumeparser?userId=${this.userId}`;
}
handleIframeLoad() {
    // This function is called when the iframe finishes loading
    console.log('frame loaded succesfully in lwc----->', this.userId);
    this.iframeLoading = false;
        this.iframeSrc();
     getData({ userId: this.userId})
    .then(result => {
        console.log('result--->', result);
    })
    .catch(error => {
        console.error('Error:', error.message);
    });
}

handleResume() {
    this.isLoading = true;
    this.isResumeModalOpen = true;
    this.isLoading = false;
    this.iframeLoading = true;
}

handleEdit() {
    this.isEditModalOpen = true;
    //this.fetchCandidateDetails();
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

closeEditExpModal() {
    this.isEditExpModalOpen = false;
    this.isToDateDisabled = false;
    this.isLoading = false;
}

handleCancel() {
    this.isEditModalOpen = false;
    this.isLoading = false;
}
handleSave() {
    this.isLoadingFullScreen = true;
    this.template.querySelector('lightning-record-edit-form[data-id="updateProfileForm"]').submit();
    this.isEditModalOpen = false;
    this.isLoadingFullScreen = false;
}
handleSuccess() {
    this.isLoadingFullScreen = true;
    // Refresh the page to show updated data
    refreshApex(this.candidateDetailsWire);
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'Profile updated successfully',
            variant: 'success'
        })
    );
    this.isLoadingFullScreen = false;
}
handleError() {
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Error',
            message: error.body.message,
            variant: 'error'
        })
    );
}

handleSubmitExperience() {
    //this.closeModal();
    this.isLoadingFullScreen = true;
    this.template.querySelector('lightning-record-edit-form[data-id="addExperienceForm"]').submit();        
    this.isExpModalOpen = false;
    this.isLoadingFullScreen = false;
}

handleAddSuccess() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'Experience added successfully',
            variant: 'success'
        })
    );
    this.isLoadingFullScreen = false;
}

handleEditExperience(event) {
    this.isLoading = true;
    this.experienceToUpdate = event.currentTarget.dataset.id;
    this.isEditExpModalOpen = true;
    this.isLoading = false; 
}

handleUpdateExperience(){
    this.isLoading = true;
    this.template.querySelector('lightning-record-edit-form[data-id="updateExperienceForm"]').submit();
    this.isLoading = false;
}

handleUpdateExpSuccess() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire); 
    this.closeEditExpModal();
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'Experience updated successfully',
            variant: 'success'
        })
    );
    this.isLoadingFullScreen = false;
}
}