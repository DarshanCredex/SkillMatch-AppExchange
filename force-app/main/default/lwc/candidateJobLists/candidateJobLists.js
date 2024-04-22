import { LightningElement, wire, track } from "lwc";
import getAppliedJobListForHomePage from "@salesforce/apex/CandidateAppliedJobsController.getAppliedJobListForHomePage";
import getPendingJobListForHomePage from "@salesforce/apex/CandidateAppliedJobsController.getPendingJobListForHomePage";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";
import empty_box from "@salesforce/resourceUrl/empty_box";

export default class CandidateJobLists extends NavigationMixin(LightningElement) {
  @track AppliedList = [];
  @track PendingList = [];
  empty_box = empty_box;
  userId = Id;

  @wire(getAppliedJobListForHomePage, {
    userId: "$userId"
  })
  wiredGetAppliedJobList({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.AppliedList = data;
    }
  }
  @wire(getPendingJobListForHomePage, {
    userId: "$userId"
  })
  wiredGetPendingJobListForHomePage({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.PendingList = data;
    }
  }

  redirectToJobDescription(event) {
    let jobId = event.currentTarget.dataset.jobid;
    jobId = jobId.split("-");
    this[NavigationMixin.GenerateUrl]({
      type: "standard__webPage",
      attributes: {
        url: "/s/job-detail?id=" + jobId[0]
      }
    }).then((generatedUrl) => {
      window.open(generatedUrl);
    });
  }
}
