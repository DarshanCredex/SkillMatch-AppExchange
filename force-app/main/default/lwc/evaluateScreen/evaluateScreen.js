import { LightningElement, track, wire } from "lwc";
import getResponsesAndQuestions from "@salesforce/apex/QuestionsController.getResponsesAndQuestions";
import updateScore from "@salesforce/apex/QuestionsController.updateScore";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class EvaluateScreen extends LightningElement {
  jobId;
  candidateId;
  subjectiveMarks;
  TotalSubjectiveMarks = [];
  objectiveMarks = 0;
  questionIdList = [];
  totalMarks = 0;
  subjectiveWeightage = 0;
  objectiveWeightage = 0;

  showSubjective = true;
  showObjective = false;
  showMarksSubjective = false;

  @track questionsList = [];
  @track subjectiveList = [];
  @track objectiveList = [];

  connectedCallback() {
    this.jobId = sessionStorage.getItem("uniquejobId");
    this.candidateId = sessionStorage.getItem("candidateId");
  }

  @wire(getResponsesAndQuestions, {
    jobId: "$jobId",
    candidateId: "$candidateId"
  })
  wiredGetResponsesAndQuestions({ data }) {
    if (data) {
      this.questionsList = data;
      const response = JSON.parse(data);
      this.subjectiveList = response.filter(
        (item) => item.type === "Subjective"
      );
      this.objectiveList = response.filter((item) => item.type === "Objective");
    }
    this.calculateWeightage();
    this.calculateObjectiveScore();
  }

  get SubjectiveKeyValuePairs() {
    let keyValuePairArray = [];
    this.subjectiveList.forEach((question) => {
      for (const [key, value] of Object.entries(question.actualResponse)) {
        keyValuePairArray.push({ key: key, value: value });
      }
    });
    return keyValuePairArray;
  }

  handleSubjectiveObjectiveChange(event) {
    const buttonValue = event.target.value;
    if (buttonValue === "Subjective") {
      this.showSubjective = true;
      this.showObjective = false;
    } else if (buttonValue === "Objective") {
      this.showObjective = true;
      this.showSubjective = false;
    }
  }

  get actualResponseArray() {
    return this.objectiveList.map((item) => ({
      questionId: item.questionId,
      question: item.question,
      candidateResponse: item.candidateResponse,
      actualResponse: Object.entries(item.actualResponse).map(
        ([key, value]) => ({ key, value })
      )
    }));
  }

  calculateObjectiveScore() {
    for (const data of this.objectiveList) {
      const candidateResponse = data.candidateResponse;
      const actualResponse = data.actualResponse;

      for (const [key, value] of Object.entries(actualResponse)) {
        if (value && candidateResponse === key) {
          this.objectiveMarks += parseInt(data.weightage, 10);
          break;
        }
      }
    }
  }
  handleSubjectiveMarks() {
    this.subjectiveMarks = parseInt(
      this.template.querySelector('lightning-input[data-id="marksid"]').value,
      10
    );
    this.TotalSubjectiveMarks.push(this.subjectiveMarks);
  }

  handleSubjectiveEvaluate() {
    this.TotalSubjectiveMarks.forEach((item) => {
      this.totalMarks += item;
    });
  }

  handleObjectiveEvaluate() {
    updateScore({
      score: this.objectiveMarks + this.subjectiveMarks,
      jobid: this.jobId,
      candidateid: this.candidateId
    }).then(() => {
      this.showToast("Success", "Score added to the database", "success");
    });
  }

  calculateWeightage() {
    this.subjectiveList.forEach((item) => {
      this.subjectiveWeightage += item.weightage;
    });
    this.objectiveList.forEach((item) => {
      this.objectiveWeightage += item.weightage;
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