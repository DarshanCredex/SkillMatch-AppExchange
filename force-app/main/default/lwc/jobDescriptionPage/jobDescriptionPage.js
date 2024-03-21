import { LightningElement, track, wire } from "lwc";
import getPostedJobListBasedOnId from "@salesforce/apex/jobObjectController.getPostedJobListBasedOnId";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import questionTypeValue from "@salesforce/apex/QuestionsController.questionTypeValue";
import insertQuestionAndOptions from "@salesforce/apex/QuestionsController.insertQuestionAndOptions";
export default class JobDescriptionPage extends NavigationMixin(LightningElement) {
  jobDetails;
  error;
  jobId;
  isEditModalOpen = false;
  questionId;
  wiredResult;
  showAddQuestionsModal = false;
  showQuestion = true;
  showOptionsObjective = false;
  questionTypeValues = [];

  weightage;
  questionName;
  type;

  checkbox_1 = false;
  checkbox_2 = false;
  checkbox_3 = false;
  checkbox_4 = false;

  optionA = "";
  optionB = "";
  optionC = "";
  optionD = "";
  answer = "";

  @track showApplicantsButton = false;

  connectedCallback() {
    if (sessionStorage.getItem("postedJobId")) {
      this.jobId = sessionStorage.getItem("postedJobId");
    }
  }

  @wire(getPostedJobListBasedOnId, { jobId: "$jobId" })
  wiredGetPostedJobListBasedOnId(result) {
    this.wiredResult = result;
    if (result.error) {
      this.error = result.error;
      this.jobDetails = undefined;
    } else if (result.data) {
      this.error = undefined;
      this.jobDetails = result.data;
      this.updateShowApplicantsButton();
    }
  }

  updateShowApplicantsButton() {
    this.showApplicantsButton = this.jobDetails.some(
      (item) => item.Status__c === "Completed"
    );
  }

  handleApplicantButton() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/applicant-list-page"
      }
    };
    sessionStorage.setItem("uniquejobId", this.jobId);
    this[NavigationMixin.Navigate](pageReference);
  }

  handleEditButton() {
    this.isEditModalOpen = true;
  }

  closeModal() {
    this.isEditModalOpen = false;
  }

  handleSave() {
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  handleSuccess() {
    return refreshApex(this.wiredResult)
      .then(() => {
        this.showToast("Success", "Updated Successfully", "success");
        this.isEditModalOpen = false;
      })
      .catch((error) => {
        this.error = error;
      });
  }

  handleAddQuestionsModal() {
    this.showAddQuestionsModal = true;
    this.showQuestion = true;
    this.showOptionsObjective = false;

    this.weightage = "";
    this.questionName = "";
    this.optionA = "";
    this.optionB = "";
    this.optionC = "";
    this.optionD = "";
    this.answer = "";
  }

  handleQuesType(event) {
    this.type = event.target.value;
  }

  handleClose() {
    this.showAddQuestionsModal = false;
    this.showQuestion = false;
    this.showOptionsObjective = false;
    this.showOptionsSubjective = false;
  }

  @wire(questionTypeValue)
  wiredQuestionTypeValues({ data, error }) {
    if (data) {
      this.questionTypeValues = data;
    } else if (error) {
      this.error = error;
    }
  }

  getQuestionInput() {
    console.log("inside input");
    this.questionName = this.template.querySelector(
      'lightning-input[data-id="question-id"]'
    ).value;
    this.weightage = this.template.querySelector(
      'lightning-input[data-id="weightage-id"]'
    ).value;
  }
  getOptionsInput() {
    if (this.type === "Subjective") {
      this.answer = this.template.querySelector(
        'lightning-input[data-id="answer-id"]'
      ).value;
    } else if (this.type === "Objective") {
      this.optionA = this.template.querySelector(
        'lightning-input[data-id="optionA-id"]'
      ).value;
      this.optionB = this.template.querySelector(
        'lightning-input[data-id="optionB-id"]'
      ).value;
      this.optionC = this.template.querySelector(
        'lightning-input[data-id="optionC-id"]'
      ).value;
      this.optionD = this.template.querySelector(
        'lightning-input[data-id="optionD-id"]'
      ).value;
      this.checkbox_1 = this.template.querySelector(
        'lightning-input[data-id="checkboxA"]'
      ).checked;
      this.checkbox_2 = this.template.querySelector(
        'lightning-input[data-id="checkboxB"]'
      ).checked;
      this.checkbox_3 = this.template.querySelector(
        'lightning-input[data-id="checkboxC"]'
      ).checked;
      this.checkbox_4 = this.template.querySelector(
        'lightning-input[data-id="checkboxD"]'
      ).checked;
    }
  }


  handleNext() {
    this.getQuestionInput();

    this.showQuestion = false;
    if (this.type === "Objective") {
      this.showOptionsObjective = true;
    } else if (this.type === "Subjective") {
      this.showOptionsSubjective = true;
    } else {
      this.showQuestion = true;
      this.showToast("Error", "Select Type", "error");
    }
  }

  handlePrevious() {
    this.getOptionsInput();
    this.showQuestion = true;
    this.showOptionsObjective = false;
    this.showOptionsSubjective = false;
  }

  handleSaveQuestionAnswers() {
    this.getOptionsInput();
    if (!this.questionName || !this.type) {
      this.showToast("Error", "Fields cannot be empty", "error");
    } else {
      insertQuestionAndOptions({
        questionName: this.questionName,
        weightage: this.weightage,
        type: this.type,
        optionA: this.optionA,
        optionB: this.optionB,
        optionC: this.optionC,
        optionD: this.optionD,
        checkbox_1: this.checkbox_1,
        checkbox_2: this.checkbox_2,
        checkbox_3: this.checkbox_3,
        checkbox_4: this.checkbox_4,
        jobId: this.jobId,
        answer: this.answer
      })
        .then(() => {
          this.showToast("Success", "Questions saved successfully", "success");
          this.showAddQuestionsModal = false;
          this.showQuestion = false;
          this.showOptionsObjective = false;
          this.showOptionsSubjective = false;
        })
        .catch((error) => {
          this.showToast("Error", "Questions could not be saved", "error");
          console.error("error---->", error);
        });
    }
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

  handleViewQuestions() {
    const pageReference = {
      type: "standard__webPage",
      attributes: {
        url: "/view-questions"
      }
    };
    this[NavigationMixin.Navigate](pageReference);
  }

  handleViewQuestions() {
    
  }
}
