import { LightningElement, wire, track } from "lwc";
import no_jobs from "@salesforce/resourceUrl/no_jobs";
import { NavigationMixin } from "lightning/navigation";
import getJobs from "@salesforce/apex/GetPostedJobList.getJobs";
import Id from "@salesforce/user/Id";

export default class ManageJobs extends NavigationMixin(LightningElement) {
  @track jobList = [];
  @track postedJobList = [];
  @track draftedJobList = [];
  @track expiredJobList = [];

  showDrafts = false;
  showPostedJobs = true;
  IsEmptyJobList = true;
  IsEmptyDraftList = true;
  showExpiredJobList = false;
  IsEmptyExpiredJobList = true;

  jobId;
  noJobs = no_jobs;
  userId = Id;

  handlePageReference() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/add-jobs"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }

  @wire(getJobs, { userId: "$userId" })
  wireGetJobs({ error, data }) {
    if (error) {
      console.error("error----->", error);
      return;
    }
    if (data) {
      this.jobList = data;
      this.filterJobs();
    }
  }

  filterJobs() {
    this.postedJobList = this.jobList.filter((item) => {
      return item.status === "Completed";
    });
    this.IsEmptyJobList = this.postedJobList.length === 0;
    this.draftedJobList = this.jobList.filter((item) => {
      return item.status === "Draft";
    });
    this.IsEmptyDraftList = this.draftedJobList.length === 0;

    this.expiredJobList = this.postedJobList.filter((item) => {
      return item.Publish_end_date__c > Date.now();
    });
    this.IsEmptyExpiredJobList = this.expiredJobList.length === 0;
  }

  showPostedJobsTable() {
    this.showPostedJobs = true;
    this.showExpiredJobList = false;
    this.showDrafts = false;
  }

  showDraftsTable() {
    this.showPostedJobs = false;
    this.showExpiredJobList = false;
    this.showDrafts = true;
  }

  showExpiredJobs() {
    this.showPostedJobs = false;
    this.showExpiredJobList = true;
    this.showDrafts = false;
  }

  showBoth() {
    this.showPostedJobs = true;
    this.showExpiredJobList = false;
    this.showDrafts = true;
  }

  handlejobDescriptionPageView(event) {
    this.jobId = event.currentTarget.dataset.jobid;
    sessionStorage.setItem("postedJobId", this.jobId);
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/job-description-page"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
}
