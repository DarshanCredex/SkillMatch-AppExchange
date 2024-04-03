/* eslint-disable no-alert */
import { LightningElement, wire, track } from "lwc";
import fetchQuestions from "@salesforce/apex/testingEnvironmentController.fetchQuestions";

export default class TestingEnvironmentComponent extends LightningElement {
  @track questionList = [];
  @track objectiveList = [];
  @track subjectiveList = [];

  jobid;

  indexObjective = 0;

  showSubjective = false;
  showObjective = true;
  emptySubjective = false;
  emptyObjective = false;

  connectedCallback() {
    this.jobid = sessionStorage.getItem("jobId");
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
      if (this.subjectiveList.lenth === 0) {
        this.emptySubjective = true;
      }
    }
  }

  handleQuestionType(event) {
    const buttonValue = event.target.value;
    if (buttonValue === "Objectives") {
      this.showObjective = true;
      this.showSubjective = false;
    } else if (buttonValue === "Subjectives") {
      this.showSubjective = true;
      this.showObjective = false;
    }
  }
}
