import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import pdfJsLib from '@salesforce/resourceUrl/pdfJS';
import pdfJsWorker from '@salesforce/resourceUrl/pdfJsWorker'; // Replace with your static resource URL for pdf.worker.min.js

// export default class PdfParserLWC extends LightningElement {
//     @track isLoading = false;
//     @track parsedText = '';
//     @track error;

//     pdfUrl = '';

//     renderedCallback() {
//         this.loadPdfJs();
//     }

//     loadPdfJs() {
//         loadScript(this, pdfjs)
//             .then(() => {
//                 console.log('PDF.js loaded successfully');
//             })
//             .catch(error => {
//                 console.error('Error loading PDF.js:', error);
//             });
//     }

//     // handleUrlChange(event) {
//     //     this.pdfUrl = event.target.value;
//     // }

//     handleFileChange(event) {
//         console.log('event', event);
//         const file = event.detail.files[0];
//         console.log('file', file);
//         if (file) {
//             console.log('file is successfully uploaded');
//             this.parsePDF(file);
//         }
//     }

//     parsePDF(file) {
//         this.isLoading = true;
//         console.log('Parsing PDF file...');
//         const reader = new FileReader();
//         console.log('reader', reader);
//         reader.onload = () => {
//             console.log('PDF file loaded successfully');
//             const arrayBuffer = reader.result;
//             this.extractTextFromPdf(arrayBuffer);
//         };
//         reader.readAsArrayBuffer(file);
//     }

//     extractTextFromPdf(arrayBuffer) {
//         window.PDFJS.getDocument(arrayBuffer).promise.then(pdf => {
//             console.log('PDF document loaded successfully');
//             let text = '';
//             const numPages = pdf.numPages;

//             const extractPageText = (pageNumber) => {
//                 pdf.getPage(pageNumber).then(page => {
//                     page.getTextContent().then(content => {
//                         content.items.forEach(item => {
//                             text += item.str + ' ';
//                         });
//                         if (pageNumber < numPages) {
//                             extractPageText(pageNumber + 1);
//                         } else {
//                             this.handleText(text);
//                         }
//                     });
//                 });
//             };

//             extractPageText(1);
//         }).catch(error => {
//             console.error('Error loading PDF document:', error);
//             this.error = error;
//             this.isLoading = false;
//         });
//     }

//     handleText(text) {
//         this.parsedText = text;
//         console.log('Text extracted from PDF:', text);
//         this.isLoading = false;
//     }
// }
export default class PdfParserLWC extends LightningElement {

        connectedCallback() {
            loadScript(this, pdfJsLib)
                .then(() => {
                    console.log('pdf.js loaded');
                })
                .catch(error => {
                    console.error('Error loading pdf.js:', error);
                });
        }
    
        async extractText(file) {
            const reader = new FileReader();
            reader.readAsArrayBuffer(file);
            reader.onload = async () => {
                const typedArray = reader.result;
    
                // **Address Deprecated API Warning:**
                // We'll set workerSrc within the options object to avoid the warning.
                const options = {
                    workerSrc: pdfJsWorker + '/build/pdf.worker.min.js' // Assuming the worker script is inside a "build" folder within the static resource
                };
    
                const pdfDocument = await pdfjsLib.getDocument(typedArray, options).promise;
                const numPages = pdfDocument.numPages;
    
                let extractedText = '';
                for (let i = 1; i <= numPages; i++) {
                    const page = await pdfDocument.getPage(i);
                    const pageText = await page.getTextContent();
                    const pageStrings = pageText.items.map(item => item.str);
                    extractedText += pageStrings.join('\n');
                }
    
                // Display the extracted text (update your template accordingly)
                console.log('Extracted Text:', extractedText);
            };
            reader.onerror = error => {
                console.error('Error reading PDF file:', error);
            };
        }
    
        handleFileChange(event) {
            const file = event.target.files[0];
            if (file && file.type === 'application/pdf') {
                this.extractText(file);
            } else {
                console.error('Invalid file type. Please upload a PDF file.');
            }
        }
    

    }