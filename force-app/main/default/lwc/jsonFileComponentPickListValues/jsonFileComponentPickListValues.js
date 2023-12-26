import { LightningElement, track } from 'lwc';
import StaticResourceJsonFile from "@salesforce/resourceUrl/JSONFileFormat";
export default class JsonFileComponentPickListValues extends LightningElement {
    @track data;
    @track textFields = [];//value for label crn file
    @track picklistFields = {};
    @track ConcessionAuthorityData;//values for concession authority
    @track cardTypeOptions = [];
    @track picklistFieldsArray = [];

    connectedCallback() {
        fetch(StaticResourceJsonFile)
            .then(response => response.json())
            .then(jsonData => {
                this.data = jsonData;
                this.ConcessionAuthorityData = this.data.ConcessionAuthority;
                console.log(' this.ConcessionAuthorityData------------'+JSON.stringify(this.ConcessionAuthorityData));
                this.data.fields.forEach(field => {
                    if (field.FieldType === 'text') {
                        this.textFields.push(field);
                        console.log('textField',JSON.stringify( this.textFields));




                    } else if (field.FieldType === 'combobox') {
                        if (field.Name === 'Concession Authority') {
                            
                            this.picklistFields[field.Name] = {
                                ...field,
                                options: this.ConcessionAuthorityData.authority,
                                // this.getConcessionAuthorityOptions()
                            };




                            
                            console.log('this.picklistFields----------',JSON.stringify(this.picklistFields));
                            console.log('consession options----------',JSON.stringify(this.ConcessionAuthorityData.authority));
                        } else if (field.Name === 'Card Type') {
                            this.picklistFields[field.Name] = {
                                ...field,
                                options: this.cardTypeOptions
                            };
                        }
                        this.picklistFieldsArray = Object.values(this.picklistFields);
                         
                      
                        console.log('console0----------',JSON.stringify(this.picklistFields[field.Name]));
                    }
                });
            })
            .catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
    }

    getConcessionAuthorityOptions() {
        if (this.ConcessionAuthorityData && this.ConcessionAuthorityData.authority) {
            return this.ConcessionAuthorityData.authority.map(item => ({
                label: item.label,
                value: item.value
            }));
        }
        return [];
    }

    getCardTypeOptions(selectedAuthority) {
        if (selectedAuthority && this.data.cardType[selectedAuthority]) {
            return this.data.cardType[selectedAuthority].map(item => ({
                label: item.label,
                value: item.value
            }));
        }
        return [];
    }

    handleTextChange(event) {
        // Handle text field changes if needed
        console.log('Text Field Changed:', event.target.value);
    }
 
    handleComboChange(event) {
        const fieldName = event.target.dataset.fieldname;
        const selectedValue = event.detail.value;
        if (fieldName === 'Concession Authority') {
            this.cardTypeOptions = this.getCardTypeOptions(selectedValue);
            this.picklistFields['Card Type'].options = this.cardTypeOptions;
        }
    }
}
