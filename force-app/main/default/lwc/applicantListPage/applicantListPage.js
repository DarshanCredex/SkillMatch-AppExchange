import { LightningElement, track } from "lwc";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";

export default class ApplicantListPage extends LightningElement {
  @track candidateDetails = [];
  jobId;
  subscription = null;

  connectedCallback() {
    if (sessionStorage.getItem("id")) {
      this.jobId = sessionStorage.getItem("id");
      console.log("session storage id------>", this.jobId);

      sessionStorage.clear();
    }
  }
  // @wire(fetchCandidateNames, { jobId: this.jobId })
  // wiredFetchCandidateDetails({ error, data }) {
  //   if (data) {
  //     this.candidateDetails = data;
  //     console.log("this.candidateDetails--------->", JSON.stringify(this.candidateDetails));
  //   } else if (error) {
  //     const errorCode = error;
  //     console.log("errorCode------>", errorCode);
  //   }
  // }

  renderedCallback() {
    fetchCandidateNames({ jobId: this.jobId }).then((data) => {
      this.candidateDetails = data;
      console.log("this.candidateDetails--------->", JSON.stringify(this.candidateDetails));
    });
  }
}