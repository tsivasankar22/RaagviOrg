import { LightningElement, track, api, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import getselectedcontact from '@salesforce/apex/StepperComponentHandler.getselectedcontact';
export default class StepperComponent3 extends LightningElement {
    @track contactModal =true;
    @track contactList = [];
    @api selectedRecords=[];
    @track LastName = NAME_FIELD;
    @track Email = EMAIL_FIELD;
    @track Phone = PHONE_FIELD;
    @track allcontact=[];
    @track selectedContactForEmail = [];
    @api selectedId;
    @api value1;
    @track dataItems;
    @api recordId;
    @api accountid;
    @api selectingId;
   // @api contactdata;
    @api contactdata1;
@track condata;
@wire (getselectedcontact, { selectingId:'$accountid'})
wiredAccount({ error, data }) {
    if (data) {
        this.contactlist = data;
        console.log('wire data==============',data)
        this.accountid=this.recordId;
    console.log("contact data--------------->", JSON.stringify( this.accountid ));
    console.log('contactList=====>',JSON.stringify(this.contactlist));   
    } else if (error) {
        this.error = error;
    }
}
   handledata(){
    this.condata=contactdata1;
    console.log('constact data1===================', this.condata)
    console.log('contactdata1 data1===================', contactdata1)
    console.log('contacts from stepper 1===>>>',JSON.stringify(this.contactdata1))
   }
}