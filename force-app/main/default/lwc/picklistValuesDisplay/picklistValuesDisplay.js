import { LightningElement, wire, api,track } from 'lwc';
import getPicklistValues from '@salesforce/apex/PicklistValuesController.getPicklistValues';
import updateFields from '@salesforce/apex/PicklistValuesController.updateField';
const PICKLIST_FIELDS = ['RF_1_1__c', 'RFS2__c', 'User_Department__c', 'Originator__c'];

export default class PicklistValuesDisplay extends LightningElement {
    @api recordId;
  //  selectedValues = {};
    picklistValues = {};
    transformedData;
    @track saveButton=false;

    @track fieldPickListVAlues;

    get fieldNames() {
        return PICKLIST_FIELDS;
    }

    @wire(getPicklistValues, { objectName: 'Contact', fieldNames: '$fieldNames' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            console.log('record id--------'+this.recordId);
            this.picklistValues = data;
        console.log('pick data------------'+JSON.stringify(this.picklistValues));
            this.fieldPickListVAlues = Object.keys(data).map(fieldName => {
                return {
                    fieldName,
                    options: data[fieldName]
                };
            });
            console.log('hlo data---------------'+JSON.stringify(this.fieldPickListVAlues));
            const fieldValue = this.fieldPickListVAlues;
            this.transformedData = fieldValue.map(item => {
                return {
                  fieldName: item.fieldName,
                  options: item.options.map(option => ({
                    label: option,
                    value: option 
                  }))
                };
              });
              console.log('transformedData data---------------'+JSON.stringify(this.transformedData));
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }
    selectedValues = {};
handleChange(event) {
    console.log('hlo');
    this.saveButton=true;
    const fieldName = event.target.dataset.fieldname;
    console.log('field name-------'+fieldName);
    const selectedValue = event.detail.value;
    console.log('log-------'+selectedValue);
     // Replace the selected value for the field
     if (selectedValue !== null && selectedValue !== undefined) {
        this.selectedValues[fieldName] = selectedValue;
    } 
    console.log('Selected values: ', this.selectedValues);
}
handleClick(){
    updateFields({ recordId: this.recordId, fieldValues: this.selectedValues })
    .then(result => {
        // Handle success or error
        console.log('Fields updated successfully:', result);
        this.saveButton=false;
       // eval("$A.get('e.force:refreshView').fire();");
    })
    .catch(error => {
        console.error('Error updating fields:', error);
    });

}
}
