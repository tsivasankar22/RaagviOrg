import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateCaseLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    connectedCallback(){
      console.log('record Id -------------'+this.recordId);
    }
   // @wire(ShowToastEvent)
    showToast(event) {
      console.log('record Id------------'+this.recordId);
        if (event && event.data) {
            const title = event.data.title;
            const message = event.data.message;
            
            // Display the toast message
            this.showCustomToast(title, message);
            
            // If needed, you can also navigate to a record here based on event data
        }
    }

    showCustomToast(title, message) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success', // You can customize the toast appearance
        });
        this.dispatchEvent(toastEvent);
    }

    // Other methods and logic for your component
}
