import { LightningElement, api } from 'lwc';

export default class FeedbackSuccess extends LightningElement {
    @api firstName;
    @api lastName;
    @api feedbackRating;
    @api feedbackComments;
    @api suggestions;

    // This method is called when the component is initialized
    connectedCallback() {
        // Log the feedback data to the console
        console.log('Feedback saved:');
        console.log('First Name: ' + this.firstName);
        console.log('Last Name: ' + this.lastName);
        console.log('Rating: ' + this.feedbackRating);
        console.log('Comments: ' + this.feedbackComments);
        console.log('Suggestions: ' + this.suggestions);
    }
}