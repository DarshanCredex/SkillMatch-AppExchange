import { LightningElement, wire, track } from "lwc";
import AgeWithNumberOfApplicants from "@salesforce/apex/analyticsDatasets.AgeWithNumberOfApplicants";
import chartjs from "@salesforce/resourceUrl/chartjs";
import { loadScript } from "lightning/platformResourceLoader";

export default class Analytics extends LightningElement {
  @track ageWithNumberDataset = [];
  chart;
  chartjsInitialized = false;

  @wire(AgeWithNumberOfApplicants)
  wiredAgeWithNumberOfApplicants({ error, data }) {
    if (data) {
      this.ageWithNumberDataset = data;
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
    } else {
      console.error("error----->", error);
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
}
