import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class FeedBackComponent extends NavigationMixin(LightningElement)  {
    data;
    feedback(){
        this.data="https://www.google.com"
        console.log('this.data in feed back',this.data);
        this[NavigationMixin.Navigate]({ 
            type:'standard__webPage',
            attributes:{ 
              url: this.data
            }
          })
        
       

    }
}