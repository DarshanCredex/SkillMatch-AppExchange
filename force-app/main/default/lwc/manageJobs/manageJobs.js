import { LightningElement, wire, track } from "lwc";
import no_jobs from "@salesforce/resourceUrl/no_jobs";
import { NavigationMixin } from "lightning/navigation";
import getPostedJobList from "@salesforce/apex/GetPostedJobList.getPostedJobList";
import getDraftedJobList from "@salesforce/apex/GetPostedJobList.getDraftedJobList";
import { refreshApex } from "@salesforce/apex";

export default class ManageJobs extends NavigationMixin(LightningElement) {
  @track postedJobList = [];
  @track draftedJobList = [];
  @track expiredJobList = [];
  @track showDrafts = false;
  @track showPostedJobs = true;
  @track IsEmptyJobList = true;
  @track IsEmptyDraftList = true;
  @track showExpiredJobList = false;
  @track IsEmptyExpiredJobList = true;

  jobId;
  noJobs = no_jobs;

  // Store wired result variables
  wiredPostedJobListResult;
  wiredDraftedJobListResult;

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
  wiredPostedJobList(result) {
    this.wiredPostedJobListResult = result;
    const { data, error } = result;
    if (data) {
      this.postedJobList = data;
      if (this.postedJobList) {
        this.IsEmptyJobList = false;
      }
      console.log("this.postedJobList-------->", this.postedJobList);
      this.refreshData();
    } else if (error) {
      console.log("error------>", error);
    }
  }

  @wire(getDraftedJobList)
  wiredDraftedJobList(result) {
    this.wiredDraftedJobListResult = result;
    const { data, error } = result;
    if (data) {
      this.draftedJobList = data;
      console.log("this.draftedJobList------->", this.draftedJobList);
      this.refreshData();
      if (this.draftedJobList) {
        this.IsEmptyDraftList = false;
      }
    } else {
      console.log("error", error);
    }
  }

  // Method to refresh wired data
  refreshData() {
    refreshApex(this.wiredPostedJobListResult);
    refreshApex(this.wiredDraftedJobListResult);
  }

  handlejobDescriptionPageView(event) {
    this.jobId = event.currentTarget.dataset.jobid;
    console.log("jobid------>", this.jobId);
    sessionStorage.setItem("postedJobId", this.jobId);
    console.log("sessionStorage");
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/job-description-page"
      }
    };

    this[NavigationMixin.Navigate](pageReference);
  }

  showDraftsTable() {
    this.showDrafts = true;
    this.showPostedJobs = false;
    this.showExpiredJobList = false;
  }

  showPostedJobsTable() {
    this.showDrafts = false;
    this.showPostedJobs = true;
    this.showExpiredJobList = false;
  }

  showBoth() {
    this.showPostedJobs = true;
    this.showDrafts = true;
    this.showExpiredJobList = false;
  }

  showExpiredJobs() {
    this.showExpiredJobList = true;
    this.showPostedJobs = false;
    this.showDrafts = false;
    this.expiredJobList = this.postedJobList.filter(
      (item) => item.Publish_end_date__c > Date.now()
    );

    if (this.expiredJobList.length > 0) {
      this.IsEmptyExpiredJobList = false;
      this.showApplicantButton = true;
    }
  }
}