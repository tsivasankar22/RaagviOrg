import { LightningElement, track ,api} from 'lwc';

export default class ParentComponent extends LightningElement {
@api steps = [
    { label: 'Start', value: '1' },
    { label: 'Verificcation', value: '2' },
    { label: 'Tutorial', value: '3' },
    {label: 'Download', value: '4' },
    {label: 'FeedBack', value: '5' },
    {label: 'Help', value: '6' },

];
@track firststep=true;
@api currentstepindex = 0;
isLastStep=true;
connectedCallback(){
    console.log('sgyg',this.currentstepindex);
}

handleNext(event) {
    if (event.target.label === 'Next') {
        if (this.currentstepindex < this.steps.length - 1) {
            this.currentstepindex++;
        console.log('current step index',this.currentstepindex);
        this.template.querySelector('c-step').handleNextInChild(this.currentstepindex+1)
            
            console.log('back button',this.backbutton);
            if (this.currentstepindex === this.steps.length - 1) {
            console.log('this.steps.length',this.steps.length);
            console.log('buttonindex',this.currentstepindex);
            this.isLastStep = false;
        } else {
            this.isLastStep = true;
        }
        }
    } else if (event.target.label === 'Back') {
        if (this.currentstepindex > 0) {
            this.currentstepindex--;
            console.log('current step index',this.currentstepindex);
            this.isLastStep=true;
            this.template.querySelector('c-step').handleBackInChild(this.currentstepindex+1)
        }
    }
    if(this.currentstepindex ===0){
        this.backbutton=false;
        this.firststep = true;
    }
    else{
        this.firststep=false;
    }
    
    if (this.currentstepindex === 1) {
        this.secondstep = true;
        console.log('stepcomponentr',this.secondstep);
this.backbutton=true;
    } else {
        this.secondstep = false;
        console.log('step',this.secondstep);

    }
    if (this.currentstepindex === 2) {            
        this.thirdstep = true;
        console.log('stepcomponentr',this.thirdstep);
        this.backbutton=true;
    } else {
        this.thirdstep = false;
        console.log('step',this.thirdstep);

    }
    if (this.currentstepindex === 4) {
        this.fourthstep = true;
        console.log('stepcomponentr',this.fourthstep);
        this.backbutton=true;
    } else {
        this.fourthstep = false;
        console.log('step',this.fourthstep);

    }
}

}