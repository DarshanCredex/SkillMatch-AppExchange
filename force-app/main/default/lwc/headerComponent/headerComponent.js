import { LightningElement } from "lwc";
import skillMatch_logo from "@salesforce/resourceUrl/skillMatch_logo";
import { NavigationMixin } from "lightning/navigation";

export default class HeaderComponent extends NavigationMixin(LightningElement) {
  skillMatch_logo = skillMatch_logo;

  myjobs = false;
  jobs = false;
  home = true;

  navigateToJobs() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/job-list"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
     this.home = false;
     this.myjobs = false;
     this.jobs = true;
  }

  navigateToHome() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
    this.home = true;
    this.myjobs = false;
    this.jobs = false;
  }
  navigateToMyJobs() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/my-jobs"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
     this.home =false;
     this.myjobs = true;
     this.jobs = false;
  }
}
