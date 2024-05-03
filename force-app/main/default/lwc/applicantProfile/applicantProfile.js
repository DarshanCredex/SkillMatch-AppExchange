import { LightningElement, wire } from "lwc";
import GetApplicantDataMethod from "@salesforce/apex/GetApplicantData.GetApplicantDataMethod";
import GetWorkExperienceData from "@salesforce/apex/GetApplicantData.GetWorkExperienceData";
import changeStatus from "@salesforce/apex/JobApplicantController.changeStatus";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getApplicantStatus from "@salesforce/apex/JobApplicantController.getApplicantStatus";
import getResume from "@salesforce/apex/GetApplicantData.getResume";
import getAppliedJobById from "@salesforce/apex/GetApplicantData.getAppliedJobById";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";

export default class ApplicantProfile extends NavigationMixin(
  LightningElement
) {
  applicantDetails = [];
  workExpDetails = [];

  status;
  applicantId;
  skills;
  appliedJob;
  value;
  contentDocumentId;
  pdfUrl;
  jobId;

  userId = Id;

  IsAccepted = false;
  IsRejected = false;

  connectedCallback() {
    this.jobId = sessionStorage.getItem("uniquejobId");
    this.applicantId = sessionStorage.getItem("candidateid");
  }

  @wire(GetApplicantDataMethod, { applicantId: "$applicantId" })
  wiredGetApplicantDataMethod({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      this.applicantDetails = data;

      if (this.applicantDetails && this.applicantDetails.Skills__c) {
        this.skills = [...this.applicantDetails.Skills__c.split(",")];
      }
    }
    this.applicantStatus();
  }

  @wire(getAppliedJobById, { jobId: "$jobId", userId: "$userId" })
  wiredGetAppliedJobById({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      this.appliedJob = data;
    }
  }
  @wire(GetWorkExperienceData, { applicantId: "$applicantId" })
  wiredGetWorkExperienceData({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      this.workExpDetails = data;
    }
  }

  handleShortlistButton(event) {
    this.value = event.target.value;
    changeStatus({
      value: this.value,
      applicantId: this.applicantId,
      jobId: this.jobId
    }).then(() => {
      this.showToast("Success", "Candidate Shortlisted", "success");
    });
    this.IsAccepted = true;
    this.IsRejected = false;
  }
  handleRejectedButton(event) {
    this.value = event.target.value;
    changeStatus({
      value: this.value,
      applicantId: this.applicantId,
      jobId: this.jobId
    }).then(() => {
      this.showToast("Rejected", "Candidate rejected", "Error");
    });
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
    getApplicantStatus({
      applicantId: this.applicantId,
      jobId: this.jobId
    }).then((data) => {
      this.status = data;
      if (this.status === "Accepted") {
        this.IsAccepted = true;
        this.IsRejected = false;
      } else if (this.status === "Rejected") {
        this.IsRejected = true;
        this.IsAccepted = true;
      }
    });
  }
  handleResumePreview() {
    this.downloadFiles();
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

  filesList = [];

  @wire(getResume, { applicantId: "$applicantId" })
  wiredResult({ data, error }) {
    if (data) {
      this.filesList = Object.keys(data).map((item) => ({
        label: data[item],
        value: item,
        url: `/sfc/servlet.shepherd/document/download/${item}`
      }));
    }
    if (error) {
      console.log(error);
    }
  }
}
