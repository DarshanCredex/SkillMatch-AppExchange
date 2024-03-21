import { LightningElement } from 'lwc';
import populateCandidateObjectMethod from '@salesforce/apex/populateCandidateObject.populateCandidateObjectMethod';

export default class ResumeDetails extends LightningElement {

    name = '';
    experience = '';
    skills='';
    email='';

   

    saveButton(){
        this.name = this.template.querySelector('lightning-input[data-id="name"]').value;
        this.experience = this.template.querySelector('lightning-input[data-id="exp"]').value;
        this.skills = this.template.querySelector('lightning-input[data-id="skills"]').value;
        this.email = this.template.querySelector('lightning-input[data-id="email"]').value;

        if(this.name === '' || this.experience === '' || this.skills === '' || this.email === '' ){
            // eslint-disable-next-line no-alert
            alert('Please add data');
            return;
        }
        
        console.log(' this.name--------->', this.name);
        console.log('this.experience------>',this.experience);
        console.log('this.skills------>',this.skills);
        console.log('this.email--------->',this.email);
        populateCandidateObjectMethod({name: this.name, experience: this.experience, skills: this.skills, email: this.email})
        .then(() => {
            console.log('records created successfully');
        })
        .catch(error => {
            console.error('Error-------->', error);
        });
        
    }
}