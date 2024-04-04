/* eslint-disable no-alert */
/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, wire, track } from "lwc";
import fetchQuestions from "@salesforce/apex/testingEnvironmentController.fetchQuestions";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";

export default class TestingEnvironmentComponent extends LightningElement {
  @track questionList = [];
  @track objectiveList = [];
  @track subjectiveList = [];
  selectedOptions = {};
  selectedResponse = [];
  selectedIdsubjective = {};
  @track timeRemaining;

  jobid;
  myVal = "";

  indexObjective = 0;

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
    console.log("this.objectiveList---->", this.objectiveList);
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
    const selectedOption = event.target.value;
    this.selectedOptions[questionId] = selectedOption;
    console.log("selected options------->", this.selectedOptions);
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
  handleSubjectiveNext() {
    this.showWarningModal = false;
    this.showSubjective = false;
    this.showObjective = false;
  }
  handleSubjectiveChange(event) {
    const value = this.template.querySelector(
      "lightning-input-rich-text"
    ).value;
    this.myVal = value;
    this.selectedResponse.push(this.myVal);
    const id = event.target.dataset.id;
    this.selectedIdsubjective.push(id);
  }
}
