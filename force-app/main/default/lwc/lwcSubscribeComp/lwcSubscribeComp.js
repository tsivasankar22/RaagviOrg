import { wire, LightningElement,track } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import accMessageChannel from '@salesforce/messageChannel/AuraToLwc__c';
const columns = [
    { label: 'Account Name', fieldName: 'name', type: 'text' },
]
export default class LwcSubscribeComp extends LightningElement {
    @wire(MessageContext)
    messageContext;
    @track accountName={};
    columns = columns;
    subscription = null;
   //@track columns=columns
    @track receivedMessage=[];
    @track selectedAccountNames = [];
    @track selectedAccountIds=[];
    connectedCallback() {   
       const isSubscribed = sessionStorage.getItem('isSubscribed');
       const storedAccountName = localStorage.getItem('accountName');
      // localStorage.clear();
       if (storedAccountName) {
         this.accountName = JSON.parse(storedAccountName);
       }
        if (isSubscribed === 'true') {
            // Button state is subscribed
            this.isSubscribeDisabled = true;
           this.subScribeMethod();       
            this.isUnsubscribeDisabled = false;
        } else {
            // Button state is unsubscribed
            this.isSubscribeDisabled = false;
            this.isUnsubscribeDisabled = true;
        }   
     }
        isUnsubscribeDisabled;
        isSubscribeDisabled;
      subscribeMC() {
        console.log('i am in a subscribe');
      this.isSubscribeDisabled=true;
      sessionStorage.setItem('isSubscribed', 'true');
        this.subScribeMethod();
      // Update button disabled/enabled state
      this.isSubscribeDisabled = true;
        this.isUnsubscribeDisabled = false;
        console.log('i am in a subscribeMNE');   
        }
        subScribeMethod(){
          if (this.subscription) {
            return;
        }
        this.subscription = subscribe(
            this.messageContext,     
            accMessageChannel, (message) => {
                this.handleMessage(message);    
            });
        }
    handleMessage(message) {
        console.log('message:', message);
        const selectedAccountIds = message.selectedAccountIds;
        const uniqueNamesSet = new Set(); 
        selectedAccountIds.forEach(item => {
          if (!uniqueNamesSet.has(item.name)) {
            uniqueNamesSet.add(item.name);
          }
        }); 
        const uniqueNames = Array.from(uniqueNamesSet).map(name => ({
          id: selectedAccountIds.find(item => item.name === name).id,
          name: name
        })); 
        
        this.accountName = uniqueNames; 
        console.log('Unique names:', this.accountName);  
        localStorage.setItem('accountName', JSON.stringify(this.accountName));
    }
    unsubscribeMC() {
        console.log('i am in a unscribe ');
        unsubscribe(this.subscription);
        this.subscription = null;
        this.receivedMessage = null; 
       sessionStorage.removeItem('isSubscribed');
        // Update button disabled/enabled state
          this.isSubscribeDisabled = false;
          this.isUnsubscribeDisabled = true;
              console.log('i am in a unsubscribeMC');
       }
}