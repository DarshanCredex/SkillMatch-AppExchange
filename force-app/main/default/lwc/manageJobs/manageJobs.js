import { LightningElement, wire, track } from "lwc";
import no_jobs from "@salesforce/resourceUrl/no_jobs";
import { NavigationMixin } from "lightning/navigation";
import getPostedJobList from "@salesforce/apex/GetPostedJobList.getPostedJobList";
import getDraftedJobList from "@salesforce/apex/GetPostedJobList.getDraftedJobList";
export default class ManageJobs extends NavigationMixin(LightningElement) {
  @track postedJobList = [];
  @track draftedJobList = [];
  @track showDrafts = false;
  @track showPostedJobs = true;
  @track IsEmptyJobList = false;
  @track IsEmptyDraftList = false;
  jobId;
  noJobs = no_jobs;

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
  @wire(getDraftedJobList)
  wiredDraftedJObList({ error, data }) {
    if (data) {
      this.draftedJobList = data;
      console.log("this.draftedJobList------->", this.draftedJobList);
      if (this.draftedJobList) {
        this.IsEmptyDraftList = true;
      }
    } else {
      console.log("error", error);
    }
  }
  handleApplicantListView(event) {
    this.jobId = event.currentTarget.dataset.jobid;
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
  showDraftsTable() {
    this.showDrafts = true;
    this.showPostedJobs = false;
  }
  showPostedJobsTable() {
    this.showPostedJobs = true;
    this.showDrafts = false;
  }
  showBoth() {
    this.showPostedJobs = true;
    this.showDrafts = true;
  }
}
