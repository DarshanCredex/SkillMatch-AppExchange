/* eslint-disable no-alert */
import { LightningElement } from "lwc";
import skillMatch_logo from "@salesforce/resourceUrl/skillMatch_logo";
import candidateResgisterMethod from "@salesforce/apex/registerCandidateController.candidateResgisterMethod";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SignupComponent extends NavigationMixin(LightningElement) {
  firstName = "";
  lastName = "";
  email = "";
  password = "";
  confirmPassword = "";
  skillMatchLogo = skillMatch_logo;

  handleFirstNameChange(event) {
    this.firstName = event.target.value;
  }

  handleLastNameChange(event) {
    this.lastName = event.target.value;
  }

  handleEmailChange(event) {
    this.email = event.target.value;
  }

  handlePasswordChange(event) {
    this.password = event.target.value;
  }

  handleConfirmPasswordChange(event) {
    this.confirmPassword = event.target.value;
  }

  registerUser() {
    if (this.password === this.confirmPassword) {
      candidateResgisterMethod({
        firstName: this.firstName,
        lastName: this.lastName,
        email: this.email,
        password: this.password
      });
      this.showToast("Success", "Registered successfully", "success");
      const pageReference = {
        type: "standard__webPage",
        attributes: {
          url: "/custom-login"
        }
      };
      this[NavigationMixin.Navigate](pageReference);
    } else if (this.password !== this.confirmPassword) {
      alert("Passwords do not match");
    }
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