import { LightningElement, wire } from "lwc";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";
import { NavigationMixin } from "lightning/navigation";
import getAssesmentStatus from "@salesforce/apex/testingEnvironmentController.getAssesmentStatus";
import Id from "@salesforce/user/Id";
import changeAssesmentStatus from "@salesforce/apex/testingEnvironmentController.changeAssesmentStatus";
import { refreshApex } from "@salesforce/apex";

export default class TestInstructionsComponent extends NavigationMixin(
  LightningElement
) {
  testTiming;
  jobId;
  disableButton = false;
  userId = Id;
  AssesmentStatusOfApplicant;

  connectedCallback() {
    this.jobId = sessionStorage.getItem("jobId");
    getTestTimings({ jobId: this.jobId }).then((result) => {
      if (result) {
        this.testTiming = result;
      }
    });
  }

  @wire(getAssesmentStatus, { userid: "$userId", jobid: "$jobId" })
  wiredGetAssesmentStatus(result) {
    this.AssesmentStatusOfApplicant = result;
    if (result.data) {
      const status = result.data;
      console.log("status------>", status);
      if (status === "Pending") {
        this.disableButton = false;
      } else {
        this.disableButton = true;
      }
    }
  }

  handleStartTest() {
    changeAssesmentStatus({ userId: this.userId, jobId: this.jobId })
      .then(() => {
        console.log("status changed");
        refreshApex(this.AssesmentStatusOfApplicant);
      })
      .catch((error) => {
        console.error("error-------->", error);
      });
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