import { LightningElement,track} from 'lwc';
import Buttons from '@salesforce/apex/ValidationButtons.Buttons';
import NAME_FIELD from '@salesforce/schema/RegistractionForm__c.Name';
import EMAIL_FIELD from '@salesforce/schema/RegistractionForm__c.Email__c';
import CONFIRMEMAIL_FIELD from '@salesforce/schema/RegistractionForm__c.Confirm_Email__c';
import CHECKBOX_FIELD from '@salesforce/schema/RegistractionForm__c.Approved__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Raagvitech extends LightningElement {
    label={Raagvitech};

    @track customFormModal = false; 
   
    @track ischecked=false;
    customShowModalPopup() {            
        this.customFormModal = true;
    }
    customHideModalPopup() {     
        this.customFormModal = false;
    }
    @track savebuttondesable = true;
    @track error;
    @track newlist={
    Name : NAME_FIELD,
    Email__c : EMAIL_FIELD,
    Confirm_Email__c : CONFIRMEMAIL_FIELD,
    Approved__c:CHECKBOX_FIELD
    };
    handelChange(event){
        if(event.target.label=='Name')
        {
        this.newlist.Name = event.target.value;
        window.console.log('Name ==> '+this.newlist.Name);
        }
       
        if(event.target.label=='Student Email')
        {
            this.newlist.Email__c = event.target.value;
            window.console.log('Student Email==> '+this.newlist.Email__c);
        }
        else if(event.target.label=='Confirm Email')
        {
            this.newlist.Confirm_Email__c = event.target.value;
            window.console.log('Confirm Email==> '+this.newlist.Confirm_Email__c);
        }
        else if(event.target.label=='Approved')
        {
            this.newlist.Approved__c = event.target.value;
            window.console.log('approved==> '+this.newlist.Approved__c);
        }
       }
    handelChanges(event){
        
        this.ischecked = event.target.checked;
        console.log('checkboxes ',this.ischecked);
        this.Name = event.target.value;
        this.Email__c=event.target.value;
        this.Confirm_Email__c=event.target.value;
        this.Approved__c=event.target.value;
        if(this.Name != null && (this.Email__c == this.Confirm_Email__c)  && this.ischecked==true){
            console.log('if condition');
            this.savebuttondesable=false;
        
        }else{console.log('else');
            this.savebuttondesable=true;
        }
    }
    handelOnClick()
    {
        Buttons({newlist : this.newlist})
        
        .then(result=>{
            
         this.newlist = {
         };
         console.log('check');
         this.customFormModal=false;
         this.dispatchEvent(new ShowToastEvent({
             title: 'Reacord is created!!',
                 message: 'thankYou!!',
                 variant: 'success'
            
         }));

     n})
      
    }     
    }