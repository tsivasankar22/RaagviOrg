import { LightningElement , wire, track } from 'lwc';
import sortDealsItem from '@salesforce/apex/CTC_ResidentialDealsSearchBar.sortDealsItem';
const columns = [
    {
        label: 'Broker',
        fieldName: 'Broker__c',
        sortable: "true"
    }, {
        label: 'Borrower',
        fieldName: 'Borrower__c',
        sortable: "true"
    }, {
        label: 'Residential Mortgage',
        fieldName: 'Name',
        sortable: "true"
    }, 
    {
      label: 'Loan Amount',
      fieldName: 'Loan_Amount__c',
      sortable: "true"
  },
  {
    label: 'Rate',
    fieldName: 'Rate__c',
    sortable: "true"
  },
    {
        label: 'Loan Status',
        fieldName: 'Loan_Status__c',
        type: 'Picklist',
        sortable: "true"
    },  
];
export default class Ctc_residendialDealsSearchBar extends LightningElement {
    @track data=[];
    @track showViewMore=true;
    @track columns = columns;
    @track sortBy;
    @track DealsData;
    @track sortDirection;
    @track displayAllData=false;
    dealsName='';
     selectedData =null;
   @track initiallData;
    //wire property on load show the current user having any records and search bar functionaly
    @wire (sortDealsItem, {dataDisplay: '$dealsName',ObjName:'$objNam' })
    accounts(result) {
        if (result.data) {
            if(this.showViewMore==true){
                this.initiallData = result.data; 
              
                this.data=this.initiallData.slice(0, 10);
                console.log('length in wire',this.data.length)
                if(this.data.length<10){
                    this.showViewMore = false
                }
                else this.showViewMore = true
            } else if (result.error) {
                this.error = result.error;
                this.data = undefined;
            }
            console.log('data in wire========>>>>>',JSON.stringify(this.data)); 
        } 
    }
    //sorting the data table event
    handleSortDealsData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;       
        this.SortDealsData(event.detail.fieldName, event.detail.sortDirection);
        //The SortDealsData function passing the fieldName and sortDirection values as arguments.
    }
    SortDealsData(fieldname, direction) {   
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
       let isReverse = direction === 'asc' ? 1: -1; // 1 is the asc and -1 is the des order
           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // the function compares the x and y objects based on the value of their fieldname property, and multiplies the result by isReverse to account for the sort direction.
            y = keyValue(y) ? keyValue(y) : ''; 
            return isReverse * ((x > y) - (y > x)); // 1 if x is greater than y, -1 if y is greater than x, or 0 if they are equal.
        });  
        this.data = parseData;
    }
    //search functionality event
    handleSearchDeals(event){
      this.dealsName = event.target.value;
      console.log('search data===========',this.dealsName);
      if(this.dealsName == null || this.dealsName ==''){
        this.displayAllData=false;
      }
      else{
        this.displayAllData=true;
      }
    }
    @track objNam;
    //tabset functionality
    handleTabChange(event)
    {
        this.objNam = event.target.value;
        console.log('objName=====>',this.objNam);  
        console.log('handle tab data===>  ',JSON.stringify(this.data.length)) 
        this.showViewMore = true    
        
    } 
     //view all button functionality 
    handleViewMore(){ 
        this.showViewMore=false;
        console.log('i am in a button evenmt');
        this.data=this.initiallData;
        console.log('this.data in handle more==>  ',this.data.length)
    }
}