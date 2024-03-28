import { LightningElement, track } from "lwc";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";
import fetchJobDetails from "@salesforce/apex/JobApplicantController.fetchJobDetails";
import emptyBox from "@salesforce/resourceUrl/empty_box";
import { NavigationMixin } from "lightning/navigation";

export default class ApplicantListPage extends NavigationMixin(
  LightningElement
) {
  candidateDetails = [];
  @track filteredCandidateDetails = [];
  jobDetails = [];

  candidateId;
  jobId;

  emptyBox = emptyBox;
  val;

  candiateListIsEmpty = false;
  filteredListIsEmpty = false;

  connectedCallback() {
    if (sessionStorage.getItem("uniquejobId")) {
      this.jobId = sessionStorage.getItem("uniquejobId");
    }
    this.fetchCandidateNames();
    this.fetchJobDetails();
  }

  fetchCandidateNames() {
    fetchCandidateNames({ jobId: this.jobId }).then((data) => {
      this.candidateDetails = data; // source of truth
      this.filteredCandidateDetails = this.candidateDetails;
      this.candiateListIsEmpty = this.filteredCandidateDetails.length === 0;
    });
  }

  fetchJobDetails() {
    fetchJobDetails({ jobId: this.jobId }).then((data) => {
      this.jobDetails = data;
    });
  }

  navigateToDetailsPage(event) {
    this.candidateId = event.currentTarget.dataset.candidateid;
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/applicant-details"
      }
    };

    sessionStorage.setItem("candidateid", this.candidateId);
    this[NavigationMixin.Navigate](pageReference);
  }

  filterCandidates(event) {
    const status = event.currentTarget.dataset.status;

    if (status !== "All") {
      this.filteredCandidateDetails = this.candidateDetails.filter((item) => {
        return item.Status === status;
      });
    } else {
      this.filteredCandidateDetails = this.candidateDetails;
    }
    this.filteredListIsEmpty = this.filteredCandidateDetails.length === 0;
  }

  getSliderValue(event) {
    const sliderValue = parseInt(event.target.value, 10);
    this.filteredCandidateDetails = this.candidateDetails.filter((item) => {
      return item.matchPercentage >= sliderValue;
    });
    this.filteredListIsEmpty = this.filteredCandidateDetails.length === 0;
  }
}
