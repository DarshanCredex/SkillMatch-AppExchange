import { LightningElement, track, api } from "lwc";
import getPostedJobListBasedOnId from "@salesforce/apex/jobObjectController.getPostedJobListBasedOnId";
import { NavigationMixin } from "lightning/navigation";

export default class JobDescriptionPage extends NavigationMixin(
  LightningElement
) {
  @track jobDetails = [];
  jobId;
  isEditModalOpen = false;
  @api recordId;

  connectedCallback() {
    console.log(sessionStorage);
    if (sessionStorage.getItem("postedJobId")) {
      this.jobId = sessionStorage.getItem("postedJobId");
      console.log("this.jobId(reciever)", this.jobId);
    }
    this.getPostedJobListBasedOnIdMethod();
  }

  getPostedJobListBasedOnIdMethod() {
    getPostedJobListBasedOnId({ jobId: this.jobId })
      .then((data) => {
        this.jobDetails = data;
        console.log("this.jobDetails------->", JSON.stringify(this.jobDetails));
      })
      .catch((error) => {
        console.error("Error fetching job details: ", error);
      });
  }

  handleApplicantButton() {
    console.log("session storage", sessionStorage);
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/applicant-list-page"
      }
    };
    sessionStorage.setItem("uniquejobId", this.jobId);
    this[NavigationMixin.Navigate](pageReference);
  }
  handleEditButton() {
    this.isEditModalOpen = true;
  }
  closeModal() {
    this.isEditModalOpen = false;
  }
  
}
