import { LightningElement , wire, track,api} from 'lwc';
import sortDealsItem from '@salesforce/apex/ResidentialDeals.sortDealsItem';
import { NavigationMixin } from 'lightning/navigation';
import filterDeals from '@salesforce/apex/ResidentialDeals.filterDeals';
const columns = [
    {
        label: 'Broker',
        sortable: "true",
        type: "button",
        typeAttributes: { label: { fieldName: "Broker__c" }, name: "gotoAccount", variant: "base" 
    }
    }, {
        label: 'Borrower',
        sortable: "true",
        type: "button",
        typeAttributes: { label: { fieldName: "Borrower__c" }, name: "gotoAccount", variant: "base" 
    }
    }, {
        label: 'Residential Mortgage',

        sortable: "true",  
        type: "button",
        typeAttributes: { label: { fieldName: "Name" }, name: "gotoAccount", variant: "base" 
},
    }, 
    {
      label: 'Loan Amount',
      fieldName: 'Loan_Amount__c',
      sortable: "true"
  },
  {
    label: 'LastViewedDate',
    fieldName: 'LastViewedDate',
    sortable: "true"
},
    {
        label: 'Loan Status',
        fieldName: 'Loan_Status__c',
        type: 'Picklist',
        sortable: "true"
    }, 
];
export default class LwcSortingDataTable extends  NavigationMixin(LightningElement){
    @track data=[];
    @track columns = columns;
    @track sortBy;
    @track DealsData;
    @track sortDirection;
    dealsName='';
     selectedData =null;
     //filters picklist values label and recently viewed label
    get dataOptions() {
        return [
            { label: 'Application', value: 'Application'},
            { label: 'Commitment', value: 'Commitment'},
            { label: 'Active', value: 'Active'},
            { label: 'All Deals', value: 'All Deals'},
            { label: 'Paid Out', value: 'Paid Out'},
            { label: 'Void', value: 'Void'},
            { label: 'Cancelled', value: 'Cancelled'},
            { label: 'Decline', value: 'Decline'},
            {label: 'RecentlyViewed', value: 'RecentlyViewed'}
        ];
    }
    //filters onchange event
    handleDataChange(event){
        this.selectedData = event.target.value;
        console.log('selected data===========',this.selectedData);
        filterDeals({filterView : this.selectedData})
        .then(result => {
        let a=result;
            this.data = result;
           
        })
        .catch(error => {
            this.error = error;
        });
    }
    //wire property on load show the current user having any records and search bar functionaly
    @wire (sortDealsItem, {filterView:'$selectedData' ,dataDisplay: '$dealsName' })
    accounts(result) {
        if (result.data) {
            this.data = result.data;
            console.log('selected dataa=====in filters ',JSON.stringify(this.data));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
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
           
            return isReverse * ((x > y) - (y > x));// 1 if x is greater than y, -1 if y is greater than x, or 0 if they are equal.
        });
        
        this.data = parseData;
    }
    //search functionality event
    handleSearchDeals(event){
      this.dealsName = event.target.value;
      console.log('search data===========',this.dealsName);
    }
    @track recID;
   //row action in data table and navigation to record detail page
    handleonrowchange(event) {
        if(event.detail.action.name==="gotoAccount")
        
       // console.log(event.detail.row.Id,'secounf if');
          this.recID=event.detail.row.Id;
        //  console.log(this.recName,'this.recName================== ');
         // console.log('i am in a after if condition');
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://raagvitech77-dev-ed.my.site.com/s'+'/deal-detail-page/'
               //url: 'https://raagvitech77-dev-ed.my.site.com/s'+'/residential-loan-application/'+this.recID
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }
}
}