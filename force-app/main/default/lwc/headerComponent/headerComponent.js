import { LightningElement } from "lwc";
import skillMatch_logo from "@salesforce/resourceUrl/skillMatch_logo";
import { NavigationMixin } from "lightning/navigation";

export default class HeaderComponent extends NavigationMixin(LightningElement) {
  emailId;
  skillMatch_logo = skillMatch_logo;
  showToUser = false;

  connectedCallback() {
    this.emailId = sessionStorage.getItem("emailId");
    if (this.emailId !== null) {
      this.showToUser = true;
    }
  }
  navigateToJobs() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/job-list"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }

  navigateToHome() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
  navigateToMyJobs() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/my-jobs"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }

  navigateToLogin() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/custom-login"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
}
