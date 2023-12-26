import { LightningElement, track } from 'lwc';

export default class CustomPDFViewer extends LightningElement {
    @track pdfDataUrl;

    connectedCallback() {
        this.loadPDF();
    }

    async loadPDF() {
        const documentId = '0685i00000BEs6nAAD'; // Replace with the actual document ID

        // Construct the URL to fetch the PDF data
        const pdfUrl = `https://raagvitech77-dev-ed.my.salesforce.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${documentId}`;

        const response = await fetch(pdfUrl);
        const blob = await response.blob();

        this.pdfDataUrl = URL.createObjectURL(blob);
    }
}
