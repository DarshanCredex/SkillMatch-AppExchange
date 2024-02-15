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
  candidateId;
  jobId;
  subscription = null;
  candiateListIsEmpty = false;
  emptyBox = emptyBox;
  requiredSkills = "";
  applicantSkills = "";
  matchPercentage;
  IsPending = false;
  IsAccepted = false;
  IsRejected = false;

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
  handleAcceptButton(event) {
    console.log("inside handleacceptbutton");
    const candidateId = event.target.value;
    console.log("candidateId", candidateId);
    this.candidateDetails = this.candidateDetails.forEach((candidate) => {
      if (candidate.Id === candidateId) {
        candidate.isAccepted = true;
      }
    });
  }
}
