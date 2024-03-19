import { LightningElement, wire, track } from "lwc";
import getJobs from "@salesforce/apex/JobListController.getJobList";
import alternateCompanyLogo from "@salesforce/resourceUrl/Alternate_Company_Logo";
import getTypePicklistValues from "@salesforce/apex/JobListController.getTypeValues";
import getExperiencePicklistValues from "@salesforce/apex/JobListController.getExperienceValues";
import getIndustryPicklistValues from "@salesforce/apex/JobListController.getIndustryValues";
import emptyBox from "@salesforce/resourceUrl/empty_box";

import { NavigationMixin } from "lightning/navigation";

export default class JobList extends NavigationMixin(LightningElement) {
  companyLogo = alternateCompanyLogo;
  @track sortValue = "date";
  typeValues = [];
  emptyBox = emptyBox;
  experienceValues = [];
  industryValues = [];
  @track selectedTypeValues = [];
  @track selectedExperienceValues = [];
  @track selectedIndustryValues = [];
  @track searchLocation = "";
  @track searchTitle = "";
  @track isLoading = false;
  @track errorMessage = false;
  @track jobListdata;

  connectedCallback() {
    this.searchTitle = sessionStorage.getItem("searchText") || "";
    sessionStorage.clear();
    console.log("searchTitle-->", this.searchLocation);
    console.log("searchLocation-->", this.searchLocation);

    getTypePicklistValues()
      .then((result) => {
        this.typeValues = result;
      })
      .catch((error) => {
        console.error("Error fetching type picklist values:", error);
      });
    getExperiencePicklistValues()
      .then((result) => {
        this.experienceValues = result;
      })
      .catch((error) => {
        console.error("Error fetching experience picklist values:", error);
      });
    getIndustryPicklistValues()
      .then((result) => {
        this.industryValues = result;
      })
      .catch((error) => {
        console.error("Error fetching industry picklist values:", error);
      });
  }

  @wire(getJobs, {
    searchTitle: "$searchTitle",
    searchLocation: "$searchLocation",
    selectedTypeValues: "$selectedTypeValues",
    selectedExperienceValues: "$selectedExperienceValues",
    selectedIndustryValues: "$selectedIndustryValues"
  })
  jobList({ data, error }) {
    if (data) {
      this.jobListdata = data;
      if (this.jobListdata.length > 0) {
        this.errorMessage = false;
      } else {
        this.errorMessage = true;
      }
    } else {
      console.error(error);
    }
  }

  get sortOptions() {
    return [
      { label: "Date", value: "date" },
      { label: "Closet", value: "closet" }
    ];
  }

  handleTypeChange(event) {
    const selectedType = event.target.value;
    const isChecked = event.target.checked;

    if (isChecked) {
      this.selectedTypeValues = [...this.selectedTypeValues, selectedType];
    } else {
      this.selectedTypeValues = this.selectedTypeValues.filter(
        (item) => item !== selectedType
      );
    }
  }

  handleExperienceChange(event) {
    const selectedExperience = event.target.value;
    const isChecked = event.target.checked;

    if (isChecked) {
      this.selectedExperienceValues = [
        ...this.selectedExperienceValues,
        selectedExperience
      ];
    } else {
      this.selectedExperienceValues = this.selectedExperienceValues.filter(
        (item) => item !== selectedExperience
      );
    }
  }

  handleIndustryChange(event) {
    const selectedIndustry = event.target.value;
    const isChecked = event.target.checked;

    if (isChecked) {
      this.selectedIndustryValues = [
        ...this.selectedIndustryValues,
        selectedIndustry
      ];
    } else {
      this.selectedIndustryValues = this.selectedIndustryValues.filter(
        (item) => item !== selectedIndustry
      );
    }
  }

  handleChange(event) {
    this.sortValue = event.detail.value;
  }

  handleSearchTitleChange(event) {
    this.searchTitle = event.target.value;
  }

  handleSearchLocationChange(event) {
    this.searchLocation = event.target.value;
  }

  handleClearFilters() {
    this.selectedTypeValues = [];
    this.selectedExperienceValues = [];
    this.selectedIndustryValues = [];

    const checkboxList = this.template.querySelectorAll('[data-id="checkbox"]');
    for (const checkboxElement of checkboxList) {
      checkboxElement.checked = false;
    }
  }

  handleJobDetail(event) {
    let jobId = event.currentTarget.id;
    jobId = jobId.split("-");
    this[NavigationMixin.GenerateUrl]({
      type: "standard__webPage",
      attributes: {
        url: "/s/job-detail?id=" + jobId[0]
      }
    }).then((generatedUrl) => {
      window.open(generatedUrl);
    });
  }
}
