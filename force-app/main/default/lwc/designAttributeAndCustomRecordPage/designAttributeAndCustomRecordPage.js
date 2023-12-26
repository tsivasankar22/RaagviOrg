import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchRecs from '@salesforce/apex/DesignAttributeAndCustomRecordPage.fetchRecs';
import getRelatedObjectCounts from '@salesforce/apex/DesignAttributeAndCustomRecordPage.getRelatedObjectCounts';
export default class DesignAttributeAndCustomRecordPage extends NavigationMixin(LightningElement) {
  @api Fields;
  @api NumberOfRecords;
  @api recordId;
  relatedRecords;
  relatedObjectCounts=[]
  @api ObjectName;
  @track listRecs = [];
  @track dataTableList=true;
  @track mode="View"
  @track columns = [];
  @track draftValues = [];
  @track relatedObjectRecords=false;
  connectedCallback() {
    console.log('cc objects and fields');
    // Dynamically generate columns based on object and fields
    if (this.Fields && this.ObjectName && this.NumberOfRecords) {
    //  console.log();
      // map is used to convert this into an array of objects that contain a label, field name, type, and editable properties
      this.columns = this.Fields.split(',').map((fieldName) => {
        let column = {
          label: fieldName,
          fieldName: fieldName.trim(), //trim is used to remove the white spaces of both sides
          type: 'text',
        };

        // Set typeAttributes for Name field
        if (fieldName === 'Name') {
          column.type = 'button';
          column.typeAttributes = {
            label: { fieldName: 'Name' },
            name: 'view_record',
            title: 'Click to View',
            variant: 'base',
          };
        }
        return column;
      });

      // Call the Apex method to fetch the records
      this.fetchRecords();
    }
  }

  handleRowAction(event) {
    console.log('i am in a row action');
    if (event.detail.action.name === 'view_record') {
      this.recordId = event.detail.row.Id;
      console.log('recor d id========', this.recordId);
      this.dataTableList = false;
      this.relatedObjectRecords = true;
      console.log('i am in a true or false');
      
      getRelatedObjectCounts({ objName: this.ObjectName, recordId: this.recordId })
        .then((result) => {
      
        this.relatedObjectCounts = Object.entries(result).map(([name, count]) => ({
            name,
            count
        }));
        console.log('relatedObjectCounts==========='+ JSON.stringify(this.relatedObjectCounts) );
        })
        .catch((error) => {
          this.relatedObjectCounts = null;
          console.log(error);
        });
    }
  }

  fetchRecords() {
    // Call the Apex method to fetch the records
    // Pass the object name and fields as parameters
    fetchRecs({ objName: this.ObjectName, fields: this.Fields, NumberOfRecords: this.NumberOfRecords })
      .then((result) => {
        this.listRecs = JSON.parse(JSON.stringify(result));
        console.log('listrecs========', JSON.stringify(this.listRecs));
      })
      .catch((error) => {
        this.listRecs = null;
        console.log(error);
      });
  }
}