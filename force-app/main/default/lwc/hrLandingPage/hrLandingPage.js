import { LightningElement, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import UserNameFIELD from "@salesforce/schema/User.Name";
import Id from "@salesforce/user/Id";
import No_tasks from "@salesforce/resourceUrl/No_tasks";
import SkillMatch_Logo_White from "@salesforce/resourceUrl/skillMatch_logo";
import no_drafts from "@salesforce/resourceUrl/no_drafts";

export default class HrLandingPage extends LightningElement {
  @track currentUserName;
  image = No_tasks;
  no_drafts = no_drafts;
  Skillmatch_logo = SkillMatch_Logo_White;
  @wire(getRecord, { recordId: Id, fields: [UserNameFIELD] })
  currentUserInfo({ error, data }) {
    if (data) {
      this.currentUserName = data.fields.Name.value;
    } else if (error) {
      this.error = error;
    }
  }
}
