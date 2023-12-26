import { LightningElement ,track,api,wire} from 'lwc';

export default class RecordEditForm extends LightningElement {
    @track customFormModal = false;
    @api recordId; 
    customShowModalPopup() {            
        this.customFormModal = true;
        console.log('i am in pop up');
    }
    customHideModalPopup() {     
        this.customFormModal = false;
        console.log('pop up close');
    }
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
        this.customHideModalPopup();
    }
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
    }
  }