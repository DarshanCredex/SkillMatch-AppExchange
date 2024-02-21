import { LightningElement, track, api, wire } from "lwc";
import getPostedJobListBasedOnId from "@salesforce/apex/jobObjectController.getPostedJobListBasedOnId";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";


export default class JobDescriptionPage extends NavigationMixin(
  LightningElement
) {
  @track jobDetails;
  @track error;
  jobId;
  isEditModalOpen = false;
  @api recordId;
  wiredResult;

  @track showApplicantsButton = false;

  connectedCallback() {
    console.log(sessionStorage);
    if (sessionStorage.getItem("postedJobId")) {
      this.jobId = sessionStorage.getItem("postedJobId");
      console.log("this.jobId(reciever)", this.jobId);
      console.log("recordid----->", this.recordId);
    }
  }

  @wire(getPostedJobListBasedOnId, { jobId: "$jobId" })
  wiredGetPostedJobListBasedOnId(result) {
    this.wiredResult = result;
    if (result.error) {
      console.error("error----->", result.error);
      this.error = result.error;
      this.jobDetails = undefined;
    } else if (result.data) {
      this.error = undefined;
      this.jobDetails = result.data;
      console.log("this.jobDetails-------->", this.jobDetails);
      this.updateShowApplicantsButton();
    }
  }

  updateShowApplicantsButton() {
    this.showApplicantsButton = this.jobDetails.some(
      (item) => item.Status__c === "Completed"
    );
  }

  handleApplicantButton() {
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

  handleSave() {
    console.log("inside save");
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  handleSuccess() {
    return refreshApex(this.wiredResult)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Updated Successfully",
            variant: "success"
          })
        );
        this.isEditModalOpen = false;
      })
      .catch((error) => {
        console.error("Error refreshing Apex:", error);
        this.error = error;
      });
  }
}
