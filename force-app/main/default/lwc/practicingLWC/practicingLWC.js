import { LightningElement, api, wire ,track} from "lwc";
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = ["Contact.Name", "Contact.Title", "Contact.Phone", "Contact.Email"];

export default class PracticingLWC extends LightningElement {
  get options() {
    return [
        { label: 'Sales', value: 'option1', text: 'Additional text for Sales option' },
        { label: 'Force', value: 'option2', text: 'Additional text for Force option' },
    ];
}

handleOptionChange(event) {
    const selectedOption = event.target.value;
    console.log(`Selected Option: ${selectedOption}`);
}
}
