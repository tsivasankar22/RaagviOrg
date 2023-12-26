import { LightningElement, api,track } from 'lwc';
 
export default class DynamicTableItem extends LightningElement {     
    @api record;
    @api field;
    @api sObjectName;
    @api cellValue;
    @api cellLabel;
    @track dateTime;
   
    @api isTextField =  false;
    @api isReferenceField = false;
    @api isDateField =  false;
    @api isDateTimeField =false;
    @api isCurrencyField = false;
    @api isTimeField = false;
    @api isBooleanField = false;
    @api isLongtextArea=false;
    @api isType
    @api isURLField = false;
    @api isEmailField =  false;
    @api isPhoneField = false;
    @api isPercentageField = false;
    @api recId;
    @api isPicklist = false;
    @api fieldName
    @api showButtons = false;
    @api isLookup;
    @track picklistvalue;
    @api input = false;
    @track changedFields ={};
    connectedCallback(){
        console.log('inside Connected call back');
        this.setValues();
      this.fieldName = this.field.fieldName;
       
    }
    // Method to set cell value and identify field type
setValues(){
    try{
        
        let record = this.record;
        let field = this.field;

        // Setting cell value based on field data
        this.cellValue = record[field.fieldName];
        
        // Getting field type and setting boolean flags based on field type
        let fieldType = field.type.toUpperCase();
        this.isType = fieldType;
        if(fieldType === 'STRING'){
            this.isTextField = true;
            this.recId = this.record.Id;
        } else if(fieldType === 'TEXTAREA'){
            this.isLongtextArea=true;
            this.recId = this.record.Id;
        }else if(fieldType === 'PICKLIST'){
            this.isPicklist = true;
            this.recId = this.record.Id;
            this.picklistvalue = this.field.fieldName;
        }else if(fieldType === 'DATE'){
            this.isDateField = true;
            this.recId = this.record.Id;
        }else if(fieldType == 'BOOLEAN'){
            this.isBooleanField = true;
            this.recId = this.record.Id;
        }
        else if(fieldType === 'DATETIME'){
            this.isDateTimeField = true;
            this.recId = this.record.Id;
            // Converting datetime value to ISO string format
            // var dateobj = new Date(this.cellValue); 
            // this.recId = this.record.Id;
            // this.cellValue = dateobj.toISOString();
        }else if(fieldType === 'CURRENCY'){
            this.isCurrencyField = true;
            this.recId = this.record.Id;
        }else if(fieldType === 'REFERENCE'){
            
            if(this.field.fieldName !== 'Name'){
                this.isLookup = true;
                this.recId = this.record.Id;
                this.pickvalue =this.field.fieldName;
            }
            
            
            // Identifying relationship name from field name
            let relationShipName = '';
            if(field.fieldName.indexOf('__c') == -1) {
                relationShipName = field.fieldName.substring(0, field.fieldName.indexOf('Id'));
            }
            else {
                relationShipName = field.fieldName.substring(0, field.fieldName.indexOf('__c')) + '__r';
            }
            // If relationship name exists, setting cell label and value for reference field
            if(record[relationShipName] && record[relationShipName].Name){
                this.cellLabel =  record[relationShipName].Name; 
                this.cellValue = '/lightning/r/'+this.sObjectName+'/' + this.cellValue + '/view';
            }else{
                this.isReferenceField = false;
            }
        }else if(fieldType === 'BOOLEAN'){
           
        }else if(fieldType === 'TIME'){
            this.isTimeField = true;
            this.recId = this.record.Id;
        }else if(fieldType === 'URL'){
            this.recId = this.record.Id
            this.isURLField = true;
        }else if(fieldType === "EMAIL"){
            this.isEmailField = true;
            this.recId = this.record.Id;
        }else if(fieldType === "PHONE"){

            this.isPhoneField = true;
            this.recId = this.record.Id;
        }else if(fieldType === "PERCENT"){
          
            this.isPercentageField = true;
            this.recId = this.record.Id;
            // Converting percentage value to decimal
            this.cellValue = this.cellValue/100;
        }

            /* Special Case  - for Current Record */
            if(field.fieldName.toUpperCase() === 'NAME'){
                this.isReferenceField = true;
                this.isTextField = false;
                this.cellLabel =  this.record.Name;
                this.cellValue = '/lightning/r/'+this.sObjectName+'/' + this.record.Id + '/view';
                this.recId = this.record.Id
                
            }  
        }catch(e){
        console.log(e.message);
        }
    }
  
    @track editRecId;
    @track editFieldName;
    editHandler(event){
        
        if(this.input === false){
            this.input = true;
            console.log('i am in a 1st if of edit button');
        }else if (this.cancell === true){
            this.input = false;
            console.log('It Is In EditCancell');
        }
        else
        {
            console.log('i am in a edit of else candition');
            this.input = false;
        }
        
        console.log('this.input-------',this.input);
        const event1 = new CustomEvent('showbuttons', { detail: true });
        this.dispatchEvent(event1);

       // this.input=true;
       this.editRecId=event.target.dataset.id
       this.editFieldName=event.target.dataset.field
       
        console.log('this.input-------',this.input);
        console.log('recId edit',this.editRecId);
        console.log('field name edit',this.editFieldName);
        
    }
    handlerChange(event){
        // console.log('recId change',event.target.dataset.id);
        // console.log('field type',this.isType);
        let newValue;
        if(this.isType == 'BOOLEAN'){
            newValue = event.target.checked;
        }else{
            newValue = event.target.value;
        }
        console.log('new value child',newValue);
        const detail = {
            recordId: this.recId,
            fieldName: this.fieldName,
            newValue: newValue
        };

        const customEvent = new CustomEvent('mycustomevent', { detail });
        this.dispatchEvent(customEvent);
        console.log('i am in a dispatch event');
    }
}