import { LightningElement, track, wire } from "lwc";
import UserNameFIELD from "@salesforce/schema/User.Name";
import Id from "@salesforce/user/Id";
import { getRecord } from "lightning/uiRecordApi";

export default class HrLandingPage extends LightningElement {
  @track currentUserName;
  currentDate = new Date().toDateString();

  @wire(getRecord, {
    recordId: Id,
    fields: [UserNameFIELD]
  })
  currentUserInfo({ error, data }) {
    if (data) {
      this.currentUserName = data.fields.Name.value;
      console.log("this.currentUserName-------->", this.currentUserName);
    } else if (error) {
      this.error = error;
      console.log("this.error", this.error);
    }
  }
}
