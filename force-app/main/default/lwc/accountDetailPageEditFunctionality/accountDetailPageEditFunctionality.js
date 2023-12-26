import { LightningElement, api, track} from 'lwc';
// import fetchRecordDetails from '@salesforce/apex/AccountDetailPageComponentEditFunction.getAccountRecordMethod';
// import updateAccount from '@salesforce/apex/AccountDetailPageComponentEditFunction.updateAccount';
import fetchRecordDetails from '@salesforce/apex/AccountDetailPageComponentEditFunction.taskCode';
import updateAccount from '@salesforce/apex/AccountDetailPageComponentEditFunction.updateTask';
import { RefreshEvent } from 'lightning/refresh';
import { refreshApex } from '@salesforce/apex';
export default class AccountDetailPageEditFunctionality extends LightningElement {
    @api recordId;
    @track accountRecord;
    @track isEditing = false;
    @track editedFields = {};
    @track wiredResult;
    // Add your ratingOptions definition here if it's not already defined
    connectedCallback() {
        this.loadAccountData();
    }
    loadAccountData() {
        // Fetch the account record data using Apex
        // Replace 'fetchAccountDetails' with your Apex method name
        console.log('calling main fetching data');
        fetchRecordDetails({ recordIdAccount: this.recordId })
            .then(data => {
                this.accountRecord = data;
                console.log('inside fetched data--------'+JSON.stringify(this.accountRecord));
                this.wiredResult = data;
            })
            .catch(error => {
                console.error('Error loading account data:', error);
            });
    }
    handleEditClick() {
        // Enter edit mode
        this.isEditing = true;
        //Initialize the editedFields object with the current values
        this.editedFields = { ...this.accountRecord };
    }
    handleFieldChange(event) {
        // Capture field changes and update the editedFields object
        const fieldName = event.target.label;      
        const fieldValue = event.target.value;     
        this.editedFields[fieldName] = fieldValue;
        console.log('field', this.editedFields[fieldName]);
    }
    handleSaveClick() {
        // Call an Apex method to update the account record with editedFields
        updateAccount({ recordId: this.recordId, fieldsToUpdate: this.editedFields })
            .then(result => {
                // Handle successful save
                console.log('edited fields------------'+JSON.stringify(this.editedFields));
                console.log('Account updated successfully:', result);
                this.isEditing = false;
               // let refreshWiredResult = this.wiredResult;
               // this.dispatchEvent(new RefreshEvent());
               // refreshApex(refreshWiredResult);
                // setTimeout(() => {
                //   eval("$A.get('e.force:refreshView').fire();");
              //  }, 1000);
               console.log('after refresh ');
              //  this.loadAccountData(); 
                this.accountRecord=this.editedFields;
                console.log('account data in update task ----------'+JSON.stringify(this.accountRecord));              
            })
            .catch(error => {
                // Handle error
                console.error('Error updating account:', error);
            });
    }
}
