import { LightningElement, wire, track,api} from 'lwc';
import getCurrentUserRecords from '@salesforce/apex/RecentlyViewedContactsController.getCurrentUserRecords';
import recordInsert from '@salesforce/apex/RecentlyViewedContactsController.recordInsert';
import userIdMethod from '@salesforce/apex/RecentlyViewedContactsController.userId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import userrId from '@salesforce/user/Id';
import {refreshApex} from '@salesforce/apex';

export default class RecentlyViewedRecords extends LightningElement {

    columns = [{
        label: 'Broker',
        fieldName: 'Broker__c',
        sortable: true
    }, {
        label: 'Borrower',
        fieldName: 'Borrower__c',
        sortable: true
    }, {
        label: 'Residential Mortgage',
        fieldName: 'Name',
        sortable: true
    },
    {
        label: 'Loan Amount',
        fieldName: 'Loan_Amount__c',
        sortable: true
    },
    {
        label: 'LastViewedDate',
        fieldName: 'LastViewedDate',
        sortable: true
    },
    {
        label: 'Loan Status',
        fieldName: 'Loan_Status__c',
        type: 'Picklist',
        sortable: true
    },{
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Edit', name: 'edit' },
                { label: 'Delete', name: 'delete' },
                { label: 'Change Owner', name: 'change_owner' }
            ]
        }
    }];
    
    @api selectedRecord;
    @api objectName = 'Residential_Loan_Application__c';
    @track recordDataInsert = false; 
    @track updatePopUp = false;
    @track error;
    @track sortedBy;
    @track sortedDirection = 'asc';
    recentlyViewedRecords = [];
    currentUserdata = [];
    
    insertNewRecord() 
    {            
        this.recordDataInsert = true;
        console.log('Insert pop up');
    }
    customHideModalPopup() 
    {     
        this.recordDataInsert = false;
        this.updatePopUp = false;
        console.log('Insert pop up close');
    }
    // @wire(getCurrentUserRecords)
    // wiredRecords({ error, data }) 
    // {
    //     if (data) {
    //         // Update the data table with retrieved records
    //         this.recentlyViewedRecords = data;
    //         console.log('Data From Current User ===>',this.recentlyViewedRecords);
           
    //     } else if (error) {
    //         // Handle error
    //         console.log('Error In fetching Data From Current User ===>',JSON.stringify(error));
    //     }
    // }
    @wire(getCurrentUserRecords,{ userId: userrId })
    wiredRecords(result)
    {
        this.currentUserdata = result;
        console.log('userId===>',userrId);
        console.log('result in fetch user data ====>',JSON.stringify(result));
        console.log('result in fetch user data2 ====>',JSON.stringify(this.currentUserdata));
        if(result.data)
        {
            this.recentlyViewedRecords = result.data;
            console.log('result in fetch user data3 ====>',this.recentlyViewedRecords);
        }
        else if (result.error)
        {
            console.log('result in fetch user error ====>',JSON.stringify(error));
        }
        
    }
    handleSort(event) 
    {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
    sortData(fieldname, direction) 
    {
        let parseData = JSON.parse(JSON.stringify(this.recentlyViewedRecords));

        let keyValue = (a) => {
            return a[fieldname];
        };

        let isReverse = direction === 'asc' ? 1 : -1;

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.recentlyViewedRecords = parseData;
    }
    //drop down list on row action event 
    handleRowAction(event)
    {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log('actionName in handleRowAction===>',actionName);
        console.log('row in handleRowAction===>',JSON.stringify(row));
        switch (actionName)
        {
            case 'delete':
                this.deleteRecord(row);
                break;
            case 'edit':
                this.updateRecord(row);
                break;
            default:
                break;
        }
    }    
    deleteRecord(row)
    {   
        const recordId = row.Id;
        deleteRecord(recordId)
            .then(() => {
                console.log('recordId===>',recordId);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Reacord is Deleted!!',
                     message: 'thankYou!!',
                     variant: 'success'
                }));
                window.location.reload();
                //return refreshApex(this.currentUserdata);
            })
            .catch(error => {
                console.error('Error In deleting record=====>',JSON.stringify(error));
            });
    }
    
    handleSubmitUpdate(event) 
    {
        this.recordDataInsert = false;
        console.log('onsubmit event recordEditForm===>', event.detail.fields);
        this.updatePopUp = false;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Reacord is Updated!!',
             message: 'thankYou!!',
             variant: 'success'
        }));
        window.location.reload();
        //return refreshApex(this.currentUserdata);
        
    }
    updateRecord(row)
    {
        console.log('We Did In Edit Here');
        this.selectedRecord = row.Id;
        console.log('selectedRecord=====>',this.selectedRecord);
        this.updatePopUp = true;
        
    }
    @api editableFields=[];
    @wire(getObjectInfo, { objectApiName: '$objectName' })
        accountMetadata({ error, data }) {
            if (data) {
                const fieldInfos = data.fields;
                this.editableFields = Object.keys(fieldInfos)
                    .map(fieldApiName => fieldInfos[fieldApiName])
                    .filter(fieldInfo => fieldInfo.updateable)
                    .map(fieldInfo => ({ fieldApiName: fieldInfo.apiName }));
                    console.log('editableFields======>',this.editableFields);
            } else if (error) {
                console.log('error in data edit ====>',JSON.stringify(error));
            }
        }
    get rows()
    {
        const columnsPerRow = 2;
        const rows = [];
        for (let i = 0; i < this.editableFields.length; i += columnsPerRow) {
            const row = this.editableFields.slice(i, i + columnsPerRow);
            rows.push(row);
        }
        return rows;
    }

    @api fields = [];
    @track userId;
    @wire(recordInsert, { objectName: '$objectName' })
        wiredFields({ error, data }) {
            if (data) {
                this.fields = data;
                console.log('fields from apex for create===>',this.fields);
            } else if (error) {
                console.log('error field fetch for Insert====>',JSON.stringify(error));
            }
        }
    handleSubmitInsert(event) 
    {
            userIdMethod()
            .then(result=>{
                    this.userId=result;
                    console.log('userid----->',result);
                    console.log('OUTSIDE OF USERID METHOD=====>',this.userId);
                    const fieldsMap = event.detail.fields;
                    fieldsMap.Contact__c = this.userId;
                    console.log('fields====>',JSON.stringify(fieldsMap));
                    console.log('Contact__c========>',fieldsMap.Contact__c);
                    const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: 'Record created',
                    variant: 'success',
                    });
                    this.dispatchEvent(toastEvent);
                    return refreshApex(this.currentUserdata);
            })
            .catch(error=>{
                    console.log('error in userId===>',JSON.stringify(error));
                    console.error(error);
                    const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while creating the record',
                    variant: 'error',
                    });
                    this.dispatchEvent(toastEvent);
            })
        // if(this.userId!=null)
        // {
        //     // set the OwnerId field to the desired user ID
        //     this.template.querySelector('lightning-record-form').submit(fields)
        //     .then(() => {
        //         // Show a success message
        //         const toastEvent = new ShowToastEvent({
        //         title: 'Success',
        //         message: 'Record created',
        //         variant: 'success',
        //         });
        //         this.dispatchEvent(toastEvent);
        //         // Reset the form to create a new record
        //         this.template.querySelector('lightning-record-form').reset();
        //     })
        //     .catch(error => {
        //         // Handle errors
        //         console.error(error);
        //         const toastEvent = new ShowToastEvent({
        //         title: 'Error',
        //         message: 'An error occurred while creating the record',
        //         variant: 'error',
        //         });
        //         this.dispatchEvent(toastEvent);
        //     });
        // }
    }
    handleSuccess(event)
    {
        // Show a success message
        window.location.reload();
        const toastEvent = new ShowToastEvent({
        title: 'Success',
        message: 'Record created',
        variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }
    get fieldRows()
    {
        const columnsPerRow = 2;
                const fieldRows = [];
                for (let i = 0; i < this.fields.length; i += columnsPerRow) {
                    const row = this.fields.slice(i, i + columnsPerRow);
                    fieldRows.push(row);
                }
        return fieldRows;
    }
  

}