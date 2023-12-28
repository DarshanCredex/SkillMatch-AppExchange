import { LightningElement } from 'lwc';
import Base64ToJsonMethod from '@salesforce/apex/Base64ToJson.Base64ToJsonMethod';

export default class UploadResume extends LightningElement {

    uploadedFile;
    filename = '';
    fileUrl;
    base64Data;

    handleUpload(event) {
        let file = event.target.files[0];
        this.filename = file.name;

    }

    
    
        
    
}