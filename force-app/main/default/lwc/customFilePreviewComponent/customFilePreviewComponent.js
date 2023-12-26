import { LightningElement, track } from 'lwc';

export default class CustomFilePreviewComponent extends LightningElement {
  @track pdfUrl;

  connectedCallback() {
    const urlParams = new URLSearchParams(window.location.search);
    this.pdfUrl = urlParams.get('pdfUrl');
  }
}