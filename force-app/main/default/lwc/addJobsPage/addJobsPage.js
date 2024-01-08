import { LightningElement } from "lwc";
import experienceFieldValues from "@salesforce/apex/JobPicklistController.experienceFieldValues";
import typePickListValues from "@salesforce/apex/JobPicklistController.typePickListValues";
import IndustryPickListValues from "@salesforce/apex/JobPicklistController.IndustryPickListValues";

export default class AddJobsPage extends LightningElement {
  experienceValues = [];
  industryValues = [];
  typeValues = [];

  connectedCallback() {
    
    experienceFieldValues().then((result) => {
      this.experienceValues = result;
      console.log(
        "this.experienceOptions ---------->",
        JSON.stringify(this.experienceOptions)
      );
    });

    typePickListValues().then((result) => {
      this.typeValues = result;
      console.log("this.typeValues", JSON.stringify(this.typeValues));
    });
    IndustryPickListValues().then((result) => {
      this.industryValues = result;
      // this.industryValues = this.industryValues.map((data) => {
      //   return { label: data, value: data };
      // });
      console.log("this.industryValues", JSON.stringify(this.industryValues));
    });
  }
}
