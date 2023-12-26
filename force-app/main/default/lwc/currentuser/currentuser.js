import { LightningElement,track,wire } from 'lwc';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFld from '@salesforce/schema/User.Name';
import UserUserNameFld from '@salesforce/schema/User.Username';
import userEmailFld from '@salesforce/schema/User.Email';
import UserPhoneFld from '@salesforce/schema/User.Phone';

import updateUserDetails from '@salesforce/apex/currentUserController.updateUserDetails';

export default class Currentuser extends LightningElement {
    currentPhone;
    userId = Id;
    currentUserName;
    currentUserUserName;
    currentUserPhone;
    currentUserEmailId;
    error;
    @track isDisabledsave = false;
    @track isDisabled = true;
    @track saveModelPopUp = false;
    
    @wire(getRecord, { recordId: Id, fields: [ UserNameFld, UserUserNameFld, UserPhoneFld, userEmailFld ]}) 
    userDetails({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
            this.currentUserEmailId = data.fields.Email.value;
            this.currentUserPhone = data.fields.Phone.value;
            this.currentUserUserName = data.fields.Username.value;
            
            
            console.log( 'Name>>>>>>',data.fields.Name.value);
            console.log( 'Email>>>>>>',data.fields.Email.value);
            console.log( 'Phone>>>>>>',data.fields.Phone.value);
            console.log( 'Username>>>>>>',data.fields.Username.value);


        } else if (error) {
            this.error = error ;
        }
    }

    closeModal()
    {
        this.isDisabled = true;
        this.isDisabledsave = false;
        this.saveModelPopUp = false;
    }

    handleEdit(){
        this.isDisabled = false;
        this.isDisabledsave = true;
        this.saveModelPopUp = true;
    }

    handlesave(event){
        updateUserDetails({userId : this.userId, Phone : this.currentPhone})
       .then((result) => {

            if(result)
            {
                console.log('handle save data');
                console.log('update--->',JSON.stringify(result));
            }
            this.isDisabledsave = false;
            this.isDisabled = true;
            this.saveModelPopUp = false;
       })
       .catch((error)=> {
            this.error = error;
            console.log('notupdate--->'+JSON.stringify(error));
       })
    }
    
    changePhone(event)
    {
        this.currentPhone = event.target.value;
        console.log('changePhone>>>>>',this.currentPhone);

    }
}