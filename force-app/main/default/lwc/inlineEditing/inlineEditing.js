/*import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/InlineEditing.getContacts';
// Updateing the records using the UiRecordAPi
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
 
// columns
const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
    }, {
        label: 'FirstName',
        fieldName: 'FirstName',
        type: 'text',
        editable: true,
    }, {
        label: 'LastName',
        fieldName: 'LastName',
        type: 'text',
        editable: true,
    }, {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
        editable: true
    },
];
 
export default class InlineEditing extends LightningElement  {
    columns = columns;
    @track contacts;
    saveDraftValues = [];
 
    @wire(getContacts)
    contactData(result) {
        this.contacts = result;
        if (result.error) {
            this.contacts = undefined;
        }
    };
 
    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        console.log('this.saveDraftValues------------'+JSON.stringify(this.saveDraftValues));
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
         console.log('record input----------'+JSON.stringify(recordInputs));
        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.ShowToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }
      //show to notification like thank you or reacord is created like that
    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
                title: title,
                message:message,
                variant: variant,
                mode: mode
            });
            this.dispatchEvent(evt);
    }
 
    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.contacts);
    }
}   */
import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/InlineEditing.getContacts';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'FirstName', fieldName: 'FirstName', type: 'text', editable: true },
    { label: 'LastName', fieldName: 'LastName', type: 'text', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true },
];

export default class InlineEditing extends LightningElement {
    columns = columns;
    @track contacts;
    saveDraftValues = [];
    error;
    @track fullData;
    @wire(getContacts)
    contactData(result) {
        if (result.data) {
            this.fullData=result.data;
            console.log('result .data=========='+JSON.stringify(this.fullData));
            this.contacts = this.fullData.map(contact => ({ ...contact, isEditable: false }));
            console.error('Error in contactData:', JSON.stringify(result.error));

            this.error = undefined; // Reset the error if data is successfully retrieved
        } else if (result.error) {
            this.ShowToast('Error', 'An error occurred while fetching contacts.', 'error', 'dismissable');
            this.contacts = undefined;
            this.error = result.error;
        }
    }


    handleEditClick(event) {
        const contactId = event.currentTarget.dataset.id;
        this.contacts = this.contacts.map(c => ({
            ...c,
            isEditable: c.Id === contactId ? true : false
        }));
    }
    handleSaveClick(event) {
        const contactId = event.currentTarget.dataset.id;
        const contact = this.contacts.find(c => c.Id === contactId);

        const recordInput = { fields: { Id: contact.Id, FirstName: contact.FirstName, LastName: contact.LastName, Phone: contact.Phone } };
        const promises = [updateRecord(recordInput)];
        Promise.all(promises)
            .then(res => {
                this.ShowToast('Success', 'Record Updated Successfully!', 'success', 'dismissable');
                this.refresh();
            })
            .catch(error => {
                this.ShowToast('Error', 'An Error Occurred!', 'error', 'dismissable');
            })
            .finally(() => {
                this.contacts = this.contacts.map(c => ({ ...c, isEditable: false }));
            });
    }

    // handleFieldChange(event, contact, fieldName) {
    //     this.contacts = this.contacts.map(c => {
    //         if (c.Id === contact.Id) {
    //             return { ...c, [fieldName]: event.target.value };
    //         }
    //         return c;
    //     });
    // }

    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode,
        });
        this.dispatchEvent(evt);
    }

    async refresh() {
        await refreshApex(this.contacts);
    }
}