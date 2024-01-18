import { LightningElement, wire, track } from "lwc";
import fetchAllCandidateDetails from "@salesforce/apex/FetchCandidateDetails.fetchAllCandidateDetails";
import fetchWorkExperience from "@salesforce/apex/FetchCandidateDetails.fetchWorkExperience";

export default class CandidateDetailsPage extends LightningElement {
  recordId;
  @track candidateDetails = [];
  @track workExperienceDetails = [];

  @wire(fetchAllCandidateDetails, { recordId: "a055h00001whMrvAAE" })
  wiredFetchCandidateData({ error, data }) {
    if (data) {
      this.candidateDetails = data[0];
      console.log("this.candidateDetails--------->", this.candidateDetails);
      console.log(
        "this.candidateDetails.name----->",
        this.candidateDetails.Name
      );
      console.log(
        "this.candidateDetails.Photo__c",
        this.candidateDetails.Photo__c
      );
      this.error = undefined;
    } else if (error) {
      console.log("error", error);
      this.candidateDetails = undefined;
    }
  }
  @wire(fetchWorkExperience, { recordId: "a055h00001whMrvAAE" })
  wiredFetchExperienceData({ error, data }) {
    if (data) {
        this.workExperienceDetails = data[0];
        console.log(
          "this.workExperienceDetails-------->",
          this.workExperienceDetails
        );
    } else if (error) {
      console.log("error----->", error);
    }
  }
}