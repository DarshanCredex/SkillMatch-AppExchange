import { LightningElement } from "lwc";
import experienceFieldValues from "@salesforce/apex/JobPicklistController.experienceFieldValues";
import typePickListValues from "@salesforce/apex/JobPicklistController.typePickListValues";
import IndustryPickListValues from "@salesforce/apex/JobPicklistController.IndustryPickListValues";
import postJob from "@salesforce/apex/jobObjectController.postJob";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";
import getCompanyName from "@salesforce/apex/jobObjectController.getCompanyName";

export default class AddJobsPage extends NavigationMixin(LightningElement) {
  experienceValues = [];
  industryValues = [];
  typeValues = [];

  jobTitle = "";
  summary = "";
  description = "";
  salaryRange = "";
  country = "";
  city = "";
  experienceValue = "";
  typeValue = "";
  industryValue = "";
  timingValue = "";
  skills = "";
  userCompanyName;
  userId = Id;

  showQuestionModal = false;

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
    TimingsPickListValues().then((result) => {
      this.timingValues = result;
    });
    getCompanyName({ userId: this.userId }).then((result) => {
      this.userCompanyName = result;
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

  handleTimingChange(event) {
    this.timingValue = event.target.value;
    console.log("this.timingValue", this.timingValue);
  }

  getInput() {
    this.jobTitle = this.template.querySelector(
      'lightning-input[data-id="jobTitle"]'
    );
    this.summary = this.template.querySelector(
      'lightning-input[data-id="summary"]'
    );
    this.description = this.template.querySelector(
      'lightning-input[data-id="description"]'
    );
    this.salaryRange = this.template.querySelector(
      'lightning-input[data-id="salaryRange"]'
    );
    this.city = this.template.querySelector('lightning-input[data-id="city"]');
    this.country = this.template.querySelector(
      'lightning-input[data-id="country"]'
    );
    this.skills = this.emplate.querySelector(
      'lightning-input[data-id="skills"]'
    );
  }

  postJobData(event) {
    this.getInput();
    const value = event.target.value;
    postJob({
      value: value,
      jobTitle: this.jobTitle,
      description: this.description,
      salaryRange: this.salaryRange,
      companyName: this.userCompanyName,
      city: this.city,
      country: this.country,
      experienceValue: this.experienceValue,
      typeValue: this.typeValue,
      industryValue: this.industryValue,
      summary: this.summary,
      skills: this.skills,
      timing: this.timingValue
    })
      .then(() => {
        console.log("true");
        if (value === "Completed") {
          this.showToast("Success", "Job posted successfully", "success");
        } else if (value === "Draft") {
          this.showToast("Success", "Draft Saved successfully", "success");
        }

        const pageReference = {
          type: "standard__webPage",
          attributes: {
            url: "/manage-jobs"
          }
        };
        this[NavigationMixin.Navigate](pageReference);
      })
      .catch((error) => {
        console.error("Error saving job:", error);
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

  handleAddQuestion() {
    this.showQuestionModal = true;
  }
  handleClose() {
    this.showQuestionModal = false;
  }
}
