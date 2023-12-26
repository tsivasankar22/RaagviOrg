import { LightningElement,api } from 'lwc';

export default class DynamicTableChild extends LightningElement {
    
    @api tableRecordFromParent;

    callFromParent() {
      console.log('inside the child');
    }
}