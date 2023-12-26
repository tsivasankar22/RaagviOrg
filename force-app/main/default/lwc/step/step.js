import { LightningElement, api, track } from 'lwc';

export default class Step extends LightningElement {
    @api label;
    @api value;
    @api currentstepindex;
    @api stepindex;
    @api steps = [];
    @track isCurrentStep = 0;

    connectedCallback() {
      
        console.log('currentstep index'+ this.currentstepindex);
        console.log('Step>>',JSON.stringify(this.steps));
        

    }
    renderedCallback() {
        const horizontalLines =  this.template.querySelectorAll('[data-id="esa"]');
        console.log('horizontal',horizontalLines.length); 
        if (horizontalLines.length > 0) {
           horizontalLines[horizontalLines.length - 1].classList.add('hide-horizontal-line');
            console.log('dfnjsn');
            console.log('currentstep render'+ this.currentstepindex);
       
        }
        if(this.currentstepindex === 0){
        this.template.querySelector(`[data-id="${1}"]`).classList.add('addColor')
        }
        if(this.currentstepindex >=1){
            this.template.querySelector(`[data-id="${this.currentstepindex+1}"]`).classList.add('addColor')
            this.template.querySelector(`[data-id="${this.currentstepindex}"]`).classList.remove('addColor')
    }

    }
@api handleBackInChild(back){
    this.template.querySelector(`[data-id="${back-1}"]`).classList.add('addColor')
    this.template.querySelector(`[data-id="${back}"]`).classList.remove('addColor')
}
@api handeNextInChild(next){
    this.template.querySelector(`[data-id="${next}"]`).classList.add('addColor')
    this.template.querySelector(`[data-id="${next-1}"]`).classList.remove('addColor')
}
}