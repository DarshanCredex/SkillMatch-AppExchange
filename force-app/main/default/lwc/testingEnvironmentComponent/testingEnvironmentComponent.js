/* eslint-disable consistent-return */
/* eslint-disable no-alert */
/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, wire, track } from "lwc";
import fetchQuestions from "@salesforce/apex/testingEnvironmentController.fetchQuestions";
import getTestTimings from "@salesforce/apex/testingEnvironmentController.getTestTimings";
import Id from "@salesforce/user/Id";
import getObjectiveResponse from "@salesforce/apex/testingEnvironmentController.getObjectiveResponse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSubjectiveResponse from "@salesforce/apex/testingEnvironmentController.getSubjectiveResponse";

export default class TestingEnvironmentComponent extends LightningElement {
  @track questionList = [];
  @track objectiveList = [];
  @track subjectiveList = [];
  @track selectedOptions = [];
  @track timeRemaining;

  subjectiveResponseAndId = {};

  userId = Id;
  jobid;
  tabSwitchCount = 0;
  myVal = "";
  success;
  error;

  showSubjective = false;
  showObjective = true;
  emptySubjective = false;
  emptyObjective = false;
  showWarningModal = false;
  showFinalScreen = false;
  showMain = true;

  timerTimeout;

  constructor() {
    super();
    window.addEventListener("visibilitychange", () => {
      if (document.visibilityState === "hidden") {
        if (this.tabSwitchCount < 2) {
          alert(
            "WARNING!!! \nYOU CANNOT SWITCH TABS ELSE YOU WILL BE DEBARRED"
          );
        }
        this.tabSwitchCount++;
        if (this.tabSwitchCount >= 2) {
          this.getResponse();
          alert(
            "You switched tabs more than twice \nYour test is over and response has been recorded"
          );
        }
      }
    });

    this.template.addEventListener("contextmenu", (event) => {
      event.preventDefault();
      alert("Right click not allowed");
    });

    window.addEventListener("beforeunload", (event) => {
      event.preventDefault();
      event.returnValue = "Do not reload";
    });

    document.addEventListener(
      "copy",
      (event) => {
        event.clipboardData.setData("text/plain", "*pasting is prevented*");
        alert("copying/pasting is not allowed");
        event.preventDefault();
      },
      false
    );

    window.addEventListener("keyup", (event) => {
      if (
        event.key === "F12" ||
        event.key === "F11" ||
        event.key === "F10" ||
        event.key === "F9" ||
        event.key === "F8" ||
        event.key === "F7" ||
        event.key === "F6" ||
        event.key === "F5" ||
        event.key === "F4" ||
        event.key === "F3" ||
        event.key === "F2" ||
        event.key === "F1"
      ) {
        alert("FUNCTION KEYS DISABLED");
        return false;
      }
    });
  }

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
        this.getResponse();
        this.showFinalScreen = true;
        this.showMain = false;
      }
    }, 1000);
  }

  handleObjectiveOptionChange(event) {
    const questionId = event.target.dataset.id;
    this.selectedOptions.push(questionId);
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
    const value = this.template.querySelector(
      "lightning-input-rich-text"
    ).value;
    this.myVal = value;
    const id = event.target.dataset.id;
    this.subjectiveResponseAndId[id] = this.myVal;
  }

  handleFinalSubmit() {
    this.getResponse();
  }

  getResponse() {
    getObjectiveResponse({
      optionId: this.selectedOptions,
      userId: this.userId,
      jobId: this.jobid
    })
      .then(() => {
        this.success = true;
      })
      .catch((error) => {
        this.error = error;
      });

    getSubjectiveResponse({
      userid: this.userId,
      subjectiveResponseAndId: this.subjectiveResponseAndId
    })
      .then(() => {
        this.showToast(
          "Assessment Over",
          "Your Response has been recorded",
          "success"
        );
        this.showFinalScreen = true;
        this.showWarningModal = false;
        this.showSubjective = false;
        this.showObjective = false;
        this.showMain = false;
      })
      .catch((error) => {
        this.error = error;
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
