import { LightningElement,wire,api,track } from 'lwc';
import getDataOfFA from '@salesforce/apex/RecordDetailsEditDIsplaydata.getDataOfFA';
export default class RecordDetailsEachField extends LightningElement {
    @api recordId;
    @track recId;
    @track recData;
    @track editedFields;
    connectedCallback(){
    //this.recId=this.recordId;
    console.log('recID-----------'+this.recId);
    }
    handleFieldChange(event){
        const fieldName=event.target.label;
        const fieldValue=event.target.value;
        this.editedFields[fieldName]=fieldValue;    
    }
    @wire(getDataOfFA, {recordId:'$recordId'})
    WiredDAta({data, error}){
        if(data){
            this.recData = data;
            console.log('data-------------'+JSON.stringify(data));
            this.editedFields={...this.recData};
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
}