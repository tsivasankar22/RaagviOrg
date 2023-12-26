import { LightningElement , api, track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import serachAccs from '@salesforce/apex/SearchBar.getContactList';

const columns = [
   { label: "Name",
        type: "button",
        typeAttributes: { label: { fieldName: "Name" }, name: "gotoAccount", variant: "base" }
},
    { label: 'Id', fieldName: 'Id' }
];

export default class DynamicSearchInLWC extends NavigationMixin (LightningElement) {
    searchData;
    columns = columns;
    errorMsg = '';
    strSearchAccName = '';
     // data enter 
    handleAccountName(event) {
        console.log('handleAccount---->'+this.handleAccountName);
        this.errorMsg = '';
        this.strSearchAccName = event.currentTarget.value;
        console.log('handleAccountName'); 
    }
    handleClick(event) {
        if(event.detail.action.name==="gotoAccount")
    {
        this[NavigationMixin.GenerateUrl]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.row.Id,
                actionName: "view"
            }
        }).then((url) => {
            window.open(url, "_blank");
        });
    }  
    }
    handleSearch(event) 
    {
        if(!this.strSearchAccName) {
            this.errorMsg = 'Please enter account name to search.';
            this.searchData = undefined;
            return;
            window.console.log('handleSearch');
        }

         //searching data 
         //storing to searchdta result
         // strSearchAccName =this is in search bar entering  a words displaying 

        serachAccs({strAccName : this.strSearchAccName})
        .then(result => {
            this.searchData = result;
        })
        //if any mismatch name
        .catch(error => {
            this.searchData = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                   
                }
            }
        }) 
    }
}