import { LightningElement, wire,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFld from '@salesforce/schema/User.Name';
export default class Logout extends NavigationMixin(LightningElement){
    @track Home = false;
    @track Profile = false;
    @track Settings = false;
    @track FeedBack = false;
    @track LogOut = false;
    userId = Id;
    currentUserName;
    error;
    selectedItemValue;
    @wire(getRecord, { recordId: Id, fields: [UserNameFld]}) 
    userDetails({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
        } else if (error) {
            this.error = error ;
        }
    }

    handleOnselect(event) {
        this.selectedItemValue = event.detail.value;
        if (this.selectedItemValue == 'Home'){
            this.Home = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://rtsandbox-dev-ed.my.site.com/Project007/s/home'
                }
            })
        }else{
            this.Home = false;
        }

        if (this.selectedItemValue == 'Profile'){
            this.Profile = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://rtsandbox-dev-ed.my.site.com/Project007/s/userprofile'
                }
            })
        }else{
            this.Profile = false;
        }

        if (this.selectedItemValue == 'Settings'){
            this.Settings = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://raagvitech172-dev-ed.lightning.force.com/lightning/settings/personal/PersonalInformation/home'
                }
            })
        }else{
            this.Settings = false;
        }
        if (this.selectedItemValue == 'FeedBack'){
            this.FeedBack = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://www.salesforce.com/in/company/feedback/'
                }
            })
        }else{
            this.FeedBack = false;
        }
        if (this.selectedItemValue == 'LogOut'){
            this.LogOut = true;
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://rtsandbox-dev-ed.my.site.com/Project007/secur/logout.jsp'
                }
            })
        }else{
            this.LogOut = false;
        }
    }

}