import { LightningElement, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import UserNameFIELD from "@salesforce/schema/User.Name";
import Id from "@salesforce/user/Id";
import No_tasks from "@salesforce/resourceUrl/No_tasks";
import SkillMatch_Logo_White from "@salesforce/resourceUrl/skillMatch_logo";
import no_drafts from "@salesforce/resourceUrl/no_drafts";
import getTaskList from "@salesforce/apex/TaskController.getTaskList";
import getDraftJobList from "@salesforce/apex/jobObjectController.getDraftJobList";

export default class HrLandingPage extends LightningElement {
  @track currentUserName;
  @track taskList = [];
  @track draftJobList = [];
  image = No_tasks;
  no_drafts = no_drafts;
  Skillmatch_logo = SkillMatch_Logo_White;
  showPendingTasks = false;
  showDrafts = false;

  @wire(getRecord, { recordId: Id, fields: [UserNameFIELD] })
  currentUserInfo({ error, data }) {
    if (data) {
      this.currentUserName = data.fields.Name.value;
    } else if (error) {
      this.error = error;
    }
  }

  //
  connectedCallback() {
    getTaskList()
      .then((data) => {
        this.taskList = data;
        console.log("this.taskList-------->", this.taskList);
        this.showPendingTasks = true;
      })
      .catch((error) => {
        console.log("error------>", error);
      });
  }

  @wire(getDraftJobList)
  wiredgGetDraftJobList({ error, data }) {
    if (data) {
      console.log("data----->", data);
      this.draftJobList = data;
      console.log("this.draftJobList------>", this.draftJobList);
      this.showDrafts = true;
    } else if (error) {
      console.log("error------->", error);
    }
  }
}
