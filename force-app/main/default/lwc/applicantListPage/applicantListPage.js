import { LightningElement, track } from "lwc";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";
import fetchJobDetails from "@salesforce/apex/JobApplicantController.fetchJobDetails";
import emptyBox from "@salesforce/resourceUrl/empty_box";
import { NavigationMixin } from "lightning/navigation";
export default class ApplicantListPage extends NavigationMixin(
  LightningElement
) {
  @track candidateDetails = [];
  @track jobDetails = [];
  @track statusValues = [];
  @track pendingCandidates = [];
  @track acceptedCandidates = [];
  @track rejectedCandidates = [];

  candidateId;
  jobId;
  emptyBox = emptyBox;

  candiateListIsEmpty = false;

  IsAccepted = false;
  IsRejected = false;
  showAllCandidates = true;
  showAccepted = false;
  showPending = false;
  showRejected = false;

  connectedCallback() {
    if (sessionStorage.getItem("uniquejobId")) {
      this.jobId = sessionStorage.getItem("uniquejobId");
      console.log(" this.jobId(recivever)", this.jobId);
    }
    this.fetchCandidateNames();
    this.fetchJobDetails();
  }

  fetchCandidateNames() {
    fetchCandidateNames({ jobId: this.jobId }).then((data) => {
      this.candidateDetails = data;
      console.log(
        "this.candidateDetails------->",
        JSON.stringify(this.candidateDetails)
      );
      if (this.candidateDetails.length > 0) {
        this.candiateListIsEmpty = true;
      }
    });
  }

  fetchJobDetails() {
    fetchJobDetails({ jobId: this.jobId }).then((data) => {
      this.jobDetails = data;
    });
  }
  navigateToDetailsPage(event) {
    this.candidateId = event.currentTarget.dataset.candidateid;
    console.log("this.candidateId", this.candidateId);
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/applicant-details"
      }
    };

    sessionStorage.setItem("candidateid", this.candidateId);
    console.log("candidateid(sender)---->", this.candidateId);
    this[NavigationMixin.Navigate](pageReference);
  }

  filterPending() {
    this.pendingCandidates = this.candidateDetails.filter((item) => {
      return item.Status === "Pending";
    });
    this.showAllCandidates = false;
    this.showAccepted = false;
    this.showPending = true;
    this.showRejected = false;
  }

  filterAccepted() {
    this.acceptedCandidates = this.candidateDetails.filter((item) => {
      return item.Status === "Accepted";
    });
    this.showAllCandidates = false;
    this.showAccepted = true;
    this.showPending = false;
    this.showRejected = false;
  }

  filterRejected() {
    this.rejectedCandidates = this.candidateDetails.filter((item) => {
      return item.Status === "Rejected";
    });
    this.showAllCandidates = false;
    this.showAccepted = false;
    this.showPending = false;
    this.showRejected = true;
  }
  filterAll() {
    this.showAllCandidates = true;
    this.showAccepted = false;
    this.showPending = false;
    this.showRejected = false;
  }
}
