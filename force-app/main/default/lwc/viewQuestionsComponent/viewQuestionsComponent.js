import { LightningElement, wire } from "lwc";
import fetchQuestions from "@salesforce/apex/QuestionsController.fetchQuestions";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import emptyBox from "@salesforce/resourceUrl/empty_box";
import getTestTimings from "@salesforce/apex/jobObjectController.getTestTimings";

export default class ViewQuestionsComponent extends LightningElement {
  questionsList = [];

  jobId;
  error;
  recordId;
  optionId;
  wiredResult;
  testTimings;

  showEditQuestionsModal = false;
  showEditOptionModal = false;
  showQuestionsList = false;

  emptyBox = emptyBox;

  connectedCallback() {
    if (sessionStorage.getItem("postedJobId")) {
      this.jobId = sessionStorage.getItem("postedJobId");
    }
    refreshApex(this.wiredResult);
  }

  @wire(fetchQuestions, { jobId: "$jobId" })
  wiredFetchQuestions(result) {
    this.wiredResult = result;
    if (result.data) {
      this.questionsList = result.data;
      if (this.questionsList.length > 0) {
        this.showQuestionsList = true;
      }
    } else if (result.error) {
      this.error = result.error;
    }
  }

  @wire(getTestTimings, { jobId: "$jobId" })
  wiredGetTestTimings(result) {
    if (result.data) {
      this.testTimings = result.data;
      console.log("this.testTimings----->", this.testTimings);
    }
  }
  handleEditQuestion(event) {
    this.showEditQuestionsModal = true;
    this.recordId = event.currentTarget.dataset.questionid;
  }
  closeModal() {
    this.showEditQuestionsModal = false;
    this.showEditOptionModal = false;
  }

  handleSuccess() {
    refreshApex(this.wiredResult);
    this.showToast("Success", "Updated Successfully", "success");
    this.showEditQuestionsModal = false;
    this.showEditOptionModal = false;
  }

  handleOptionEdit(event) {
    this.optionId = event.currentTarget.dataset.optionid;
    this.showEditOptionModal = true;
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
  handleSave() {
    this.template.querySelector("lightning-record-edit-form").submit();
  }
}
