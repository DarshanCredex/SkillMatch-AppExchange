import { LightningElement } from "lwc";
import experienceFieldValues from "@salesforce/apex/JobPicklistController.experienceFieldValues";
import typePickListValues from "@salesforce/apex/JobPicklistController.typePickListValues";
import IndustryPickListValues from "@salesforce/apex/JobPicklistController.IndustryPickListValues";
import jobObjectControllerMehtod from "@salesforce/apex/jobObjectController.jobObjectControllerMehtod";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import saveToDraft from "@salesforce/apex/jobObjectController.saveToDraft";

export default class AddJobsPage extends LightningElement {
  experienceValues = [];
  industryValues = [];
  typeValues = [];

  jobTitle;
  summary;
  description;
  salaryRange;
  companyName;
  country;
  city;
  experienceValue;
  typeValue;
  industryValue;

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
      console.log("this.industryValues", JSON.stringify(this.industryValues));
    });
  }
  
  handleExperienceChange(event) {
    this.experienceValue = event.target.value;
    console.log(" this.experienceValue----->", this.experienceValue);
  }

  handleTypeChange(event) {
    this.typeValue = event.target.value;
    console.log("this.typeValue----->", this.typeValue);
  }

  handleIndustryChange(event) {
    this.industryValue = event.target.value;
    console.log("this.industryValue0------->", this.industryValue);
  }

  handleJobTitleChange(event) {
    this.jobTitle = event.target.value;
    console.log("this.jobTitle ", this.jobTitle);
  }
  handleDescriptionChange(event) {
    this.description = event.target.value;
  }
  handleSalaryChange(event) {
    this.salaryRange = event.target.value;
  }
  handleCompanyName(event) {
    this.companyName = event.target.value;
  }
  handleCityChange(event) {
    this.city = event.target.value;
  }
  handleCountryChange(event) {
    this.country = event.target.value;
  }
  handleSummaryChange(event) {
    this.summary = event.target.value;
  }

  postJobData() {
    jobObjectControllerMehtod({
      jobTitle: this.jobTitle,
      description: this.description,
      salaryRange: this.salaryRange,
      companyName: this.companyName,
      city: this.city,
      country: this.country,
      experienceValue: this.experienceValue,
      typeValue: this.typeValue,
      industryValue: this.industryValue,
      summary: this.summary
    })
      .then(() => {
        console.log("true");
        this.showToast("Success", "Job posted successfully", "success");
      })
      .catch((error) => {
        console.error("Error posting job:", error);
        this.showToast(
          "Error",
          "Some Error occured, please try again",
          "error"
        );
      });
  }
  
  saveToDraft() {
    saveToDraft({
      jobTitle: this.jobTitle,
      description: this.description,
      salaryRange: this.salaryRange,
      companyName: this.companyName,
      city: this.city,
      country: this.country,
      experienceValue: this.experienceValue,
      typeValue: this.typeValue,
      industryValue: this.industryValue,
      summary: this.summary
    })
      .then(() => {
        console.log("true");
        this.showToast("Success", "Draft saved successfully", "success");
      })
      .catch((error) => {
        console.error("Error saving draft:", error);
        this.showToast(
          "Error",
          "Some Error occured, please try again",
          "error"
        );
      });
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
