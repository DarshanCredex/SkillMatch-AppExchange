import { LightningElement, wire } from "lwc";
import GetApplicantDataMethod from "@salesforce/apex/GetApplicantData.GetApplicantDataMethod";
import GetWorkExperienceData from "@salesforce/apex/GetApplicantData.GetWorkExperienceData";

export default class ApplicantProfile extends LightningElement {
  applicantId = sessionStorage.getItem("candidateid");
  applicantDetails = [];
  workExpDetails = [];
  skills;

  @wire(GetApplicantDataMethod, { applicantId: "$applicantId" })
  wiredGetApplicantDataMethod({ error, data }) {
    if (error) {
      console.log("error------->", error);
    }
    if (data) {
      this.applicantDetails = data;
      console.log("this.applicantDetails", this.applicantDetails);

      if (this.applicantDetails && this.applicantDetails.Skills__c) {
        this.skills = [...this.applicantDetails.Skills__c.split(",")];
        console.log("this.skills", this.skills);
      }
    }
  }

  @wire(GetWorkExperienceData, { applicantId: "$applicantId" })
  wiredGetWorkExperienceData({ error, data }) {
    if (error) {
      console.log("error--->", error);
    }
    if (data) {
      this.workExpDetails = data;
      console.log("this.workExpDetails", this.workExpDetails);
    }
  }
}
