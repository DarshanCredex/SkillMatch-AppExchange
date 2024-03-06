import { LightningElement, wire, track } from "lwc";
import getJobDetails from "@salesforce/apex/JobDetailController.getJobDescription";
import { CurrentPageReference } from "lightning/navigation";
import isGuest from "@salesforce/user/isGuest";
import checkJobStatus from "@salesforce/apex/JobDetailController.checkJobStatus";
import createJobApplicants from "@salesforce/apex/JobDetailController.createJobApplicants";

export default class JobDetail extends LightningElement {
  @track userId;
  @track isGuestUser = isGuest;
  @track jobId;
  @track jobDetails = [];
  @track jobStatus = false;

  emailId;
  showUser = false;

  connectedCallback() {
    this.emailId = sessionStorage.getItem("emailId");
    if (this.emailId) {
      this.showUser = true;
    }
  }

  @wire(CurrentPageReference)
  getPageReferenceParameters(currentPageReference) {
    console.log(currentPageReference);
    if (currentPageReference && currentPageReference.state.id) {
      this.jobId = currentPageReference.state.id;
      console.log("inside page reference---", this.jobId);
    }
  }

  @wire(checkJobStatus, { email: "$emailId", jobId: "$jobId" })
  wiredcheckJobStatus({ error, data }) {
    if (data) {
      this.jobStatus = data;
      console.log("status-->", this.jobStatus);
    } else {
      console.log("Error in getting status", error);
    }
  }

  @wire(getJobDetails, { jobId: "$jobId" })
  wiredgetJobDetail({ error, data }) {
    if (error) {
      console.error("error----->", error);
    }
    if (data) {
      this.jobDetails = data;
      console.log("this.jobDetails-------->", this.jobDetails);
    }
  }

  handleApply() {
    if (this.emailId != null && this.jobId != null) {
      createJobApplicants({ email: "$email", jobId: this.jobId })
        .then((result) => {
          this.jobStatus = result;
          console.log("this.jobStatus", this.jobStatus);
        })
        .catch((error) => {
          console.log("error-->", error);
        });
    }
  }
}
