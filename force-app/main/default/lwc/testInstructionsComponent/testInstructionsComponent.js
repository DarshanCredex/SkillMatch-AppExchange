import { LightningElement } from "lwc";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";
import { NavigationMixin } from "lightning/navigation";
import getAssesmentStatus from "@salesforce/apex/testingEnvironmentController.getAssesmentStatus";
import Id from "@salesforce/user/Id";
import changeAssesmentStatus from "@salesforce/apex/testingEnvironmentController.changeAssesmentStatus";

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
    getAssesmentStatus({ userid: this.userId, jobid: this.jobId })
      .then((result) => {
        const status = result;
        console.log("status------>", status);
        if (status === "Pending") {
          this.disableButton = false;
        } else {
          this.disableButton = true;
        }
      })
      .catch((error) => {
        console.error("error------>", error);
      });
  }
  handleStartTest() {

    changeAssesmentStatus({ userid: this.userId, jobid: this.jobId })
      .then(() => {
        console.log("status changed");
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
