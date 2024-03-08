/* eslint-disable no-dupe-class-members */
/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, track, api, wire } from "lwc";
import fetchCandidateDetails from "@salesforce/apex/CandidateProfileController.getCandidateDetails";
import attachFileToCandidate from "@salesforce/apex/CandidateProfileController.attachFileToCandidate";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class CandidateProfile extends LightningElement {
  @track isExpModalOpen = false;
  @track isEditModalOpen = false;
  @track isResumeModalOpen = false;
  @track isToDateDisabled = false;
  @track isEditExpModalOpen = false;
  @track candidateDetails;
  @track candidateSkills;
  @api recordId;
  candidateDetailsWire;
  @track experienceToUpdate;
  @track experienceToUpdate;
  @api isLoading = false;
  @api isLoadingFullScreen = false;
  emailId;

  connectedCallback() {
    this.emailId = localStorage.getItem("emailId");
    console.log("this.emailId", this.emailId);
    refreshApex(this.candidateDetailsWire);
  }

  @wire(fetchCandidateDetails, { emailId: "$emailId" }) list(result) {
      this.candidateDetailsWire = result;
      console.log('result----->', result);
    if (result.data) {
      this.candidateDetails = result.data;
      console.log("Data received in wire---", result.data);
      this.candidateSkills = [...this.candidateDetails.Skills__c.split(",")];
      console.log(
        "this.candidateSkills--->",
        JSON.stringify(this.candidateSkills)
      );
    } else if (result.error) {
      console.log("Error received in wire----->", result.error);
    }
    this.isLoadingFullScreen = false;
  }

  handleCurrentCompanyChange(event) {
    this.isToDateDisabled = event.detail.checked;
  }
  handleAdd() {
    this.isLoading = true;
    this.isExpModalOpen = true;
    this.isLoading = false;
  }

  handleResume() {
    this.isLoading = true;
    this.isResumeModalOpen = true;
    this.isLoading = false;
  }

  handleEdit() {
    this.isEditModalOpen = true;
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

  get acceptedFormats() {
    return [".pdf"];
  }

  handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    if (uploadedFiles.length > 0) {
      const file = uploadedFiles[0];
      const base64Data = file.content.toString();
      attachFileToCandidate({
        email: this.email,
        fileName: file.name,
        base64Data: base64Data,
        contentType: file.type
      })
        .then(() => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "File attached successfully",
              variant: "success"
            })
          );
        })
        .catch((error) => {
          console.error("Error attaching file: ", error);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error",
              message: "Error attaching file: " + error.body.message,
              variant: "error"
            })
          );
        });
    }
  }

  handleSave() {
    this.isLoadingFullScreen = true;
    this.template
      .querySelector('lightning-record-edit-form[data-id="updateProfileForm"]')
      .submit();
    this.isEditModalOpen = false;
    this.isLoadingFullScreen = false;
  }
  handleSuccess() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Profile updated successfully",
        variant: "success"
      })
    );
    this.isLoadingFullScreen = false;
  }
  handleError() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Error",
        message: "error",
        variant: "error"
      })
    );
  }

  handleSubmitExperience() {
    this.isLoadingFullScreen = true;
    this.template
      .querySelector('lightning-record-edit-form[data-id="addExperienceForm"]')
      .submit();
    this.isExpModalOpen = false;
    this.isLoadingFullScreen = false;
  }

  handleAddSuccess() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Experience added successfully",
        variant: "success"
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

  handleUpdateExperience() {
    this.isLoading = true;
    this.template
      .querySelector(
        'lightning-record-edit-form[data-id="updateExperienceForm"]'
      )
      .submit();
    this.isLoading = false;
  }

  handleUpdateExpSuccess() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
    this.closeEditExpModal();
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Experience updated successfully",
        variant: "success"
      })
    );
    this.isLoadingFullScreen = false;
  }
}
