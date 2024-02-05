import { LightningElement, track } from "lwc";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";
import fetchJobDetails from "@salesforce/apex/JobApplicantController.fetchJobDetails";
import emptyBox from "@salesforce/resourceUrl/empty_box";
export default class ApplicantListPage extends LightningElement {
  @track candidateDetails = [];
  @track jobDetails = [];
  jobId;
  subscription = null;
  candiateListIsEmpty = false;
  emptyBox = emptyBox;

  connectedCallback() {
    if (sessionStorage.getItem("id")) {
      this.jobId = sessionStorage.getItem("id");
    }
    this.fetchCandidateNames();
    this.fetchJobDetails();
  }

  fetchCandidateNames() {
    console.log("job id inside fucntion------>", this.jobId);
    fetchCandidateNames({ jobId: this.jobId }).then((data) => {
      this.candidateDetails = data;
      console.log("this.candidateDetails------->", this.candidateDetails);
      if (this.candidateDetails.length > 0) {
        this.candiateListIsEmpty = true;
        console.log(
          "this.candiateListIsEmpty------>",
          this.candiateListIsEmpty
        );
      }
      console.log(
        "this.candidateDetails--------->",
        JSON.stringify(this.candidateDetails)
      );
    });
  }
  fetchJobDetails() {
    fetchJobDetails({ jobId: this.jobId }).then((data) => {
      this.jobDetails = data;
      console.log("this.jobDetails------->", this.jobDetails);
    });
  }
}