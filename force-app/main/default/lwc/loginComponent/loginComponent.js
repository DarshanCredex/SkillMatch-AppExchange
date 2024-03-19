import { LightningElement, track } from "lwc";
import skillMatch_logo from "@salesforce/resourceUrl/skillMatch_logo";
import loginLwcControllerMethod from "@salesforce/apex/loginLwcController.loginLwcControllerMethod";
import { NavigationMixin } from "lightning/navigation";

export default class CandidateLoginSetup extends NavigationMixin(
  LightningElement
) {
  @track email = "";
  @track password = "";
  skillMatchLogo = skillMatch_logo;
  emailInLocalStorage;
  authenticated;
  forgotPasswordUrl =
    "https://skillmatch-dev-ed.develop.my.site.com/Candidate/apex/ForgotPassword";
  hrPortalUrl =
    "https://skillmatch-dev-ed.develop.my.site.com/HR/apex/recruiterLoginPage";

  connectedCallback() {
    localStorage.clear();
  }

  handleEmailChange(event) {
    this.email = event.target.value;
  }

  handlePasswordChange(event) {
    this.password = event.target.value;
  }

  handleLogin() {
    loginLwcControllerMethod({
      email: this.email,
      password: this.password
    }).then((result) => {
      this.authenticated = result;

      if (this.authenticated === true) {
        const pageReference = {
          type: "standard__webPage",
          attributes: {
            url: "/"
          }
        };
        this[NavigationMixin.Navigate](pageReference);
        localStorage.setItem("emailId", this.email);
      }
    });
  }
  handleSignup() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/custom-sign-up"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }
}