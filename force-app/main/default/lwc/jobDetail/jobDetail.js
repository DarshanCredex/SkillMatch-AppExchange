import { LightningElement, wire, track } from "lwc";
import getJobDetails from "@salesforce/apex/JobDetailController.getJobDescription";
import { CurrentPageReference } from "lightning/navigation";
import USER_ID from "@salesforce/user/Id";
import isGuest from "@salesforce/user/isGuest";
import checkJobStatus from "@salesforce/apex/JobDetailController.checkJobStatus";
import createJobApplicants from "@salesforce/apex/JobDetailController.createJobApplicants";
import { refreshApex } from "@salesforce/apex";

export default class JobDetail extends LightningElement {
  @track userId;
  @track isGuestUser = isGuest;
  @track jobId;
  @track jobDetails = [];
  @track jobStatus = false;

  @wire(CurrentPageReference)
  getPageReferenceParameters(currentPageReference) {
    console.log(currentPageReference);
    if (currentPageReference && currentPageReference.state.id) {
      this.jobId = currentPageReference.state.id;
    }
  }

  @wire(checkJobStatus, { userId: USER_ID, jobId: "$jobId" })
  checkJobStatus({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      this.jobStatus = data;
    }
  }

  @wire(getJobDetails, { jobId: "$jobId" })
  getJobDetail({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      this.jobDetails = data;
    }
  }

  handleApply() {
    if (USER_ID != null && this.jobId != null) {
      createJobApplicants({ userId: USER_ID, jobId: this.jobId })
        .then((result) => {
          this.jobStatus = result;
        })
        .catch((error) => {
          console.log("error-->", error);
        });
      refreshApex(this.checkJobStatus);
    }
  }
}