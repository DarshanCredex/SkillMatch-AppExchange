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

        let reader = new FileReader();
        reader.onloadend = () => {
            this.base64Data = reader.result.split(',')[1];
            console.log('Base64------->', this.base64Data);

           
            Base64ToJsonMethod({base64Data: this.base64Data})
            .then(result => {  
                console.log('success------>', result);
            })
            .catch(error => {
                console.error('Error------->', error);
            });
        };

        reader.readAsDataURL(file);
        this.uploadedFile = file;
    }

    
    
        
    
}