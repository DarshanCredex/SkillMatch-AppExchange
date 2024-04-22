import { LightningElement, wire, track } from "lwc";
import getAppliedJobListForHomePage from "@salesforce/apex/CandidateAppliedJobsController.getAppliedJobListForHomePage";
import getPendingJobListForHomePage from "@salesforce/apex/CandidateAppliedJobsController.getPendingJobListForHomePage";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";
import empty_box from "@salesforce/resourceUrl/empty_box";
import getCandidateDetails from "@salesforce/apex/CandidateProfileController.getCandidateDetails";
import getResume from "@salesforce/apex/CandidateProfileController.getResume";
import numberOfShorlistedJobs from "@salesforce/apex/CandidateAppliedJobsController.numberOfShorlistedJobs";
import numberOfPendingJobs from "@salesforce/apex/CandidateAppliedJobsController.numberOfPendingJobs";

export default class CandidateJobLists extends NavigationMixin(
  LightningElement
) {
  @track AppliedList = [];
  @track PendingList = [];
  @track candidateDetails = [];
  empty_box = empty_box;
  userId = Id;
  profileProgress = 0;
  numberOfShortlisted;
  numberOfPending;
  candidateResume;

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

  @wire(numberOfShorlistedJobs, { userId: "$userId" })
  wiredNumberOfShortlistedJobs({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.numberOfShortlisted = data;
    }
  }

  @wire(numberOfPendingJobs, { userId: "$userId" })
  wiredNumberOfPendingJobs({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.numberOfPending = data;
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

  @wire(getResume, {
    userId: "$userId"
  })
  wiredGetResume({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.candidateResume = data;
      if (this.candidateResume !== null) {
        this.profileProgress += 40;
      }
    }
  }
  @wire(getCandidateDetails, {
    userId: "$userId"
  })
  wiredGetCandidateDetails({ data, error }) {
    if (error) {
      return;
    }
    if (data) {
      this.candidateDetails = data;
      this.profileProgress += this.candidateDetails.Work_Experience__r?.length
        ? 20
        : 0;
      this.profileProgress += this.candidateDetails.Skills__c ? 20 : 0;
      this.profileProgress += this.candidateDetails.Candidate_Email__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.Name ? 2 : 0;
      this.profileProgress += this.candidateDetails.Profile_Picture__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.CTC__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.Date_of_birth__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.About__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.Phone_Number__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.Experience__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.City__c ? 2 : 0;
      this.profileProgress += this.candidateDetails.Country__c ? 2 : 0;

      this.profileProgress = Math.min(Math.max(this.profileProgress, 0), 100);
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

  handleViewAll() {
    const currentURL = window.location.href;
    const newURL = currentURL + "my-jobs";
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: newURL
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
}
