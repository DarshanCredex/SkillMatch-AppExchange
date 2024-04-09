import { LightningElement, track, wire } from "lwc";
import getResponsesAndQuestions from "@salesforce/apex/QuestionsController.getResponsesAndQuestions";
import calculateObjectiveScore from "@salesforce/apex/QuestionsController.calculateObjectiveScore";
import updateScore from "@salesforce/apex/QuestionsController.updateScore";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class EvaluateScreen extends LightningElement {
  jobId;
  candidateId;
  subjectiveMarks;
  TotalSubjectiveMarks = [];
  objectiveMarks;
  questionIdList = [];
  totalMarks = 0;
  

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
  wiredGetResponsesAndQuestions({ error, data }) {
    if (data) {
      this.questionsList = data;
      const response = JSON.parse(data);
      this.subjectiveList = response.filter(
        (item) => item.type === "Subjective"
      );
      this.objectiveList = response.filter((item) => item.type === "Objective");
    } else {
      console.error("error fetching list----->", error);
    }
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
    this.objectiveList.forEach((item) => {
      this.questionIdList.push(item.questionId);
    });
    calculateObjectiveScore({ questionId: this.questionIdList }).then(
      (result) => {
        this.objectiveMarks = parseInt(result, 10);
      }
    );

    updateScore({
      score: this.objectiveMarks + this.subjectiveMarks,
      jobid: this.jobId,
      candidateid: this.candidateId
    }).then(() => {
      console.log("done");
      this.showToast("Success", "Score added to the database", "success");
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
