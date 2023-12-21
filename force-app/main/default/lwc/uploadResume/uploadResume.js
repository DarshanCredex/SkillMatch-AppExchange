import { LightningElement } from 'lwc';

export default class UploadResume extends LightningElement {

    uploadedFile;
    filename;
    handleUpload(event){
        let file = event.target.files[0];
        this.filename=file.name;
        console.log('this.filename-------->',this.filename);
        this.uploadedFile=file;
    }
}