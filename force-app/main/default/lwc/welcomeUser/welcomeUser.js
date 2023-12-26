import { LightningElement,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFld from '@salesforce/schema/User.Name';

export default class WelcomeUser extends NavigationMixin(LightningElement) {
    userId = Id;
    currentUserName;
    error;

    @wire(getRecord, { recordId: Id, fields: [UserNameFld]}) 
    userDetails({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
        } else if (error) {
            this.error = error ;
        }
    }

    handleClick(event) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://rtsandbox-dev-ed.my.site.com/Project007/s/home'
                }
            })
        }

}