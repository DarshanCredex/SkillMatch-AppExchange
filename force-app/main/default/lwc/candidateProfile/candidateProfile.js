import { LightningElement, wire } from "lwc";
import fetchCandidateDetails from "@salesforce/apex/CandidateProfileController.getCandidateDetails";
import attachFileToCandidate from "@salesforce/apex/CandidateProfileController.attachFileToCandidate";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import addCandidateExperience from "@salesforce/apex/CandidateProfileController.addCandidateExperience";
import getIdFromEmail from "@salesforce/apex/CandidateProfileController.getIdFromEmail";
import workExp from "@salesforce/apex/CandidateProfileController.workExp";
import updateWorkExp from "@salesforce/apex/CandidateProfileController.updateWorkExp";
import fetchDetailsForEditDisplay from "@salesforce/apex/CandidateProfileController.fetchDetailsForEditDisplay";
import UpdateCandidateDetails from "@salesforce/apex/CandidateProfileController.UpdateCandidateDetails";
export default class CandidateProfile extends LightningElement {
  getOrganisation;
  getFromDate;
  getToDate;
  getCity;
  getCountry;
  getDesignation;

  setOrganisation;
  setFromDate;
  setToDate;
  setCity;
  setCountry;
  setDesignation;
  setCheckboxValue = false;

  setAbout;
  setPhoneNumber;
  setSkills;
  setExperience;
  setCTC;
  setCity_1;
  setCountry_1;

  // getAbout;
  // getPhoneNumber;
  // getSkills;
  // getExperience;
  // getCTC;
  // getCity_1;
  // getCountry_1;

  candidateDetailsWire;
  emailId;
  candidateId;

  isExpModalOpen = false;
  isEditModalOpen = false;
  isResumeModalOpen = false;
  isToDateDisabled = false;
  isEditExpModalOpen = false;
  getCheckboxValue = false;

  candidateDetails = [];
  candidateDetailsArray = [];
  candidateSkills = [];
  workExpDetails = [];
  fetchDetailsOfCandidate = [];

  connectedCallback() {
    this.emailId = localStorage.getItem("emailId");
    refreshApex(this.candidateDetailsWire);
    getIdFromEmail({ email: this.emailId }).then((result) => {
      this.candidateId = result;
    });
  }

  @wire(fetchCandidateDetails, { emailId: "$emailId" }) list(result) {
    this.candidateDetailsWire = result;
    if (result.data) {
      this.candidateDetails = result.data;
      this.candidateDetailsArray = Object.values(result.data);
      this.candidateSkills = [...this.candidateDetails.Skills__c.split(",")];
    } else if (result.error) {
      console.log("Error received in wire----->", result.error);
    }
    this.isLoadingFullScreen = false;
  }
  handleGetOrganisation(event) {
    this.getOrganisation = event.target.value;
  }
  handleGetFromDate(event) {
    this.getFromDate = event.target.value;
  }
  handleGetToDate(event) {
    this.getToDate = event.target.value;
  }
  handleGetCity(event) {
    this.getCity = event.target.value;
  }
  handleGetCountry(event) {
    this.getCountry = event.target.value;
  }
  handleGetCheckBoxValue(event) {
    this.getCheckboxValue = event.detail.checked;
  }
  handleGetDesignation(event) {
    this.getDesignation = event.target.value;
  }

  handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    if (uploadedFiles.length > 0) {
      const file = uploadedFiles[0];
      const base64Data = file.content.toString();
      attachFileToCandidate({
        emailId: this.email,
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
    fetchDetailsForEditDisplay({ email: this.emailId }).then((result) => {
      console.log("result----->", result);
      this.fetchDetailsOfCandidate = JSON.parse(result);
      if (this.fetchDetailsOfCandidate.length > 0) {
        this.setAbout = this.fetchDetailsOfCandidate[0].About__c;
        this.setPhoneNumber = this.fetchDetailsOfCandidate[0].Phone_Number__c;
        this.setSkills = this.fetchDetailsOfCandidate[0].Skills__c;
        this.setExperience = this.fetchDetailsOfCandidate[0].Experience__c;
        this.setCTC = this.fetchDetailsOfCandidate[0].CTC__c;
        this.setCity_1 = this.fetchDetailsOfCandidate[0].City__c;
        this.setCountry_1 = this.fetchDetailsOfCandidate[0].Country__c;
      }
    });
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

  handleAddExperience() {
    addCandidateExperience({
      organisation: this.getOrganisation,
      fromDate: this.getFromDate,
      toDate: this.getToDate,
      city: this.getCity,
      country: this.getCountry,
      checkboxValue: this.getCheckboxValue,
      candidateId: this.candidateId,
      Designation: this.getDesignation
    }).then(() => {
      this.showToast("Success", "New experience was added", "success");
      this.isEditModalOpen = false;
    });
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
    );
  }

  handleEditExperience(event) {
    this.isLoading = true;
    this.experienceToUpdate = event.currentTarget.dataset.id;
    console.log("this.experienceToUpdate----->", this.experienceToUpdate);
    this.isEditExpModalOpen = true;
    workExp({ workId: this.experienceToUpdate })
      .then((result) => {
        const data = result;
        this.workExpDetails = JSON.parse(data);
        console.log("this.workExpDetails------->", this.workExpDetails);
        if (this.workExpDetails.length > 0) {
          this.setOrganisation = this.workExpDetails[0].Organisation__c;
          this.setCountry = this.workExpDetails[0].Country__c;
          this.setCheckboxValue = this.workExpDetails[0].checkboxValue;
          this.setDesignation = this.workExpDetails[0].Name;
          this.setFromDate = this.workExpDetails[0].From_Date__c;
          this.setToDate = this.workExpDetails[0].To_Date__c;
          this.setCity = this.workExpDetails[0].City__c;
        }
      })
      .catch((error) => {
        console.error("Error fetching work experience: ", error);
      });
  }

  handleSetOrganisation(event) {
    this.setOrganisation = event.target.value;
  }
  handleSetFromDate(event) {
    this.setFromDate = event.target.value;
  }
  handleSetToDate(event) {
    this.setToDate = event.target.value;
  }
  handleSetDesignation(event) {
    this.setDesignation = event.target.value;
  }
  handleSetCity(event) {
    this.setCity = event.target.value;
  }
  handleSetCountry(event) {
    this.setCountry = event.target.value;
  }
  handleSetCheckboxValue(event) {
    this.setCheckboxValue = event.detail.checked;
  }

  handleUpdateExperience() {
    updateWorkExp({
      organisation: this.setOrganisation,
      fromDate: this.setFromDate,
      toDate: this.setToDate,
      city: this.setCity,
      country: this.setCountry,
      checkboxValue: this.setCheckboxValue,
      workExperienceId: this.experienceToUpdate,
      designation: this.setDesignation
    })
      .then(() => {
        this.showToast("Updated", "Experience was updated", "success");
        this.isEditExpModalOpen = false;
      })
      .catch((error) => {
        console.error("eroor--->", error);
        this.showToast("Error", "Some Error Occured", "error");
        this.isEditExpModalOpen = false;
      });
  }

  handleAbout(event) {
    this.setAbout = event.target.value;
  }
  handlePhoneNumber(event) {
    this.setPhoneNumber = event.target.value;
  }
  handleSkills(event) {
    this.setSkills = event.target.value;
  }
  handleTotalExperience(event) {
    this.setExperience = event.target.value;
  }
  handleSetCity_1(event) {
    this.setCity_1 = event.target.value;
  }
  handleCountry_1(event) {
    this.setCountry_1 = event.target.value;
  }

  handleUpdateCandidateDetails() {
    UpdateCandidateDetails({
      setAbout: this.setAbout,
      setPhoneNumber: this.setPhoneNumber,
      setSkills: this.setSkills,
      setExperience: this.setExperience,
      setCity_1: this.setCity_1,
      setCountry_1: this.setCountry_1,
      email: this.emailId
    })
      .then(() => {
        this.showToast("Updated", "Experience was updated", "success");
        this.isEditModalOpen = false;
      })
      .catch((error) => {
        console.error("eroor--->", error);
        this.showToast("Error", "Some Error Occured", "error");
      });
  }
}
