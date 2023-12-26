import { LightningElement,track, wire,api } from 'lwc';
import caseNumber from '@salesforce/apex/StepperComponentHandler.getAllEvents';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCaseNumber from '@salesforce/apex/StepperComponentHandler.getCase';
const columns = [ 
    { label: "CaseNumber",
         type: "button",
         typeAttributes: { label: { fieldName: "CaseNumber" }, name: "AccountId", variant: "base" }
 },
 ];
export default class steperOneComponent extends LightningElement {
    @track Onecomponent=true
    @api conData;
    @track currentStep = '1';
    @track caseData=[];
    columns = columns;
    items;
    @track value1;
    @track openCases=true;
    @api recordId;
    @track recordId1;
    @track searchData;
    @track dataItems=true;
    @track resultList;
    @api accId;
     contactdata;
    @track contactsforstep3;
    @track value;
    @track selectKey;
  //  @track defaultValue='5005i00000JitpMAAR'
     @track defaultValue;
   
    // valueText = "Select Event";
    // picklist showing all how many cases are there in perticular account

    @track defultdata=[];
    @wire(caseNumber,{accId:'$recordId'})
    eventsList;
    get eventOptions() {
        var returnOptions = []; 
        if(this.eventsList.data){
            this.eventsList.data.forEach(ele =>{
                //returnOptions.returnOptions.push({label:ele.CaseNumber[0]+'  '+ele.Subject[0] , value:ele.Id[0], Subject:ele.Subject[0]});
                returnOptions.push({label:ele.CaseNumber+'  '+ele.Subject , value:ele.Id, Subject:ele.Subject});
                
            });
            
             
        }
       
        console.log('return',JSON.stringify(returnOptions));
        return returnOptions;
    }
 
  // this method shows what record is recently created
    @wire(getCaseNumber,{accId:'$recordId'})
    selectedRecord({ error, data}) {
        if(data) {
          this.resultList=data;
          this.searchData=data;
       
          this.items = data;
          this.columns = columns;
          console.log('data==========',data);
          console.log('data',JSON.stringify(this.resultList));
            this.defaultValue=data[0].Id;
            console.log('asfdjhasjhdasjhdgf',this.defaultValue);
          
        }else if(error){
          console.log('an error occured ');
          this.error = error;
          console.log('error==========',error);
        }
      }
      // value1=this.resultList;
      handleRowAction(event){
        console.log('i am in handle an event')
        this.openCases=true;
    }
    
     handleEventMgrChange(event) {
        this.selectKey = event.detail.value;
        console.log('this.selectKey==============',this.selectKey);
        //this.valueText = "Event Selected";        
     }
    
    handleOnStepClick(event) {
        this.currentStep = event.target.value;
        console.log("event.target.value",event.target.value);
    }
 
    get isStepOne() {
        return this.currentStep === "1";
    }
 
    get isStepTwo() {
        return this.currentStep === "2";
    }
 
    get isStepThree() {
        return this.currentStep === "3";
    }

    get isStepFour() {
        return this.currentStep === "4";
    }
   
    get isEnablePrev() {
        return this.currentStep != "1";
    }

    get isEnableNext() {
        return this.currentStep != "4";
    }

    get isEnableFinish() {
        return this.currentStep === "4";
    }
    handleNext(){
       
        if(this.currentStep == "1"){
            console.log('I am In Next=========')
            console.log('Value==============',this.selectKey==null)
            if(this.selectKey==null && this.defaultValue==null){
             console.log('i am in error stating stage')
             this.dispatchEvent(new ShowToastEvent({
                 title: 'Select a record!!',
                     message: 'Select any one record !!',
                     variant: 'error'
             })); 
             }else{
                 this.currentStep = "2";
                 console.log('from step 1');
             }
         }
        else if(this.currentStep == "2"){
            console.log('I am In 2nd stage of next Condition')
            console.log('console========',this.contactsforstep3===null)
            console.log('console.log==contactsforstep3====',JSON.stringify( this.contactsforstep3))
            if(this.contactsforstep3==null){
                console.log('i am in error stating stage of 2nd step')
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Select a record!!',
                        message: 'Select any one record !!',
                        variant: 'error'
                })); 
                }else{

            this.currentStep = "3";
            console.log('from step 2');
                }
        }
        else if(this.currentStep == "3"){
            this.currentStep = "4";
            console.log('from step 3');
        }
    }
    // handlePrev(){
    //    if(this.currentStep == "4"){
    //         this.currentStep = "3";
    //     }
    //     else if(this.currentStep == "3"){
    //         this.currentStep = "2";
    //     }
    //     else if(this.currentStep = "2"){
    //         this.currentStep = "1";
    //     }
    // }
    update(event){
        console.log('event.detail======>>>',JSON.stringify(event.detail.records));
        this.contactsforstep3 = event.detail.records;
    }
}