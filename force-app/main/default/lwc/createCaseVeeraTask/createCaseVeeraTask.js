 import { LightningElement, track, wire } from 'lwc';
import getAccountPicklistFields from '@salesforce/apex/AccountControllerVeeraTask.getAccountPicklistFields';

export default class CreateCaseVeeraTask extends LightningElement {
    @track createCaseButton = true;
    @track mobileServices = false;
    @track mobileServicesData = []; 
    @track descriptionValue = ''; 
    @track picklistFields;
    @track selectedField;
    @track clonedRowFields = [];
    @track clonedRows = [];
    transformedData;

    columns = [
        { label: 'Field Name', fieldName: 'fieldName', type: 'text' },
        { label: 'Field Label', fieldName: 'fieldLabel', type: 'text' },
        {
            label: 'Actions',
            type: 'action',
            initialWidth: 150,
            typeAttributes: {
                rowActions: [
                    {
                        label: 'Clone',
                        name: 'clone',
                        iconName: 'utility:copy'
                    },
                    {
                        label: 'Delete',
                        name: 'delete',
                        iconName: 'utility:delete'
                    }
                ],
                variant: 'base',
                title: 'Actions'
            }
        },
        {
            label: 'Picklist Values',
            fieldName: 'picklistValues',
            type: 'text'
        }
    ];

    handleClick() {
        this.createCaseButton = false;
        this.mobileServices = true;
        this.loadPicklistFields();
    }
    @track fieldPickListVAlues;
    loadPicklistFields() {
        getAccountPicklistFields()
            .then(result => {
                console.log('result=============' + JSON.stringify(result));
                this.picklistFields = result;
    
                this.fieldPickListVAlues = result.map(item => ({
                    fieldName: item.fieldName,
                    fieldLabel: item.fieldLabel,
                    options: item.picklistValues.map(picklistValue => ({
                        label: picklistValue,
                        value: picklistValue
                    }))
                }));
    
                console.log('hlo data---------------' + JSON.stringify(this.fieldPickListVAlues));
    
                const fieldValue = this.fieldPickListVAlues;
                this.transformedData = fieldValue.map(item => ({
                    fieldName: item.fieldName,
                    fieldLabel: item.fieldLabel,
                    options: item.options.map(option => ({
                        label: option.label,
                        value: option.value
                    }))
                }));
    
                console.log('transformedData data---------------' + JSON.stringify(this.transformedData));
            })
            .catch(error => {
                console.error('Error fetching picklist fields:', error);
            });
    }
    selectedValues = {};
    handleChange(event) {
        console.log('hlo');
        const fieldName = event.target.dataset.fieldname;
        console.log('field name-------'+fieldName);
        const selectedValue = event.detail.value;
        console.log('selectedValue-------'+selectedValue);
         // Replace the selected value for the field
         if (selectedValue !== null && selectedValue !== undefined) {
            this.selectedValues[fieldName] = selectedValue;
        } 
        console.log('Selected values: ', this.selectedValues);
          this.selectedField = fieldName;
          console.log('this.selectedField----------'+JSON.stringify(this.selectedField));

    }
    handleClone() {
        const clonedRow = { ...this.selectedValues };
        this.clonedRows.push({
            values: this.getClonedRowFields(clonedRow),
        });

        // Update picklist values based on the cloned row
        this.updatePicklistValues(clonedRow);

        // Reset the selected values for the next clone
        this.selectedValues = {};
    }
    updatePicklistValues(clonedRow) {
        // You need to implement this logic based on your data structure
        // For example, if picklistValues is an array, you can push the cloned values.
        // If it's an object, you might need to merge the values.

        // Example assuming picklistValues is an array
        this.picklistValues.push(clonedRow);

        // Make sure to trigger a re-render to reflect the changes in the template
        this.picklistValues = [...this.picklistValues];
    }
    getClonedRowFields(clonedRow) {
        // Convert clonedRow object to an array of { name, value } objects
        return Object.entries(clonedRow).map(([name, value]) => ({ name, value }));
    }
    get transformedDataWithValues() {
        return this.transformedData.map(item => ({
            ...item,
            selectedValue: this.selectedValues[item.fieldName] || '',
        }));
    }
    get selectedValueForField() {
        return this.selectedValues[this.selectedField];
    }
}  
