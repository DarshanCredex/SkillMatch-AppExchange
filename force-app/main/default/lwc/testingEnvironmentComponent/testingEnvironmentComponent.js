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
import getFeedbackFromCandidate from "@salesforce/apex/testingEnvironmentController.getFeedbackFromCandidate";

export default class TestingEnvironmentComponent extends LightningElement {
  @track questionList = [];
  @track objectiveList = [];
  @track subjectiveList = [];
  @track selectedOptions = [];
  @track timeRemaining;

  subjectiveResponseAndId = {};

  userId = Id;
  tabSwitchCount = 0;
  progress = 100;
  myVal = "";
  feedback = "";

  jobid;
  success;
  error;
  progressPercentage;
  timerTimeout;

  showSubjective = false;
  showObjective = true;
  emptySubjective = false;
  emptyObjective = false;
  showWarningModal = false;
  showFinalScreen = false;
  showMain = true;

  constructor() {
    super();
    this.visibilityChangeListener = this.visibilityChangeListener.bind(this);
    this.contextMenuListener = this.contextMenuListener.bind(this);
    this.beforeUnloadListener = this.beforeUnloadListener.bind(this);
    this.copyListener = this.copyListener.bind(this);
    this.keyupListener = this.keyupListener.bind(this);

    window.addEventListener("visibilitychange", this.visibilityChangeListener);
    this.template.addEventListener("contextmenu", this.contextMenuListener);
    window.addEventListener("beforeunload", this.beforeUnloadListener);
    document.addEventListener("copy", this.copyListener, false);
    window.addEventListener("keyup", this.keyupListener);
  }

  visibilityChangeListener() {
    if (document.visibilityState === "hidden") {
      if (this.tabSwitchCount < 2) {
        alert(
          "WARNING!!! \nDo not switch tabs otherwise paper will be submitted after two times"
        );
      }
      this.tabSwitchCount++;
      if (this.tabSwitchCount >= 2) {
        this.getResponse();
        alert(
          "You switched tabs more than twice \nYour test is over and response has been recorded"
        );
        window.removeEventListener(
          "visibilitychange",
          this.visibilityChangeListener
        );
      }
    }
  }

  contextMenuListener(event) {
    event.preventDefault();
    alert("No right click allowed");
  }

  beforeUnloadListener(event) {
    event.preventDefault();
    alert("Do not reload");
    if (!this.showFinalScreen) {
      this.getResponse();
    }
  }

  copyListener(event) {
    event.clipboardData.setData("text/plain", "*pasting is prevented*");
    alert("Do not copy paste");
    event.preventDefault();
  }

  keyupListener(event) {
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
      alert("Cannot use function keys");
      return false;
    }
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
        return;
      }
    } else {
      return;
    }
    const timeInitial = this.timeRemaining;
    this.timerTimeout = setInterval(() => {
      this.timeRemaining--;
      if (this.timeRemaining <= 0) {
        console.log("time remaining", this.timeRemaining);
        clearInterval(this.timerTimeout);
        alert("Time is up!");
        this.getResponse();
        this.showFinalScreen = true;
        this.showMain = false;
      } else {
        this.progress =
          100 - ((timeInitial - this.timeRemaining) / timeInitial) * 100;
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
        this.removeEventListeners();
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

  removeEventListeners() {
    window.removeEventListener(
      "visibilitychange",
      this.visibilityChangeListener
    );
    this.template.removeEventListener("contextmenu", this.contextMenuListener);
    document.removeEventListener("copy", this.copyListener, false);
    window.removeEventListener("keyup", this.keyupListener);
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

  getFeedback(event) {
    this.feedback = event.target.value;
    console.log("this.feedback------>", this.feedback);
  }

  handleFeedbackSubmit() {
    getFeedbackFromCandidate({
      feedback: this.feedback,
      userId: this.userId,
      jobId: this.jobId
    }).then(() => {
      this.showToast(
        "Feeback Recorded",
        "Your Feedback has been saved",
        "success"
      );
    });
  }
}