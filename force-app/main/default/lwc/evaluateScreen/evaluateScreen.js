import { LightningElement, track, wire } from "lwc";
import getResponsesAndQuestions from "@salesforce/apex/QuestionsController.getResponsesAndQuestions";

export default class EvaluateScreen extends LightningElement {
  jobId;
  candidateId;

  showSubjective = true;
  showObjective = false;
  
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
}
