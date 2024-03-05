import { LightningElement } from "lwc";

export default class EmbedVfpage extends LightningElement {
  recievedMessage;

  connectedCallback() {
    //window.addEventListener("message", this.handleResponse.bind(this), false);
    sessionStorage.setItem("uniqueValue", "abcdefg");
  }

  //   handleResponse(message) {
  //     if (message) {
  //       this.recievedMessage = message.data;
  //       console.log("this.recievedMessage-------->", this.recievedMessage);
  //     }
  //   }
}
