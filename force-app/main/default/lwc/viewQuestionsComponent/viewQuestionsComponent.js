import { LightningElement, wire } from "lwc";
import fetchQuestions from "@salesforce/apex/QuestionsController.fetchQuestions";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import emptyBox from "@salesforce/resourceUrl/empty_box";

export default class ViewQuestionsComponent extends LightningElement {
  questionsList = [];
  jobId;
  error;
  wiredResult;
  showEditQuestionsModal = false;
  showEditOptionModal = false;
  showQuestionsList = false;
  recordId;
  optionId;
  emptyBox = emptyBox;

  connectedCallback() {
    if (sessionStorage.getItem("postedJobId")) {
      this.jobId = sessionStorage.getItem("postedJobId");
    }
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
