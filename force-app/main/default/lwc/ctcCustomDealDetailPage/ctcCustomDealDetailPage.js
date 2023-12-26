import { LightningElement,api } from 'lwc';

export default class CtcCustomDealDetailPage extends LightningElement {
    @api content;
    @api recID;
    @api content2;
    connectedCallback(){
        console.log('recID>>>'+this.recId);
    }
}