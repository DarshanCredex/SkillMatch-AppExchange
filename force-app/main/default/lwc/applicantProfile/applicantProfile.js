import { LightningElement, wire } from "lwc";
import GetApplicantDataMethod from "@salesforce/apex/GetApplicantData.GetApplicantDataMethod";
import GetWorkExperienceData from "@salesforce/apex/GetApplicantData.GetWorkExperienceData";
import changeStatus from "@salesforce/apex/JobApplicantController.changeStatus";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getApplicantStatus from "@salesforce/apex/JobApplicantController.getApplicantStatus";

export default class ApplicantProfile extends LightningElement {
  applicantId = sessionStorage.getItem("candidateid");
  applicantDetails = [];
  workExpDetails = [];
  status;
  skills;
  IsAccepted = false;
  IsRejected = false;
  value;

  @wire(GetApplicantDataMethod, { applicantId: "$applicantId" })
  wiredGetApplicantDataMethod({ error, data }) {
    if (error) {
      console.log("error------->", error);
    }
    if (data) {
      this.applicantDetails = data;
      console.log("this.applicantDetails", this.applicantDetails);

      if (this.applicantDetails && this.applicantDetails.Skills__c) {
        this.skills = [...this.applicantDetails.Skills__c.split(",")];
        console.log("this.skills", this.skills);
      }
    }
    this.applicantStatus();
  }

  @wire(GetWorkExperienceData, { applicantId: "$applicantId" })
  wiredGetWorkExperienceData({ error, data }) {
    if (error) {
      console.log("error--->", error);
    }
    if (data) {
      this.workExpDetails = data;
      console.log("this.workExpDetails", this.workExpDetails);
    }
  }

  handleShortlistButton(event) {
    this.value = event.target.value;
    changeStatus({ value: this.value, applicantId: this.applicantId }).then(
      () => {
        console.log("true");
        this.showToast("Success", "Candidate Shortlisted", "success");
      }
    );
    this.IsAccepted = true;
  }
  handleRejectedButton(event) {
    this.value = event.target.value;
    changeStatus({ value: this.value, applicantId: this.applicantId }).then(
      () => {
        console.log("true");
        this.showToast("Rejected", "Candidate rejected", "Error");
      }
    );
    this.IsRejected = true;
    this.IsAccepted = true;
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

  applicantStatus() {
    getApplicantStatus({ applicantId: this.applicantId }).then((data) => {
      this.status = data;
      if (this.status === "Accepted") {
        this.IsAccepted = true;
      } else if (this.status === "Rejected") {
        this.IsRejected = true;
      }
    });
  }
}
