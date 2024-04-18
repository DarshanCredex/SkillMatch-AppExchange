import { LightningElement, wire } from "lwc";
import AgeWithNumberOfApplicants from "@salesforce/apex/analyticsDatasets.AgeWithNumberOfApplicants";
import applicantGender from "@salesforce/apex/analyticsDatasets.applicantGender";
import industryJobsDataset from "@salesforce/apex/analyticsDatasets.industryJobsDataset";
import numberOfApplicantsVsJobs from "@salesforce/apex/analyticsDatasets.numberOfApplicantsVsJobs";
import numberOfApplicantsAssessmentStatusVsJob from "@salesforce/apex/analyticsDatasets.numberOfApplicantsAssessmentStatusVsJob";
import numberofQuestionsVsJobPosted from "@salesforce/apex/analyticsDatasets.numberofQuestionsVsJobPosted";
import chartjs from "@salesforce/resourceUrl/chartjs";
import { loadScript } from "lightning/platformResourceLoader";
import Id from "@salesforce/user/Id";

const CHART_COLORS = [
  "rgb(255,99,132)",
  "rgb(255,159,64)",
  "rgb(212,205,86)",
  "rgb(75,192,192)",
  "rgb(153,102,204)",
  "rgb(200,158,181)",
  "rgb(128,152,126)",
  "rgb(123,124,238)",
  "rgb(119,221,119)",
  "rgb(129,221,80)",
  "rgb(229,421,80)"
];

const CHART_COLORS_1 = [
  "rgb(119,221,119)",
  "rgb(200,158,181)",
  "rgb(153,102,204)",
  "rgb(255,99,132)",
  "rgb(255,159,64)",
  "rgb(212,205,86)",
  "rgb(75,192,192)",
  "rgb(128,152,126)",
  "rgb(123,124,238)",
  "rgb(129,221,80)",
  "rgb(229,421,80)"
];

const CHART_COLORS_2 = [
  "rgb(275,492,132)",
  "rgb(119,221,119)",
  "rgb(240,153,181)",
  "rgb(153,132,204)",
  "rgb(255,99,132)",
  "rgb(255,159,324)",
  "rgb(212,205,86)",
  "rgb(128,152,126)",
  "rgb(423,124,238)",
  "rgb(129,241,80)",
  "rgb(229,421,80)"
];

const CHART_COLORS_3 = [
  "rgb(129,421,320)",
  "rgb(212,205,86)",
  "rgb(423,124,238)",
  "rgb(128,152,126)",
  "rgb(275,492,132)",
  "rgb(119,221,119)",
  "rgb(240,153,181)",
  "rgb(153,132,204)",
  "rgb(255,99,132)",
  "rgb(255,159,324)",
  "rgb(229,421,80)"
];

const CHART_COLORS_4 = [
  "rgb(119,221,119)",
  "rgb(240,153,181)",
  "rgb(329,441,320)",
  "rgb(275,492,132)",
  "rgb(212,205,86)",
  "rgb(423,124,238)",
  "rgb(128,152,126)",
  "rgb(153,132,204)",
  "rgb(255,99,132)",
  "rgb(255,159,324)",
  "rgb(229,421,80)"
];

export default class Analytics extends LightningElement {
  chartjsInitialized = false;

  userId = Id;

  charts = {};

  async loadChartJs() {
    if (!this.chartjsInitialized) {
      await loadScript(this, chartjs);
      this.chartjsInitialized = true;
    }
  }

  initializeChart(canvasSelector, config) {
    const ctx = this.template.querySelector(canvasSelector).getContext("2d");
    return new window.Chart(ctx, config);
  }

  updateChart(chart, data) {
    chart.data.labels = data.map((item) => item.label);
    chart.data.datasets[0].data = data.map((item) => item.count);
    chart.update();
  }

  @wire(numberOfApplicantsAssessmentStatusVsJob, { userId: "$userId" })
  async handleApplicantsAssessmentStatusVsJob({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.assessmentchart) {
        this.charts.assessmentchart = this.initializeChart(
          "canvas.bar_assessment_chart",
          this.getAssessmentStatusVsJobChartConfig()
        );
      }
      this.updateChart(this.charts.assessmentchart, data);
    }
  }

  @wire(numberofQuestionsVsJobPosted, { userId: "$userId" })
  async handleNumberOfQuestionsVsJObPosted({ error, data }) {
    if (error) {
      console.error("error------->", error);
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.numberOfQuestionsChart) {
        this.charts.numberOfQuestionsChart = this.initializeChart(
          "canvas.bar_numberofQuestionsVsJobPostedChart",
          this.getNumberofQuestionsVsJobPostedChartConfig()
        );
      }
      this.updateChart(this.charts.numberOfQuestionsChart, data);
    }
  }

  @wire(AgeWithNumberOfApplicants, { userId: "$userId" })
  async handleAgeData({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.ageChart) {
        this.charts.ageChart = this.initializeChart(
          "canvas.bar",
          this.getAgeChartConfig()
        );
      }
      this.updateChart(this.charts.ageChart, data);
    }
  }
  @wire(applicantGender, { userId: "$userId" })
  async handleGenderData({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.genderChart) {
        this.charts.genderChart = this.initializeChart(
          "canvas.pie",
          this.getGenderChartConfig()
        );
      }
      this.updateChart(this.charts.genderChart, data);
    }
  }
  @wire(industryJobsDataset, { userId: "$userId" })
  async handleIndustryData({ error, data }) {
    if (error) {
      console.error("Error in industryJobsDataset:", error);
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.industryChart) {
        this.charts.industryChart = this.initializeChart(
          "canvas.industryDoughnut",
          this.getIndustryChartConfig()
        );
      }
      this.updateChart(this.charts.industryChart, data);
    }
  }

  @wire(numberOfApplicantsVsJobs, { userId: "$userId" })
  async handleApplicantsVsJobsData({ error, data }) {
    if (error) {
      return;
    }
    if (data) {
      await this.loadChartJs();
      if (!this.charts.applicantsVsJobsChart) {
        this.charts.applicantsVsJobsChart = this.initializeChart(
          "canvas.barchart_1",
          this.getApplicantsVsJobsChartConfig()
        );
      }
      this.updateChart(this.charts.applicantsVsJobsChart, data);
    }
  }
  getAgeChartConfig() {
    return {
      type: "bar",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS,
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
  }
  getIndustryChartConfig() {
    return {
      type: "doughnut",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS_1,
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
  }
  getGenderChartConfig() {
    return {
      type: "pie",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS_2,
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
  }
  getApplicantsVsJobsChartConfig() {
    return {
      type: "bar",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS_3,
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
  }

  getAssessmentStatusVsJobChartConfig() {
    return {
      type: "bar",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS_4,
            label: "Title of Position"
          }
        ]
      },
      options: {
        responsive: true,
        title: {
          display: true,
          text: "Job  vs Number of applicants Assessemnt Given"
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
  }

  getNumberofQuestionsVsJobPostedChartConfig() {
    return {
      type: "bar",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            backgroundColor: CHART_COLORS_1,
            label: "Title of Position"
          }
        ]
      },
      options: {
        responsive: true,
        title: {
          display: true,
          text: "Number of Questions vs Job posted"
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
  }
}
