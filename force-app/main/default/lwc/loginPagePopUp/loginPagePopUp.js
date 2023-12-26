import { LightningElement ,track  } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; 
export default class LoginPagePopUp extends NavigationMixin(LightningElement) {
 

    @track customFormModal = false; 
   
    @track ischecked=false;
    customShowModalPopup() {            
        this.customFormModal = true;
    }
    customHideModalPopup() {     
        this.customFormModal = false;
    }
   
    @track error;
    @track recID
    forgotPasswordHandler(){
        console.log('i am in a forgot');
        this.recID='a045i000008Tm9NAAS'
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
              
               url: 'https://raagvitech77-dev-ed.my.site.com/s'+'/loginpagepopup'
               //'/residential-loan-application/'+this.recID
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
      this.customFormModal = false;
    }
    
}