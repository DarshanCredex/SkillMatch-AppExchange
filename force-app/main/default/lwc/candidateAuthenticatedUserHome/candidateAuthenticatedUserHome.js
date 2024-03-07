import { LightningElement } from "lwc";
import StayMotivated from "@salesforce/resourceUrl/StayMotivated";
import StartCareer from "@salesforce/resourceUrl/StartCareer";
import AchieveDream from "@salesforce/resourceUrl/AchieveDream";

export default class CandidateAuthenticatedUserHome extends LightningElement {
  StayMotivated = StayMotivated;
  StartCareer = StartCareer;
  AchieveDream = AchieveDream;

  emailId;
  showToUser = false;

  connectedCallback() {
    this.emailId = localStorage.getItem("emailId");
    if (this.emailId !== null) {
      this.showToUser = true;
    }
  }
}
