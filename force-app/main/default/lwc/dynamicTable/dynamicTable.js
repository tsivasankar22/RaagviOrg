import { LightningElement,track, api} from 'lwc';
import getTableInfo from '@salesforce/apex/DynamicTableController.getTableInfo';
import updateAcc from '@salesforce/apex/DynamicTableController.updateAcc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class DynamicTable extends LightningElement {
    isSpinnerShow = false;
    @api recordId;
    
    updatedList;
    @api sObjectName;
    sObjectData = [];
    sObjectColumns = [];
    sObjectPluralLabel;
    totalRecords = 0;
    error;
    @track recId=[];
    changedFields = {};
    @api condition;
   
    connectedCallback() {
        // Call the getCompleteData function
        this.getCompleteData();
    };
    wiredActivities;
    // Fetch all data
    getCompleteData() {
        this.error = '';
        this.isSpinnerShow = true;
        console.log(this.sObjectName);
        console.log('recordId ==>',this.recordId);
        let relatedId = this.recordId
        // Call Apex method getTableInfo and pass the sObjectName parameter
        getTableInfo({'sObjectName': this.sObjectName ,'condition':this.condition ,'recId':relatedId})
            .then(result => {
                console.log(result);

                if(result){
                    // Setting values for sObjectColumns, sObjectPluralLabel, and sObjectData
                    this.sObjectColumns = result.columns;
                    this.sObjectPluralLabel = result.sObjectPluralLabel;
                    this.sObjectData = JSON.parse(result.tableData);
                    this.totalRecords =  this.sObjectData.length;
                    console.log(JSON.parse(result.tableData));
                }
                // Setting spinner variable to false after data is received
                this.isSpinnerShow = false;
            })
            .catch(error => {
                // Handling errors and setting the error variable
                this.error = error;
                console.log(JSON.stringify(error));
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.error = error.body.message;
                }
                // Setting spinner variable to false after error is received
                this.isSpinnerShow = false;
            });
    } 
    @track fieldNames=[]
    handleCustomEvent(event) {
    const { recordId, fieldName, newValue } = event.detail;
        console.log('Record Id: ', recordId);
        console.log('Field Name: ', fieldName);
        console.log('New Value: ', newValue);
    
        // Add the field name to the array of edited field names
        this.fieldNames.push(fieldName);
        this.recId.push(recordId);
        console.log('rec id', this.recId);
        let changedFields = { ...this.changedFields };
        let recordChanges = changedFields[recordId] || {};
        console.log('recordId==>',recordId);
        recordChanges[fieldName] = newValue;
        changedFields[recordId] = recordChanges;
        this.changedFields = changedFields;
    
        console.log('changes===>',this.changedFields);



    }

    handleSave() {
         const recordData = {};
       
// Initialize the result object
let result = {};

// Build the field-to-key mapping based on the fieldNames array
const FIELD_TO_KEY_MAP = {};
this.fieldNames.forEach(fieldName => {
    // Map the field name to a lowercase key with the same name
    FIELD_TO_KEY_MAP[fieldName] = fieldName;
});

// Iterate through each record ID in changedFields
for (let recordId in this.changedFields) {
    // Get the record changes for this ID
    let recordChanges = this.changedFields[recordId];

    // Initialize the result for this record ID with the ID itself
    let recordResult = { Id: recordId };

    // Iterate through each field in the record changes
    for (let fieldName in recordChanges) {
        let newValue = recordChanges[fieldName];

        // Look up the appropriate key for this field
        let key = FIELD_TO_KEY_MAP[fieldName];

        // If there's no mapping for this field, skip it
        if (!key) {
            continue;
        }

        // Set the value in the record result
        recordResult[key] = newValue;
    }

    // Add the record result to the overall result object
    result[recordId] = recordResult;
}

// Now the result object should have the format you're looking for
    console.log('Result: ', result);
   
        updateAcc({ acc: result, recordIds: this.recId, sObjectName: this.sObjectName})
        .then(result => {
            console.log('result---------------',result);
            console.log('i am in updated');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records updated',
                    variant: 'success'
                })
            )
        })
        setTimeout(() => {
        eval("$A.get('e.force:refreshView').fire();");}, 1000);
    }
    
    @api fieldsToUpdate;

    handleCancel()
    {
        //return refreshApex(this.wiredActivities);
         console.log('i am in cancel');
         //location.reload();
         setTimeout(() => {
         eval("$A.get('e.force:refreshView').fire();");}, 1000);
        // location.reload();
      }
      SaveCance = false;
      handleShowButtons(event) {
        this.SaveCance = event.detail;
        console.log('SaveCance---------',this.SaveCance);
    }

}