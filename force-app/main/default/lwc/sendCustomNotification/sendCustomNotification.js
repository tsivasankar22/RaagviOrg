import { LightningElement, api, track } from 'lwc';
import notifyUsers from '@salesforce/apex/CustomNotificationFromApex.notifyUsers';
import getNotificationList from '@salesforce/apex/CustomNotificationFromApex.getNotificationList';
export default class SendCustomNotification extends LightningElement {
    @api recordId;
    @track notificationOptions = [];
    showNotificationTypePicklist = false; 

    //fired on load of the component
    connectedCallback(){
        this.notificationJson.targetId = '0055i000004HgOUAA0';
        // //get all the notification type
        // getNotificationList()
        // .then((result) => {
        //     console.log('result---------'+JSON.stringify(result.Id));
        //     // result.forEach(element => {
        //     //     this.notificationOptions.push({label: element.CustomNotifTypeName, value: element.Id});
        //     // });
        //     // this.showNotificationTypePicklist = true;
        // })
        // .catch((error) => {
        //     console.log(error);
        // });
    }

    //handler for button click
    handleClick(){
        //send the custom notification
        notifyUsers({ 
            wrapp : this.notificationJson
        })
        .then((result) => {
            console.log(result);
        })
        .catch((error) => {
            console.log(error);
        });
    }

    //property to hold the input parameter values
    @track notificationJson = {
        title: 'Data User',
        body: 'Data User',
        customNotificationType: '0ML5i0000008UK0GAM',
        targetId : null
    };

 
    // //hanlder for notification type picklist
    // handleNotificationTypeChange(event){
    //     this.notificationJson.customNotificationType = event.detail.value;
    //     console.log('this.notificationJson--------'+JSON.stringify(this.notificationJson));
    // }
}