import { LightningElement ,api,wire,track} from 'lwc';
//import aboveHeader from '@salesforce/apex/CustomPageLayoutHearderAboveField.aboveHeader';
export default class CustomPageHeaderFields extends LightningElement {
    @api recordId;
    @track selectedValues = {};
    @track onclickFunction=[];
    get options() {
        return [
            { label: 'Cancel', value: 'Cancel' },
            { label: 'Decline', value: 'Decline' },
        ];
    }
    get RFS2Options(){
        return [
            { label: 'Accept', value: 'Accept' },
            { label: 'Reject', value: 'Reject' },
        ];
    }
    get UserDepartmentOptions(){
        return [
            { label: 'USER', value: 'USER' },
            { label: 'Dept', value: 'Dept' },
        ];
    }
    get OriginatorOptions(){
        return [
            { label: 'New', value: 'New' },
            { label: 'old', value: 'old' },
        ]; 
    }
    handleChange(event) {   
        const fieldName = event.currentTarget.dataset.fieldname;
        console.log('field name-----------'+fieldName);
        const selectedValue = event.detail.value;
        if (selectedValue) {
            // Push the selected value into the array
            this.onclickFunction.push(selectedValue);         
            console.log('this.onclickFunction: --------------' + JSON.stringify(this.onclickFunction));
        }
            // this.selectedValues[fieldName] = selectedValue;
            // console.log('selected values: ' + JSON.stringify(this.selectedValues));
    
            // // Create a new object to store the current selected values
            // const currentSelectedValues = { ...this.selectedValues };
            // this.onclickFunction.push(currentSelectedValues);
    
            // console.log('this.onclickFunction: ' + JSON.stringify(this.onclickFunction));
        }
    handleClick(){
     console.log('record Id--------'+this.recordId);
    }
}