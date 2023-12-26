import { LightningElement, wire,api,track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CONTACT_FIELD from '@salesforce/schema/Contact.Name';
//import ACCOUNT_FIELD from '@salesforce/schema/Contact.Account.Name';

export default class Tile extends LightningElement {
    @api recordId; // This is the Contact's record ID passed from the parent component

    // Declare the fields you want to retrieve
    @track contactName;
    @track accountName;

    // Wire method to retrieve data using LDS
    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_FIELD] })
    contactData({ error, data }) {
        if (data) {
            this.contactName = getFieldValue(data, CONTACT_FIELD);
            this.accountName = getFieldValue(data, ACCOUNT_FIELD);
        } else if (error) {
            // Handle error
        }
        console.log('contact name---------'+this.contactName);
        console.log('account name---------'+this.accountName);
    }
}