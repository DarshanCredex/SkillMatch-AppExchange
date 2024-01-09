import { LightningElement } from "lwc";
import no_jobs from "@salesforce/resourceUrl/no_jobs";
import { NavigationMixin } from "lightning/navigation";

export default class ManageJobs extends NavigationMixin(LightningElement) {
  
  noJobs = no_jobs;

  handlePageReference() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/add-jobs"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }



}
