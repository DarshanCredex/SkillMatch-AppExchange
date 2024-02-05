import { LightningElement, wire, track } from "lwc";
import Id from "@salesforce/user/Id";
import { getRecord } from "lightning/uiRecordApi";
import getDraftJobList from "@salesforce/apex/jobObjectController.getDraftJobList";
import chartjs from "@salesforce/resourceUrl/chartjs";
import { loadScript } from "lightning/platformResourceLoader";
import getApplicantDataset from "@salesforce/apex/JobApplicantController.getApplicantDataset";
import getApplicantsList from "@salesforce/apex/JobApplicantController.getApplicantsList";
import getNumberOfApplicants from "@salesforce/apex/JobApplicantController.getNumberOfApplicants";
import getNumberOfJobsPosted from "@salesforce/apex/JobApplicantController.getNumberOfJobsPosted";

export default class HrLandingPage extends LightningElement {
  @track currentUserName;
  @track draftJobList = [];
  @track applicantChartDataset = [];
  @track applicantsList = [];

  numberOfApplicants;
  numberOfJobsPosted;
  chart;
  chartjsInitialized = false;

  config = {
    type: "doughnut",
    data: {
      datasets: [
        {
          data: [],
          backgroundColor: [
            "rgb(255,99,132)",
            "rgb(255,159,64)",
            "rgb(255,205,86)",
            "rgb(75,192,192)",
            "rgb(153,102,204)",
            "rgb(179,158,181)",
            "rgb(188,152,126)",
            "rgb(123,104,238)",
            "rgb(119,221,119)"
          ],
          label: "Applicants Dataset"
        }
      ],
      labels: []
    },
    options: {
      responsive: true,
      title: "Applicants - Cities",

      maintainAspectRatio: false,
      legend: {
        position: "left"
      },
      animation: {
        animateScale: true,
        animateRotate: true
      }
    }
  };

  @wire(getRecord, {
    recordId: Id,
    fields: ["User.Name"]
  })
  currentUserInfo({ error, data }) {
    if (data) {
      this.currentUserName = data.fields.Name.value;
    } else if (error) {
      console.error("Error fetching user data", error);
    }
  }
  @wire(getApplicantsList)
  wiredGetApplicantsList({ error, data }) {
    if (data) {
      this.applicantsList = data;
    } else {
      console.log("error------->", error);
    }
  }
  @wire(getDraftJobList)
  wiredGetDraftJobList({ error, data }) {
    if (data) {
      this.draftJobList = data;
      this.showDrafts = true;
    } else if (error) {
      console.error("Error fetching draft job list", error);
    }
  }

  @wire(getApplicantDataset)
  applicants({ error, data }) {
    if (data) {
      this.applicantChartDataset = data;

      this.updateChart();

      if (!this.chartjsInitialized) {
        this.chartjsInitialized = true;
        loadScript(this, chartjs).then(() => {
          const ctx = this.template
            .querySelector("canvas.donut")
            .getContext("2d");
          this.chart = new window.Chart(ctx, this.config);
        });
      }
    } else {
      console.error("Error fetching applicant data", error);
    }
  }

  @wire(getNumberOfApplicants)
  wiredGetNumebrOfApplicants({ error, data }) {
    if (data) {
      this.numberOfApplicants = data;
    } else {
      console.log("error--------->", error);
    }
  }

  @wire(getNumberOfJobsPosted)
  wiredJobsPosted({ error, data }) {
    if (data) {
      this.numberOfJobsPosted = data;
    } else {
      console.log("error-------->", error);
    }
  }

  updateChart() {
    this.config.data.labels = [];
    this.config.data.datasets[0].data = [];
    this.applicantChartDataset.forEach((applicant) => {
      this.config.data.labels.push(applicant.label);
      this.config.data.datasets[0].data.push(applicant.count);
    });
    if (this.chart) {
      this.chart.update();
    }
  }
}