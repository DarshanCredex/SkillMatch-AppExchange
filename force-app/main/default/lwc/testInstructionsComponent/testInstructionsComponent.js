/* eslint-disable no-unused-vars */
import { LightningElement, wire } from "lwc";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";
import { NavigationMixin } from "lightning/navigation";

export default class TestInstructionsComponent extends NavigationMixin(
  LightningElement
) {
  testTiming;
  jobId;
  disableButton = false;

  connectedCallback() {
    this.jobId = sessionStorage.getItem("jobId");
    getTestTimings({ jobId: this.jobId }).then((result) => {
      if (result) {
        this.testTiming = result;
      }
    });
  }

  handleStartTest() {
    sessionStorage.setItem("jobId", this.jobId);
    const currentURl = window.location.href;
    const newUrl = currentURl.replace(
      "/test-instructions",
      "/testing-environment"
    );

    this[NavigationMixin.GenerateUrl]({
      type: "standard__webPage",
      attributes: {
        url: currentURl
      }
    }).then(() => {
      window.open(newUrl);
    });

  }
}
