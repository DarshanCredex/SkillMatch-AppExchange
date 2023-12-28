import { LightningElement } from 'lwc';
import universities from '@salesforce/resourceUrl/universities';
import discoverjobs from '@salesforce/resourceUrl/discoverJobs';

export default class CandidateHome extends LightningElement {

    universities=universities;
    discoverjobs=discoverjobs;

    
}