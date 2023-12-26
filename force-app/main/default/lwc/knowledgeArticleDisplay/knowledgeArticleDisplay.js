import { LightningElement, wire } from 'lwc';
import getArticle from '@salesforce/apex/KnowledgeArticles.getArticle';
export default class Restarent extends LightningElement {

    knowledges;
    error;

    @wire (getArticle) 
    wiredContacts({ error, data }) {
        if (data) {
            this.knowledges = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.knowledges = undefined;
        }
    }
}