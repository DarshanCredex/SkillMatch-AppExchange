/* eslint-disable no-alert */
/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, wire, track } from "lwc";
import fetchQuestions from "@salesforce/apex/testingEnvironmentController.fetchQuestions";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";
import Id from "@salesforce/user/Id";
import getObjectiveResponse from "@salesforce/apex/testingEnvironmentController.getObjectiveResponse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class TestingEnvironmentComponent extends LightningElement {
  @track questionList = [];
  @track objectiveList = [];
  @track subjectiveList = [];
  selectedOptions = [];
  selectedResponse = [];
  subjectiveResponseAndId = {};
  @track timeRemaining;
  userId = Id;

  jobid;
  myVal = "";

  showSubjective = false;
  showObjective = true;
  emptySubjective = false;
  emptyObjective = false;
  showWarningModal = false;

  timerTimeout;

  get timerDisplay() {
    const minutes = Math.floor(this.timeRemaining / 60);
    const seconds = this.timeRemaining % 60;
    return `Time Remaining: ${minutes} minutes ${seconds} seconds`;
  }

  connectedCallback() {
    this.jobid = sessionStorage.getItem("jobId");
    getTestTimings({ jobId: this.jobid })
      .then((result) => {
        if (result) {
          this.timeRemaining = result;
          this.startTimer();
        }
      })
      .catch((error) => {
        console.error("Error retrieving test timings:", error);
      });
  }

  @wire(fetchQuestions, { jobId: "$jobid" })
  wiredFetchQuestions({ data }) {
    if (data) {
      this.questionList = data;
      this.objectiveList = this.questionList.filter((item) => {
        return item.Type__c === "Objective";
      });
      if (this.objectiveList.length === 0) {
        this.emptyObjective = true;
      }
      this.subjectiveList = this.questionList.filter((item) => {
        return item.Type__c === "Subjective";
      });
      if (this.subjectiveList.length === 0) {
        this.emptySubjective = true;
      }
    }
  }

  startTimer() {
    if (this.timeRemaining) {
      const [minutes, unit] = this.timeRemaining.split(" ");
      if (unit === "mins") {
        this.timeRemaining = parseInt(minutes, 10) * 60;
      } else {
        console.error('Invalid time format. Expected format: "15 mins"');
        return;
      }
    } else {
      console.error("Time remaining not provided.");
      return;
    }

    this.timerTimeout = setInterval(() => {
      this.timeRemaining--;
      if (this.timeRemaining <= 0) {
        clearInterval(this.timerTimeout);
        alert("Time is up!");
      }
    }, 1000);
  }

  handleObjectiveOptionChange(event) {
    const questionId = event.target.dataset.id;
    this.selectedOptions.push(questionId);
    console.log(" this.selectedOptions", JSON.stringify(this.selectedOptions));
    console.log("userId", this.userId);
    console.log("jobid", this.jobid);
  }

  handleNext() {
    this.showWarningModal = true;
  }

  closeModal() {
    this.showWarningModal = false;
  }

  handleNextSubjective() {
    this.showWarningModal = false;
    this.showObjective = false;
    this.showSubjective = true;
  }

  handleSubjectiveChange(event) {
    console.log("inside changeeeeee");
    const value = this.template.querySelector(
      "lightning-input-rich-text"
    ).value;
    this.myVal = value;
    const id = event.target.dataset.id;
    this.subjectiveResponseAndId[id] = [this.myVal];
    console.log("this.subjectiveResponseAndId", JSON.stringify(this.subjectiveResponseAndId));
  }

  handleFinalSubmit() {
    console.log("subjective next");
    this.getResponse();
    this.showWarningModal = false;
    this.showSubjective = false;
    this.showObjective = false;
  }

  getResponse() {
    console.log("get response");
    getObjectiveResponse({
      optionId: this.selectedOptions,
      userId: this.userId,
      jobId: this.jobid
    })
      .then(() => {
        console.log("success");
        this.showToast(
          "Assessment Over",
          "Your Response has been recorded",
          "success"
        );
      })
      .catch((error) => {
        const err = error;
        console.log("error------->", err);
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
