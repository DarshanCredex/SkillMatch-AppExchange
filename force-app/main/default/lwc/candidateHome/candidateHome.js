import { LightningElement, api } from "lwc";
import universities from "@salesforce/resourceUrl/universities";
import discoverjobs from "@salesforce/resourceUrl/discoverJobs";

export default class CandidateHome extends LightningElement {
    universities = universities;
    discoverjobs = discoverjobs;

    @api testimonial_1;
    @api author1;
    @api testimonial_2;
    @api author2;
    @api testimonial_3;
    @api author3;
}
