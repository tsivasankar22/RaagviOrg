import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFolder from '@salesforce/apex/EmailAuthor.getFolder';
import getEmailTemplate from '@salesforce/apex/EmailAuthor.getEmailTemplate';
import showEmail from '@salesforce/apex/EmailAuthor.showEmail';
import sendEmail from '@salesforce/apex/EmailAuthor.sendEmail';
import getEmailBody from '@salesforce/apex/EmailAuthor.getEmailBody';
import fileAttachment from '@salesforce/apex/EmailAuthor.fileAttachment';
// import getFolder from '@salesforce/apex/CreateCaseFrmEmail.getFolder';
// import getEmailTemplate from '@salesforce/apex/CreateCaseFrmEmail.getEmailTemplate';
// import showEmail from '@salesforce/apex/CreateCaseFrmEmail.showEmail';
// import sendEmail from '@salesforce/apex/CreateCaseFrmEmail.sendEmail';
// import getEmailBody from '@salesforce/apex/CreateCaseFrmEmail.getEmailBody';
// import fileAttachment from '@salesforce/apex/CreateCaseFrmEmail.fileAttachment';
export default class EmailForm extends LightningElement {
        @api recordId;
        fileData;
        @track optionArray = [];
        @track templateArray = [];
        @track value = '';
        @track value2 = '';
        @track richText =null;
        @track templateSubject=null;
        @track toEmailAddress=null;
        @track toFile='';
            dataList=[];
            toEmail='';
            fromEmail = 'tsivasankar77@gmail.com';
            template='';
            subject ='';
            body ='';
            ccAddress='';
            file='';
            files = [];
            rID =[];
            wantToUploadFile = false;
            updateRecordView() {
                setTimeout(() => {
                     eval("$A.get('e.force:refreshView').fire();");
                }, 1000); 
             }
         toggleFileUpload(event) {   
             this.wantToUploadFile = !this.wantToUploadFile;
         }
         handleUploadFinished(event) {
             const uploadedFiles = event.detail.files;
             this.files = [...this.files, ...uploadedFiles];
             this.wantToUploadFile = false;
             this.files.forEach(element=>{
                if(element.contentVersionId!=undefined){
                console.log('idzzzzzzzzzzzz----',element.documentId)
                this.rID.push(element.documentId);
                }
             })
             console.log('ids------'+this.rID);
         }
         @wire(fileAttachment,{recordId :'$recordId'})
         wireFile({data,error}){
            if(data){
                console.log('Data from File----'+JSON.stringify(data));  
                let arr=[];
                data.forEach(element=>{     
                    this.rID.push(element.ContentDocumentId);      
                    const obj={
                        contentVersionId : element.Id,
                        name : element.Title
                    };   
                   arr.push(obj);
                    console.log('File id----'+JSON.parse(JSON.stringify(element.ContentDocumentId)));
                })  
                this.files=arr;
                console.log('File id from array-----'+this.rID);   
              
            }
            else if(error){
                console.log('Data from File error----'+JSON.stringify(error));
            }
         }
         handleRemove(event) {
             const index = event.target.dataset.index?event.target.dataset.index: event.detail.name;
           console.log('index',index);
           const file=this.files;
             file.splice(index, 1);
             this.files=[...file];
            const ids=this.rID;
            ids.splice(index,1);
            this.rID=[...ids];
             console.log(index,this.files);       
         }
         closeAction(){
            this.updateRecordView();
         } 
         onSendEmail(){
            console.log('Hi this is from send email');
          sendEmail({ toAddress: this.toEmail,fromAddress:this.fromEmail, subject: this.subject, body: this.body,recordId:this.recordId}).then(value=>{
            
            const event = new ShowToastEvent({ 
                message: 'Email Send Successfull',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.updateRecordView();
            console.log('Message is sending sucessfull');
          }).catch(error=>{
           const event = new ShowToastEvent({
            message: 'Email Send Unsuccessfull',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        this.updateRecordView();
            console.log('Message is Not sending sucessfull');
          });
         }
         @wire(showEmail,{recordId :'$recordId'})
         wiredRecord({data,error}){
             if(data){
                    console.log('Data from if----'+JSON.stringify(data));
                data.forEach(element => {
                  this.toEmailAddress = element.Contact.Email
                  this.toEmail = element.Contact.Email
                    console.log('email from This----',this.toEmail);
                    console.log('Elements----'+JSON.parse(JSON.stringify(element.Contact.Email)));
                });
               console.log('data from case----------'+JSON.stringify(this.Email));
             }
             else if(error){
                console.log('error from case----------'+JSON.stringify(error));
             }
         }
         handleChangeSend(event) {
            if (event.target.name === 'toAddress') {
                this.toEmail = event.target.value;
                console.log(this.toEmail); 
            }
        }
         get options(){
            return this.optionArray;
         }
        connectedCallback(){
            getFolder().then(result=>{
                let arr= [];
                console.log('data--------->',JSON.stringify(result) );
                for(var i=0; i<result.length; i++){
                    arr.push({label:result[i].Name,value:result[i].Id})
                }
                    this.optionArray = arr;  
            }).catch(error=>{
                console.log('error1------------>',JSON.stringify(error));
            })
        }
        get templateOptions()
        {
            return this.templateArray;
        }
        handleChange(event){
            this.value = event.target.value;
            console.log('event------->', this.value);
            getEmailTemplate({recordId : this.value}).then(result=>{
                console.log('Inside the get email template'); 
                let arr= [];    
                console.log('data--------->',JSON.stringify(result) );
                for(var i=0; i<result.length; i++){
                    arr.push({label:result[i].Name,value:result[i].Id})
                }
                    this.templateArray = arr; 
            }).catch(error=>{
                console.log('error2------------>',error.body);
            })
        }
       handleTemplateChange(event){
            this.value = event.target.value;
            console.log('eventValue------->', this.value);
            getEmailBody({recordId : this.value}).then(result=>{
                for(var i=0; i<result.length; i++){
                this.richText = result[i].Body;
                this.templateSubject=result[i].Subject;
                this.body = result[i].Body;
                this.subject = result[i].Subject;
                console.log('this is the subject---',this.subject);
                console.log('this is body---',this.body);
                }
            }) 
       }    
}