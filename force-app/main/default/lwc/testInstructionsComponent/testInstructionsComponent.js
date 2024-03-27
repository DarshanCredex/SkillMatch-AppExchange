import { LightningElement, wire } from "lwc";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";

export default class TestInstructionsComponent extends LightningElement {
  testTiming;
  jobId;

  connectedCallback() {
    this.jobId = sessionStorage.getItem("jobId");
    console.log("this.jobId---->", this.jobId);
  }

  @wire(getTestTimings, { jobId: "$jobId" })
  wiredGetTestTimings({ data, error }) {
    if (data) {
      this.testTiming = data;
      console.log("this.testTiming->", this.testTiming);
    } else {
      const err = error;
      console.error(err);
    }
  }
}
