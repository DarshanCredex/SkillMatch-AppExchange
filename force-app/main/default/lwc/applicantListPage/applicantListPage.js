import { LightningElement, wire, track } from "lwc";
import { subscribe, MessageContext } from "lightning/messageService";
import MessageChannel from "@salesforce/messageChannel/messageChannels__c";
import fetchCandidateNames from "@salesforce/apex/JobApplicantController.fetchCandidateNames";

export default class ApplicantListPage extends LightningElement {
  @wire(MessageContext)
  messageContext;

  @track candidateDetails = [];
  jobId;
  subscription;

  connectedCallback() {
    this.handleSubscribe();
  }

  handleSubscribe() {
    this.subscription = subscribe(
      this.messageContext,
      MessageChannel,
      (message) => {
        let data = message;
        console.log("data--->", data);
        this.jobId = data.id;
        console.log("jobId subscribe--------->", this.jobId);
        
      }
    );
  }

  fetchCandidateDetails() {
    if (this.jobId) {
      fetchCandidateNames({ jobId: this.jobId })
        .then((result) => {
          this.candidateDetails = result;
          console.log(
            "this.candidateDetails-------->",
            JSON.stringify(this.candidateDetails)
          );
        })
        .catch((error) => {
          console.log("error----->", error);
        });
    }
  }
}

