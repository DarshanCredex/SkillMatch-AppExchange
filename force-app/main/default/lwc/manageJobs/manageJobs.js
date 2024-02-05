import { LightningElement, wire } from "lwc";
import no_jobs from "@salesforce/resourceUrl/no_jobs";
import { NavigationMixin } from "lightning/navigation";
import getPostedJobList from "@salesforce/apex/GetPostedJobList.getPostedJobList";
export default class ManageJobs extends NavigationMixin(LightningElement) {
  noJobs = no_jobs;
  postedJobList = [];
  IsEmptyJobList = false;
  jobId;

  handlePageReference() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/add-jobs"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
  @wire(getPostedJobList)
  wiredPostedJobList({ error, data }) {
    if (data) {
      this.postedJobList = data;
      if (this.postedJobList) {
        this.IsEmptyJobList = true;
      }
      console.log("this.postedJobList-------->", this.postedJobList);
    } else if (error) {
      console.log("error---->", error);
    }
  }
  handleApplicantListView(event) {
    this.jobId = event.target.value;
    console.log("jobid------>", this.jobId);
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/applicant-list-page"
      }
    }; 
    this[NavigationMixin.Navigate](pageReference);
    sessionStorage.setItem("id", this.jobId);
  }
}