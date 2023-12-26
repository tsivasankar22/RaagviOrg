import { LightningElement,track,wire,api } from 'lwc';
import searchBeer from '@salesforce/apex/BeerSearchLwc.searchBeer'
import BEER_IMAGE from '@salesforce/resourceUrl/BeerImage';
export default class SearchBeerLwc extends LightningElement {
    @api resultList='';
    @track searchKey;
    beer_Image = BEER_IMAGE;
    @wire(searchBeer, {searchParam :'$searchKey'})
    selectedRecord({ error, data }) {
         if(data) {
            console.log(JSON.stringify(data));
            this.resultList=data;
            }else{
                this.error = error;
            }
        }
        doSerach(event){
           this.searchKey = event.target.value;
        }   
}