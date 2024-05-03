/* eslint-disable no-undef */
/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, track, api, wire } from "lwc";
import fetchCandidateDetails from "@salesforce/apex/CandidateProfileController.getCandidateDetails";
import getResume from "@salesforce/apex/CandidateProfileController.getResume";
import UserId from "@salesforce/user/Id";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import deleteWorkExperience from "@salesforce/apex/CandidateProfileController.deleteWorkExperience";

export default class CandidateProfile extends NavigationMixin(
  LightningElement
) {
  @track isExpModalOpen = false;
  @track isEditModalOpen = false;
  @track isResumeModalOpen = false;
  @track isToDateDisabled = false;
  @track isEditExpModalOpen = false;
  @track userId = UserId;
  @track candidateTitle;
  @track candidateDetails;
  @track candidateSkills;
  @api recordId;
  candidateDetailsWire;
  resumeDetailWire;
  @track experienceToUpdate;
  @api isLoading = false;
  @api isLoadingFullScreen = false;
  uploadedFile;
  @track iframeLoading = false;
  filesList = [];
  profileProgress = 0;

  connectedCallback() {
    this.isLoadingFullScreen = true;
    refreshApex(this.candidateDetailsWire);
    window.addEventListener("message", this.handleMessage.bind(this), false);
  }

  disconnectedCallback() {
    window.removeEventListener("message", this.handleMessage.bind(this), false);
  }

  handleMessage(event) {
    const message = event.data;
    if (message === "closeModal") {
      this.isResumeModalOpen = false;
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message: "Resume uploaded successfully",
          variant: "success"
        })
      );
    }
  }
  @wire(fetchCandidateDetails, { userId: "$userId" }) list(result) {
    this.candidateDetailsWire = result;
    if (result.data) {
      this.candidateDetails = result.data;
      if (this.candidateDetails.Skills__c !== undefined) {
        this.candidateSkills = [...this.candidateDetails.Skills__c.split(",")];
        this.profileProgress += 20;
      }
      if (this.candidateDetails.Work_Experience__r !== undefined) {
        this.candidateTitle = this.candidateDetails.Work_Experience__r[0].Name;
        this.profileProgress += 20;
      }
    } else if (result.error) {
      return;
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
  get iframeSrc() {
    return `/apex/resumeparser?userId=${this.userId}`;
  }
  handleIframeLoad() {
    this.iframeLoading = false;
    this.iframeSrc();
  }
  handleResume() {
    this.isResumeModalOpen = true;
    this.isLoading = false;
    this.iframeLoading = true;
    refreshApex(this.resumeDetailWire);
  }
  downloadFiles() {
    const anchor = document.createElement("a");
    anchor.style.display = "none";
    document.body.appendChild(anchor);

    this.filesList.forEach((file) => {
      anchor.href = file.url;
      anchor.download = file.label;
      anchor.click();
    });

    document.body.removeChild(anchor);
  }

  @wire(getResume, { userId: "$userId" })
  wiredResult(result) {
    this.resumeDetailWire = result;
    if (result.data) {
      this.profileProgress += 50;
      this.filesList = Object.keys(result.data).map((item) => ({
        label: result.data[item],
        value: item,
        url: `/sfc/servlet.shepherd/document/download/${item}`
      }));
    } else if (result.error) {
      console.error("error", result.error);
    }
  }
  handleEdit() {
    this.isEditModalOpen = true;
  }

  closeResumeModal() {
    refreshApex(this.resumeDetailWire);
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
        message: error.body.message,
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

  handleDeleteExperience() {
    deleteWorkExperience({ workExpId: this.experienceToUpdate })
      .then(() => {
        refreshApex(this.candidateDetailsWire);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Experience deleted successfully",
            variant: "success"
          })
        );
        this.closeEditExpModal();
      })
      .catch((error) => {
        console.error("errror---->", error);
      });
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
