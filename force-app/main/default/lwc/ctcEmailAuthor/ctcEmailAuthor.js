import { LightningElement, api, wire, track } from 'lwc';
import getEmailTemplateFolders from '@salesforce/apex/CTCEmailAuthorController.getEmailTemplateFolders';
import getEmailTemplates from '@salesforce/apex/CTCEmailAuthorController.getEmailTemplates';
import getCaseEmailAddress from '@salesforce/apex/CTCEmailAuthorController.getCaseEmailAddress';
// import getOrgWideEmailAddress from '@salesforce/apex/CTCEmailAuthorController.getOrgWideEmailAddress';
import sendEmailToController from '@salesforce/apex/CTCEmailAuthorController.sendEmailToController';
import fileAttachment from '@salesforce/apex/CTCEmailAuthorController.fileAttachment';
import {CloseActionScreenEvent} from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CtcEmailAuthor extends LightningElement {

    @track body;
    @api myRecordId;
    @track subject;
    @api recordId;
    @track attach;
    isShowModal = true;
    @track getFileUpload;
    @track orgWideAddress;
    @track toAddress;
    @track fromAddress;
    @track emailvalue = [];
    @track lstAllFiles = [];
    @track uploadFile = [];
    @track removeFile = [];
    @track getTempList = [];
    @track emailTempList = [];
    @track getEmailTempValue = [];
    @track resultgetEmailTemplates;
    @track selectedEmailTempValue;
    @track getSelectedEmailTempValue;
    @track allFilesIds = [];
    //@track fromAddressORGWideAdd ;

    //File Upload
    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg'];
    }

    connectedCallback() {
        setTimeout(() => {
            console.log('recordId>>>>>>>>>', this.recordId);
        }, 2000)
        getEmailTemplateFolders()
            .then(result => {
                this.result = result;
                var colum = [];
                console.log('resultresult>>>>>>>>' + JSON.stringify(result));
                this.result.forEach(element => {
                    var emailTempFolderLists = {};
                    emailTempFolderLists.label = element.Name;
                    emailTempFolderLists.value = element.Name;
                    colum.push(emailTempFolderLists);
                    console.log('getTempList>>>>>>' + JSON.stringify(colum));
                    console.log('recordId>>>>', this.recordId);
                });
                this.getTempList = colum;
            })
            .catch(error => {
                this.error = error;
                console.log('Erroe>>>>>>>>' + error);
            });
        // Attachment
        if (this.recordId !== undefined || this.recordId !== null) {
            setTimeout(() => {
                console.log('recordId>>>>>>>>>', this.recordId);
                fileAttachment({ caseRecId: this.recordId })
                    .then(file => {
                        this.attach = file;
                        var attachmentId = [];
                        file.forEach(ele => {
                            const obj = {
                                contentVersionId: ele.Id,
                                name: ele.Title
                            };
                            attachmentId.push(obj);
                            this.removeFile.push(ele.ContentDocumentId);
                            this.allFilesIds.push(ele.ContentDocumentId);
                           
                            this.uploadFile.push(ele.ContentDocumentId);
                        });
                        this.uploadFile = attachmentId;
                        //this.uploadFile.push(attachmentId);
                        
                    })
                    .catch(error => {
                        this.error = error;
                        console.log('Error>>>>>>>>' + error);
                    })
            }, 2000)

        }
    }

    //Selected Email Temp Folder
    selectedEmailTempFolder(event) {
        this.getSelectedEmailTempValue = event.detail.value;
        getEmailTemplates({ folderName: this.getSelectedEmailTempValue })
            .then(resultgetEmailTemplates => {
                this.resultgetEmailTemplates = resultgetEmailTemplates;
                var colum = [];
                this.resultgetEmailTemplates.forEach(element => {
                    var emailTempLists = {};
                    emailTempLists.label = element.Name;
                    emailTempLists.value = element.Name;
                    emailTempLists.Id = element.Id;
                    colum.push(emailTempLists);
                });
                this.emailTempList = colum;
            })
            .catch(error => {
                this.error = error;
                console.log('ERROR>>>>resultgetEmailTemplates>>>>>');
            });
    }

    //Selected Email Temp
    selectedEmailTemp(event) {
        this.selectedEmailTempValue = event.detail.value;
        for (let i = 0; i < this.resultgetEmailTemplates.length; i++) {
            if (this.resultgetEmailTemplates[i].Name == this.selectedEmailTempValue) {
                this.body = this.resultgetEmailTemplates[i].Body;
                this.subject = this.resultgetEmailTemplates[i].Subject;
            }
        }
    }

    //Case To Address
    @wire(getCaseEmailAddress, { caseRecordId: '$recordId' }) wiredToAddress({ error, data }) {
        console.log('getCaseEmailAddress>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        if (data) {
            data.forEach(ele => {
                this.toAddress = ele.CTC_Inbound_Email_Address__c;
                this.fromAddress = ele.CTC_Outbound_Email_Address__c;
                //this.fromAddressORGWideAdd = ele.CTC_Outbound_Email_Address__c;
                console.log('toAddress>>>>>>>>>>>>>>>>',this.toAddress);
                console.log('fromAddress>>>>>>>>>>>>>>>>',this.fromAddress);
            })
        } else if (error) {
            this.error = error;
            console.log('error>>00---->>>', JSON.stringify(error));
        }
    }
    
    //Send Email Button
    async sendEmail() {
        console.log('sendEmail>>>>>>>>>>>>>>>>>>>');
        console.log('toAddressEmail>>>>>>>>>>', this.toAddress);
        console.log('fromAddress>>>>>>>>>>', this.fromAddress);
        console.log('subjectEmail>>>>>>>', this.subject);
        console.log('bodyEmail>>>>>>>>', this.body);
        // console.log('this.uploadFile>>>>>>>>>>', JSON.stringify(this.uploadFile));
        await sendEmailToController({ toAddressEmail: this.toAddress, fromEmailAddress:  this.fromAddress, subjectEmail: this.subject, bodyEmail: this.body, caseRecordId: this.recordId, uploadedFiles: this.allFilesIds })
            .then(result => {
                this.sendEmailData = result;
                if (result == null) {
                    this.dispatchEvent(new CloseActionScreenEvent);
                   //After sending the email show the Success Toast Message.
                    const evt = new ShowToastEvent({
                        title: 'Reply',
                        message: 'Email Send Sucessful',
                        variant: 'Success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }else if(result != null){
                    const err = new ShowToastEvent({
                        title: 'Reply Error',
                        message: 'Email Send Unsucessful',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(err);
                }
                console.log('sendEmailData>>>>>>>>>>', JSON.stringify(this.sendEmailData));
            })
            .catch(error => {
                this.error = error;
                console.log('Error this.sendEmailData', JSON.stringify(error));
            });
        //Validation Fields
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        console.log('validatevalidate>>>>>>>>>>', JSON.stringify(inputFields));
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;

    }

    //Cancel/ Close Button
    cancelPopup() {
        this.dispatchEvent(new CloseActionScreenEvent);
        // this.emailvalue = null;
        // this.subject = null;
        // this.uploadFile = null;
        // this.getTempList = null;
        // this.emailTempList = null;
        // this.body  = null;
    }

    //Onclick To Email Address
    handleToEmailAddress(event) {
        this.emailvalue = event.target.value;
    }

    ////Onclick From Email Address
    handleChange(event) {
        this.fromAddressORGWideAdd = event.target.value;
        console.log(' this.fromAddressORGWideAdd>>>>>>>>>>',  this.fromAddressORGWideAdd);

    }

    //Subject Handler
    handleSubject(event) {
        this.subject = event.detail.value;
    }

    //Remove File
    fileRemove(event) {
        console.log('removeFile>>>>>>>>>>>>>>>>>');
        const index = event.target.dataset.index ? event.target.dataset.index : event.detail.name;
        console.log('index>>>>>>>>>>', event.currentTarget.dataset.Id);
        console.log('id rem>>>>>>>>', JSON.stringify(this.removeFile));
        const fileIterator = this.uploadFile;
        fileIterator.splice(index, 1);
        const ids = this.allFilesIds;
        ids.splice(index, 1);
        this.removeFile = [...ids];
    }

    //Upload Files
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.uploadFile = [...this.uploadFile, ...uploadedFiles];
        this.wantToUploadFile = false;
        uploadedFiles.forEach(files => {
            this.allFilesIds.push(files.documentId);
            this.removeFile.push(files.documentId);
            console.log('this.allFilesIds.push(files.ContentDocumentId));>>', JSON.stringify(this.allFilesIds));
            console.log('this.removeFile.push(files.ContentDocumentId));>>', JSON.stringify(this.removeFile));
        });
    }
}