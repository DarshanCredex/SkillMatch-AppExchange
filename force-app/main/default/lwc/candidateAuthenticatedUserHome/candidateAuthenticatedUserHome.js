import { LightningElement, api } from "lwc";
import StayMotivated from "@salesforce/resourceUrl/StayMotivated";
import StartCareer from "@salesforce/resourceUrl/StartCareer";
import AchieveDream from "@salesforce/resourceUrl/AchieveDream";

export default class CandidateAuthenticatedUserHome extends LightningElement {
    StayMotivated = StayMotivated;
  StartCareer = StartCareer;
  AchieveDream = AchieveDream;
}