import { LightningElement, wire, track } from "lwc";
import AgeWithNumberOfApplicants from "@salesforce/apex/analyticsDatasets.AgeWithNumberOfApplicants";
import chartjs from "@salesforce/resourceUrl/chartjs";
import { loadScript } from "lightning/platformResourceLoader";
import applicantGender from "@salesforce/apex/analyticsDatasets.applicantGender";

export default class Analytics extends LightningElement {
  @track ageWithNumberDataset = [];
  @track applicantGenderDataset = [];
  chart;
  chartjsInitialized = false;
  genderChartJsInitialized = false;
  piechart;

  @wire(AgeWithNumberOfApplicants)
  wiredAgeWithNumberOfApplicants({ error, data }) {
    if (error) {
      console.error("error----->", error.message);
      return;
    }
    if (data) {
      this.ageWithNumberDataset = data;
      console.log(
        "this.ageWithNumberDataset------->",
        this.ageWithNumberDataset
      );
      this.updateAgeChart();

      if (!this.chartjsInitialized) {
        this.chartjsInitialized = true;
        loadScript(this, chartjs).then(() => {
          const ctx = this.template
            .querySelector("canvas.bar")
            .getContext("2d");
          this.chart = new window.Chart(
            ctx,
            JSON.parse(JSON.stringify(this.config))
          );
          this.chart.canvas.parentNode.style.height = "auto";
          this.chart.canvas.parentNode.style.width = "100%";
        });
      }
      console.log(
        "this.ageWithNumberDataset---------->",
        JSON.stringify(this.ageWithNumberDataset)
      );
    }
  }
  @wire(applicantGender)
  wiredApplicantGender({ error, data }) {
    if (error) {
      console.error("error----->", error.message);
      return;
    }
    if (data) {
      this.applicantGenderDataset = data;
      console.log(
        "this.applicantGenderDataset------->",
        this.applicantGenderDataset
      );

      this.updateGenderChart();

      if (!this.genderChartJsInitialized) {
        this.genderChartJsInitialized = true;
        loadScript(this, chartjs).then(() => {
          const ctx_1 = this.template
            .querySelector("canvas.pie")
            .getContext("2d");
          this.piechart = new window.Chart(
            ctx_1,
            JSON.parse(JSON.stringify(this.newConfig))
          );
          this.piechart.canvas.parentNode.style.height = "auto";
          this.piechart.canvas.parentNode.style.width = "100%";
        });
      }
      console.log(
        "this.applicantGenderDataset---------->",
        JSON.stringify(this.applicantGenderDataset)
      );
    }
  }

  config = {
    type: "bar",
    data: {
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: [
            "rgb(255,99,132)",
            "rgb(255,159,64)",
            "rgb(255,205,86)",
            "rgb(75,192,192)",
            "rgb(153,102,204)",
            "rgb(200,158,181)",
            "rgb(188,152,126)",
            "rgb(123,104,238)",
            "rgb(119,221,119)",
            "rgb(119,221,80)"
          ],
          label: "Number of Applicants"
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: "Applicants - Age Group"
      },
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

  newConfig = {
    type: "pie",
    data: {
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: [
            "rgb(388,152,126)",
            "rgb(523,104,238)",
            "rgb(179,221,119)",
            "rgb(149,221,80)",
            "rgb(245,99,132)",
            "rgb(455,159,64)",
            "rgb(265,205,86)",
            "rgb(75,192,192)",
            "rgb(153,102,204)",
            "rgb(240,158,181)"
          ],
          label: "Number of Applicants"
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: "Applicants - Gender"
      },
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

  updateAgeChart() {
    this.config.data.labels = [];
    this.config.data.datasets[0].data = [];
    this.ageWithNumberDataset.forEach((applicant) => {
      this.config.data.labels.push(applicant.label);
      this.config.data.datasets[0].data.push(applicant.count);
    });

    if (this.chart) {
      this.chart.update();
    }
  }

  updateGenderChart() {
    console.log("inside gnder chart update method");
    this.newConfig.data.labels = [];
    this.newConfig.data.datasets[0].data = [];
    this.applicantGenderDataset.forEach((applicant) => {
      this.newConfig.data.labels.push(applicant.label);
      this.newConfig.data.datasets[0].data.push(applicant.count);
    });
    if (this.piechart) {
      this.piechart.update();
    }
  }
}
