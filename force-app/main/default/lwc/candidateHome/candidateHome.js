import { LightningElement, api } from "lwc";
import universities from "@salesforce/resourceUrl/universities";
import discoverjobs from "@salesforce/resourceUrl/discoverJobs";
import hiringCandidate from "@salesforce/resourceUrl/Start_Hiring";
import { NavigationMixin } from 'lightning/navigation';

export default class CandidateHome extends NavigationMixin(LightningElement) {
  universities = universities;
  discoverjobs = discoverjobs;
  hiringCandidate = hiringCandidate;

  @api testimonial_1 =
    "Securing my dream job was a breeze with SkillMatch. The intuitive interface and personalized job recommendations made my job hunt efficient and effective. I landed my ideal position faster than I ever imagined. Thank you, SkillMatch, for turning my career aspirations into reality!";
  @api author1 = "Sagar Medatwal/ Salesforce Inc.";

  @api testimonial_2 =
    "I was skeptical about online job platforms until I tried SkillMatch. The vast array of job listings, user-friendly design, and real-time updates made my job search a game-changer. Within weeks, I had multiple interviews lined up, and I am now happily employed in a role I love. SkillMatch is a true job seeker's ally!";
  @api author2 = "Darshan Yadav/ JP Morgan Chase";
  @api testimonial_3 =
    "Kudos to SkillMatch for revolutionizing my job search journey! The tailored job matches, insightful resources, and seamless application process made job hunting stress-free. I not only found a job that aligns with my skills but also discovered new opportunities I hadn't considered before. Thank you, SkillMatch, for being the catalyst in my career success!";
  @api author3 = "Prateek Tyagi/ Deloitte";

  handleRecruiterLogin() {
    this[NavigationMixin.GenerateUrl]({
      type: 'standard__webPage',
      attributes: {
        url: 'https://skillmatch-dev-ed.develop.my.site.com/HR/apex/recruiterLoginPage'
      }
    }).then(generatedUrl => {
      window.open(generatedUrl);
    });
  }
}