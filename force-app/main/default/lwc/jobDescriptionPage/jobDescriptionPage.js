import { LightningElement, track, wire } from "lwc";
import getPostedJobListBasedOnId from "@salesforce/apex/jobObjectController.getPostedJobListBasedOnId";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import questionTypeValue from "@salesforce/apex/QuestionsController.questionTypeValue";
import insertQuestionAndOptions from "@salesforce/apex/QuestionsController.insertQuestionAndOptions";

export default class JobDescriptionPage extends NavigationMixin(
  LightningElement
) {
  @track jobDetails;
  @track error;
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
      console.log("this.jobId(reciever)", this.jobId);
    }
  }

  @wire(getPostedJobListBasedOnId, { jobId: "$jobId" })
  wiredGetPostedJobListBasedOnId(result) {
    this.wiredResult = result;
    if (result.error) {
      console.error("error----->", result.error);
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
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Updated Successfully",
            variant: "success"
          })
        );
        this.isEditModalOpen = false;
      })
      .catch((error) => {
        console.error("Error refreshing Apex:", error);
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
      console.error("error", error);
    }
  }

  handleQuestionName(event) {
    this.questionName = event.target.value;
  }
  handleWeightage(event) {
    this.weightage = event.target.value;
  }
  handleQuesType(event) {
    this.type = event.target.value;
  }
  handleNext() {
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
    this.showQuestion = true;
    this.showOptionsObjective = false;
    this.showOptionsSubjective = false;
  }

  handleOptionA(event) {
    this.optionA = event.target.value;
  }
  handleOptionB(event) {
    this.optionB = event.target.value;
  }
  handleOptionC(event) {
    this.optionC = event.target.value;
  }
  handleOptionD(event) {
    this.optionD = event.target.value;
  }
  handleCheckbox_2(event) {
    this.checkbox_2 = event.detail.checked;
  }
  handleCheckbox_1(event) {
    this.checkbox_1 = event.detail.checked;
  }
  handleCheckbox_3(event) {
    this.checkbox_3 = event.detail.checked;
  }
  handleCheckbox_4(event) {
    this.checkbox_4 = event.detail.checked;
  }
  handleAnswer(event) {
    this.answer = event.target.value;
  }

  handleSaveQuestionAnswers() {
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
        })
        .catch(() => {
          this.showToast("Error", "Questions could not be saved", "error");
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
}
