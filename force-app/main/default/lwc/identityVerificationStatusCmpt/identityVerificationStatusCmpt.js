import { LightningElement ,track,api,wire} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import Identity_Verification_Status__c from '@salesforce/schema/Residential_Loan_Application__c.Identity_Verification_Status__c';
import doSubmit from '@salesforce/apex/IdentityVerificationStatusHandler.doSubmit';
import UpdateStatus from '@salesforce/apex/IdentityVerificationStatusHandler.UpdateIdentityVerification';
//import getAllMortgageContactRoles from '@salesforce/apex/IdentityVerificationStatusHandler.getAllMortgageContactRoles';

const fields = [Identity_Verification_Status__c];

export default class IdentityVerificationStatusCmpt extends LightningElement {
    @api recordId;
    @track IsModelOpen=false;
    @track identityVerificationStatus;

    @wire(getRecord, { recordId: "$recordId", fields })
    wireddata({ data, error }) {
      if (data) {
        this.identityVerificationStatus = getFieldValue(data, Identity_Verification_Status__c);
        console.log('Identity verification default value ======>' + this.identityVerificationStatus);
      } else if (error) {
        console.error('Error loading record: ', error);
      }
    }

    connectedCallback(){
        console.log('Current RecordId =============>' + this.recordId);
        this.VerificationMethod();
    }
    openModel(){
        this.IsModelOpen=true;
    }
    closeModel(){
        this.IsModelOpen=false;
    }
    onGroup(event){
        this.identityVerificationStatus=event.target.value;
        console.log('selectId--------'+this.identityVerificationStatus);
    }
    VerificationMethod(){
        console.log('Inside verification method');
        doSubmit({ userid: '123456', appid: this.recordId, identityVerificationStatus: this.identityVerificationStatus})
      .then((result) => {
       console.log('result-----------'+JSON.stringify(result));
      })
      .catch((error) => {
       
      });
   }
  SubmitDetails()
  {
    console.log('Entered inside on click of submit ============>' + this.identityVerificationStatus );
    this.identityVerificationStatus=this.identityVerificationStatus;
    console.log('Entered inside on click of submit ====>22222============>' + this.identityVerificationStatus );
    UpdateStatus({ applicationId : this.recordId, status : this.identityVerificationStatus })
    .then((result) => {
      console.log('Updated Result-----------'+JSON.stringify(result));
     })
     .catch((error) => {
      
     });
     this.closeModel();
  }

}