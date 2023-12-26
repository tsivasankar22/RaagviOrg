import { LightningElement,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class NavigationToPagesExample extends NavigationMixin(LightningElement){
    @track UserDetails = false;
    @track ContactDetails = false;
    @track FeedBackDetails = false;
    @track LogOutDetails = false;

    selectedItemValue;

    handleOnselect(event) {
        this.selectedItemValue = event.detail.value;

        if (this.selectedItemValue == 'User'){
            this.UserDetails = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'http://salesforce.com'
                }
            }) 
        }else{
            this.UserDetails = false;

        }
       
        if (this.selectedItemValue == 'Contact Us'){
            this.ContactDetails = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'http://salesforcelogin.com'
                }
            })
           
        }else{
            this.ContactDetails = false;
        }
        
        if (this.selectedItemValue == 'FeedBack'){
            this.FeedBackDetails = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'http://salesforce.com'
                }
            })  
        }else{
            this.FeedBackDetails = false;
        }
        if (this.selectedItemValue == 'LogOut'){
            this.LogOutDetails = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'http://salesforce.com'
                }
            })  
        }else{
            this.LogOutDetails = false;
        }

    }
    
}