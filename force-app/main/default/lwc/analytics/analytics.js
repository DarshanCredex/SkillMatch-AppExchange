import { LightningElement, wire, track } from "lwc";
import AgeWithNumberOfApplicants from "@salesforce/apex/analyticsDatasets.AgeWithNumberOfApplicants";
import chartjs from "@salesforce/resourceUrl/chartjs";
import { loadScript } from "lightning/platformResourceLoader";
import applicantGender from "@salesforce/apex/analyticsDatasets.applicantGender";
import industryJobsDataset from "@salesforce/apex/analyticsDatasets.industryJobsDataset";
import numberOfApplicantsVsJobs from "@salesforce/apex/analyticsDatasets.numberOfApplicantsVsJobs";
import Id from "@salesforce/user/Id";

export default class Analytics extends LightningElement {
  @track ageWithNumberDataset = [];
  @track applicantGenderDataset = [];
  @track industryAndJobsDataset = [];
  @track applicantsVsJobs = [];

  chartjsInitialized = false;
  genderChartJsInitialized = false;
  industryChartjsIntialized = false;
  numberfApplicantsVsJobsChartjsInitialized = false;

  piechart;
  industryChart;
  chart;
  numberfApplicantsVsJobsChart;

  userId = Id;

  @wire(industryJobsDataset, {userId:"$userId"})
  wiredindustryJobsDataset({ error, data }) {
    if (error) {
      console.error("error----->", error);
    } else if (data) {
      this.industryAndJobsDataset = data;

      this.updateIndustryChart();

      if (!this.industryChartjsIntialized) {
        this.industryChartjsIntialized = true;
        loadScript(this, chartjs).then(() => {
          const ctx_2 = this.template
            .querySelector("canvas.industryDoughnut")
            .getContext("2d");
          this.industryChart = new window.Chart(
            ctx_2,
            JSON.parse(JSON.stringify(this.industryConfig))
          );
          this.industryChart.canvas.parentNode.style.height = "auto";
          this.industryChart.canvas.parentNode.style.width = "100%";
        });
      }
    }
  }

  @wire(AgeWithNumberOfApplicants , {userId:"$userId"})
  wiredAgeWithNumberOfApplicants({ error, data }) {
    if (error) {
      console.error("error----->", error.message);
      return;
    }
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
    }
  }
  @wire(applicantGender , {userId:"$userId"})
  wiredApplicantGender({ error, data }) {
    if (error) {
      console.error("error----->", error.message);
      return;
    }
    if (data) {
      this.applicantGenderDataset = data;

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
    }
  }

  @wire(numberOfApplicantsVsJobs, {userId:"$userId"})
  wiredNumberOfApplicantsVsJobs({ error, data }) {
    if (error) {
      console.error("Error------>", error);
    } else if (data) {
      this.applicantsVsJobs = data;

      this.updateApplicantsVsJobsChart();

      if (!this.numberfApplicantsVsJobsChartjsInitialized) {
        this.numberfApplicantsVsJobsChartjsInitialized = true;
        loadScript(this, chartjs).then(() => {
          const ctx = this.template
            .querySelector("canvas.barchart_1")
            .getContext("2d");
          this.numberfApplicantsVsJobsChart = new window.Chart(
            ctx,
            JSON.parse(JSON.stringify(this.barConfig))
          );
          this.numberfApplicantsVsJobsChart.canvas.parentNode.style.height =
            "auto";
          this.numberfApplicantsVsJobsChart.canvas.parentNode.style.width =
            "100%";
        });
      }
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
        text: "Applicants vs Age Group"
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

  industryConfig = {
    type: "doughnut",
    data: {
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: [
            "rgb(153,102,204)",
            "rgb(388,152,126)",
            "rgb(199,421,80)",
            "rgb(545,99,132)",
            "rgb(555,159,64)",
            "rgb(388,152,126)",
            "rgb(924,104,238)",
            "rgb(265,205,86)",
            "rgb(753,192,192)",
            "rgb(240,158,181)"
          ],
          label: "Number of Jobs"
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: "Industry vs Number of Jobs posted"
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
        text: "Applicants vs Gender"
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

  barConfig = {
    type: "bar",
    data: {
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: [
            "rgb(233,102,204)",
            "rgb(768,177,426)",
            "rgb(265,205,86)",
            "rgb(545,349,132)",
            "rgb(555,459,64)",
            "rgb(388,152,126)",
            "rgb(924,104,238)",
            "rgb(265,205,86)",
            "rgb(753,192,192)",
            "rgb(240,158,181)"
          ],
          label: "Title of Position"
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: "Jobs posted vs Number of Applicants"
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
  updateIndustryChart() {
    this.industryConfig.data.labels = [];
    this.industryConfig.data.datasets[0].data = [];
    this.industryAndJobsDataset.forEach((jobs) => {
      this.industryConfig.data.labels.push(jobs.label);
      this.industryConfig.data.datasets[0].data.push(jobs.count);
    });
    if (this.industryChart) {
      this.industryChart.update();
    }
  }

  updateApplicantsVsJobsChart() {
    this.barConfig.data.labels = [];
    this.barConfig.data.datasets[0].data = [];
    this.applicantsVsJobs.forEach((jobs) => {
      this.barConfig.data.labels.push(jobs.label);
      this.barConfig.data.datasets[0].data.push(jobs.count);
    });
    if (this.numberfApplicantsVsJobsChart) {
      this.numberfApplicantsVsJobsChart.update();
    }
  }
}