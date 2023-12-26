import { LightningElement,track,api,wire } from 'lwc';
import getAccount from '@salesforce/apex/CustomRecordDetailPage.getAccount';
export default class CustomRecordDetailPage extends LightningElement {
    @track account;
    @api recordId;
    @track clickValue=false;
    @track textField;
    @track outputfields=true;
    @track isEditEnabled=true;
    @track isEditDisabled = false;
    @wire(getAccount,{recordId:'$recordId'})
     wiredAccounts({ error, data }) {
       if (data) {
         this.account = data;
         this.error = undefined;
       } else if (error) {
         this.error = error;
         this.account = undefined;
       }
     }
    handleClick()
       {
          this.outputfields=false;
          this.clickValue = true; 
       }
    handleChange(event)
       {
           this.textField = event.target.value;
       }
       enableEditMouseOver() {
        console.log('hlo mouse over');
        this.isEditEnabled = false;
        this.isEditDisabled=true;
        console.log('true in enable');
    }
    enableEditOut() {
      console.log('hlo mouse Out');
        this.isEditDisabled = false;
        this.isEditEnabled=false;
        console.log('false in enable');
    }   
    disableEditMouseOver() {
        this.isEditEnabled = false;
        console.log('false in disable over');
    }
    disableEditOut() {
        this.isEditDisabled = false;
        console.log('false in disable out');
    }
}