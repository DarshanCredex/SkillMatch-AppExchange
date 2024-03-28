import { LightningElement, track, wire } from "lwc";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";
import fetchJobDetails from "@salesforce/apex/JobApplicantController.fetchJobDetails";
import emptyBox from "@salesforce/resourceUrl/empty_box";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import changeStatus from "@salesforce/apex/JobApplicantController.changeStatus";
import { refreshApex } from "@salesforce/apex";

export default class ApplicantListPage extends NavigationMixin(
  LightningElement
) {
  candidateDetails = [];
  @track filteredCandidateDetails = [];
  jobDetails = [];
  allIdList = [];
  selectedIdList = [];
  wiredResult = [];

  candidateId;
  jobId;

  emptyBox = emptyBox;
  val;

  candiateListIsEmpty = false;
  filteredListIsEmpty = false;
  @track checkboxSelected = false;
  selectAllChecked = false;
  disableButtons = true;
  disableRejectedCheckbox = false;

  connectedCallback() {
    if (sessionStorage.getItem("uniquejobId")) {
      this.jobId = sessionStorage.getItem("uniquejobId");
    }
    this.fetchJobDetails();
  }

  @wire(fetchCandidateNames, { jobId: "$jobId" })
  wiredCandidates(result) {
    this.wiredResult = result;
    if (result.data) {
      this.candidateDetails = result.data;
      this.filteredCandidateDetails = result.data;
      this.candiateListIsEmpty = this.filteredCandidateDetails.length === 0;
      this.allIdList = this.filteredCandidateDetails.map(
        (candidate) => candidate.Id
      );
    }
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

  handleCheckBoxSelect(event) {
    const candidateId = event.target.dataset.checkboxid;
    var isChecked = false;
    isChecked = event.target.checked;

    if (isChecked) {
      this.selectedIdList.push(candidateId);
      if (this.allIdList.length === this.selectedIdList.length) {
        this.selectAllChecked = true;
      }
      this.disableButtons = false;
    } else {
      const index = this.selectedIdList.indexOf(candidateId);
      this.selectedIdList.splice(index, 1);
      this.selectAllChecked = false;
      if (this.selectedIdList.length === 0) {
        this.disableButtons = true;
      }
    }
  }

  handleSelectAll(event) {
    this.selectAllChecked = event.target.checked;
    console.log("select all checked value---->", this.selectAllChecked);
    if (this.selectAllChecked) {
      this.checkboxSelected = true;
      this.selectedIdList = this.filteredCandidateDetails.map(
        (candidate) => candidate.Id
      );
      this.disableButtons = false;
    } else {
      this.checkboxSelected = false;
      this.selectedIdList = [];
      this.disableButtons = true;
    }
  }
  handleShortlistReject(event) {
    const valueOfButton = event.target.value;
    changeStatus({
      value: valueOfButton,
      applicantId: this.selectedIdList
    })
      .then(() => {
        if (valueOfButton === "Accepted") {
          this.showToast(
            "Shorlisted",
            "Your selected applicants have been shortlisted",
            "success"
          );
        } else if (valueOfButton === "Rejected") {
          this.showToast(
            "Rejected",
            "Your selected applicants have been rejected",
            "error"
          );
        }
        refreshApex(this.wiredResult);
      })
      .catch(() => {
        this.showToast("Error", "Some Error occurred", "error");
      });
  }
  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
    );
  }
}
