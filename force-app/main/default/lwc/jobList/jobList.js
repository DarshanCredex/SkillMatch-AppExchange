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
  emptyBox = emptyBox;
  typeValues = [];
  experienceValues = [];
  industryValues = [];
  // @track sortValue = "date";
  @track selectedTypeValues = [];
  @track selectedExperienceValues = [];
  @track selectedIndustryValues = [];
  @track searchLocation = "";
  @track searchTitle = "";
  @track isLoading = false;
  @track errorMessage = false;
  @track jobListdata = [];
  @track filterJobListData = [];

  connectedCallback() {
    this.searchTitle = sessionStorage.getItem("searchText") || "";
    sessionStorage.clear();

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

  get sortOptions() {
    return [
      { label: "Clear filter", value: "clear" },
      { label: "Date", value: "date" },
    ];
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
      console.log("joblist--->", data);
      this.jobListdata = data;
      this.filterJobListData = [...this.jobListdata];
      if (this.jobListdata.length > 0) {
        this.errorMessage = false;
      } else {
        this.errorMessage = true;
      }
    } else {
      console.error(error);
    }
  }

  handleSortOptions(event) {
    const value = event.target.value;

    if (value === "clear") {
      this.filterJobListData = [...this.jobListdata];
    } else if (value === "date") {
      this.handleSortList();
    }
  }

  handleSortList() {
    if (Array.isArray(this.filterJobListData)) {
      this.filterJobListData.sort((a, b) => a.daysAgo - b.daysAgo);
      console.log(
        "this.filterJobListData---> (sorted)",
        JSON.stringify(this.filterJobListData)
      );
    } else {
      console.error("filterJobListData is not an array");
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
    jobId = jobId.split("-")[0];
    this[NavigationMixin.GenerateUrl]({
      type: "standard__webPage",
      attributes: {
        url: "/s/job-detail?id=" + jobId
      }
    }).then((generatedUrl) => {
      window.open(generatedUrl);
    });
  }
}
