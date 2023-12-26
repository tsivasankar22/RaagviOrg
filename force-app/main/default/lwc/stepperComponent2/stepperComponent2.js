import { LightningElement,track,wire,api } from 'lwc';
import contactdetails from '@salesforce/apex/StepperComponentHandler.getcontact';
import NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
 //import { NavigationMixin } from 'lightning/navigation';
export default class StepperComponent2 extends LightningElement {
@track contactlist=[];
@api contactdata=[];
@track isSelected;
@track selectedRow;
@track LastName = NAME_FIELD;
@track Email = EMAIL_FIELD;
@track Phone = PHONE_FIELD;
@api recordId;
@api accountid;
@api getValueFromParent;
get records(){
    return this.contactdata;
}
@api set records(data){
    if(data){
        this.accountid = data;
        console.log('accountid=====>',JSON.stringify(this.accountid))
        console.log('data=========================',data)
    }
}
getContactRecord = {
    LastName : this.LastName,
    Email : this.Email,
    Phone : this.Phone
    }
@wire (contactdetails, { accId:'$accountid'})
wiredAccount({ error, data }) {
    if (data) {
        this.contactlist = data;
        this.accountid=this.recordId;
    console.log("contact data--------------->", JSON.stringify( this.accountid ));
    console.log('contactList=====>',JSON.stringify(this.contactlist));
    } else if (error) {
        this.error = error;
    }
}
selectonecheckbox(event){
    let selectedRow = this.template.querySelector('lightning-input');
              if(selectedRow.type ==='checkbox')
              {
                  this.isSelected = event.target.checked;
                  console.log('isselected======',this.isSelected);
                  this.selectedId= event.target.value;
                  console.log('this.selectedId=============',this.selectedId);
              }
              
                console.log('inside if')
                  if(this.isSelected){
                  for(var i=0;i<this.contactlist.length;i++){
                    if(this.selectedId == this.contactlist[i].Id){
                        this.contactdata.push(this.contactlist[i]);
                    }
                  }
                  //console.log('contact data==============',JSON.stringify(this.contactdata))
                  console.log(' contact data========data to be sent',JSON.stringify(this.contactdata))
                  console.log('before dispatch event=====')
                  this.dispatchEvent(new CustomEvent('update',{
                    detail:{
                        records:this.contactdata
                    }                   
                }))
                console.log('this.contact data=================',this.contactdata)
                console.log('after   dispatch event=====')
        }
        else{
            this.contactdata.pop(this.contactlist[i]);
            console.log('data inside',JSON.stringify(this.contactdata))
        }
      }
}