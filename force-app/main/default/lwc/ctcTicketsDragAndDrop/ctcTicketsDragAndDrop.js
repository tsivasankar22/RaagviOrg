import { LightningElement, wire, api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecentlyViewedRecords } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import RESIDENTIAL_LOAN_OBJECT from '@salesforce/schema/Residential_Loan_Application__c';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Broker', fieldName: 'Broker__c', type: 'text' },
    { label: 'Borrower', fieldName: 'Borrower__c', type: 'text' },
    { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency' },
    { label: 'Loan Status', fieldName: 'Loan_Status__c', type: 'text' },
    { label: 'Rate', fieldName: 'Rate__c', type: 'percent' },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
    { label: 'Last Modified By', fieldName: 'LastModifiedById', type: 'text' },
    { label: 'Last Viewed Date', fieldName: 'LastViewedDate', type: 'date' }
];

export default class RecentlyViewedRecords extends LightningElement {
    @api recordId;
    @api objectApiName;

    selectedRecordType;
    recordTypes = [];
    data;
    columns = COLUMNS;
    sortedBy;
    sortedDirection;
    refreshTable;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: 'Residential_Loan_Application__c.Record_Type__c' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.recordTypes = [{ label: 'All', value: '' }, ...data.values.map((value) => ({ label: value.label, value: value.value }))];
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getRecentlyViewedRecords, { objectApiName: '$objectApiName' })
    wiredRecentlyViewedRecords({ error, data }) {
        if (data) {
            this.data = data.records.map(record => {
                return {
                    Id: record.Id,
                    Name: record.Name,
                    Broker__c: record.Broker__c,
                    Borrower__c: record.Borrower__c,
                    Loan_Amount__c: record.Loan_Amount__c,
                    Loan_Status__c: record.Loan_Status__c,
                    Rate__c: record.Rate__c,  
                    LastModifiedDate: record.LastModifiedDate,
                    LastModifiedById: record.LastModifiedById,
                    LastViewedDate: record.LastViewedDate
                };
            });
        } else if (error) {
            console.error(error);
        }
    }

    handleRecordTypeChange(event) {
        this.selectedRecordType = event.detail.value;
        this.filterData();
    }

    filterData() {
        let filteredData = this.data;
        if (this.selectedRecordType) {
            filteredData = filteredData.filter(record => record.Deal_Type__c === this.selectedRecordType);
        }
        this.data = filteredData;
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData();
    }

    sortData() {
        let sortResult = Object.assign([], this.data);
        sortResult = sortResult.sort((a, b) => {
            let aFieldValue = a[this.sortedBy] ? a[this.sortedBy].toLowerCase() : '';
            let bFieldValue = b[this.sortedBy] ? b[this.sortedBy].toLowerCase() : '';
            let direction = this.sortedDirection === 'asc' ? 1 : -1;
            return aFieldValue > bFieldValue ? direction : -direction;
        });
        this.data = sortResult;
    }

    handleRowAction(event) {
        const recordId = event.detail.row.Id;
        const navigateEvent = new CustomEvent('navigate', {
            detail: {
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    objectApiName: 'Residential_Deals__c',
                    actionName: 'view'
                }
            }
        });
        this.dispatchEvent(navigateEvent);
    }
}