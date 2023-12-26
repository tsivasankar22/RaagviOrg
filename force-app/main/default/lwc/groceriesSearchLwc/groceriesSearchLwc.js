import { LightningElement,track,wire,api } from 'lwc';
import GroceriesSearch from '@salesforce/apex/GroceriesSearchLwc.GroceriesSearch'
import details from '@salesforce/apex/GroceriesSearchLwc.details';
import listOfDetails from '@salesforce/apex/GroceriesSearchLwc.listOfDetails';

export default class GroceriesSearchLwc extends LightningElement
{

  @track viewlist='';
  @api resultList=[];
  @track searchKey;
  @track clickedKey;
  @track searchData=[];
  @track dataItems=false;

  // calling the apex method here
  //and storing all records in resultlist
  
  @wire(GroceriesSearch)   //,{searchParam :'$searchKey'})
  selectedRecord({ error, data}) {
      if(data) {
          this.resultList=data;
          } else {
              this.error = error;
          }
          console.log('resultList==========-------------',JSON.stringify(this.resultList));
      }
      // handleSerach(event){
      //   if(event.keycode===13){
      //     this.doSerach();
      //   }
      // }
      doSerach(event){
       // var searchTerm = "%" + component.find(searchField).get("v.value") + "%"
            this.searchKey = event.target.value;

            console.log('Search item',event.target.value);
            for(var i=0;i<this.resultList.length;i++){
              if(this.resultList[i].Name==this.searchKey){
                this.dataItems=true;
                this.searchData.push(this.resultList[i]);
                console.log('searchdata===if match ',JSON.stringify(this.searchData));
                break;
              }
              else{
                this.dataItems=false;
                this.searchData.pop();
                console.log('searchdata if not MAtch===',JSON.stringify(this.searchData));
              }
            }
        }
          //By default pop up will be false
  @track customFormModal = false; 
  // when am click on button pop up will be true 
  customShowModalPopup(event) {  
    //console.log('clickedButtonLabel========',this.clickedKey);          
    this.customFormModal = true;
    this.clickedKey = event.target.value;

    console.log('clickedButtonLabel========',this.clickedKey);
    details({GroceryName:this.clickedKey})
    .then(result=>{
        console.log('result123=======',JSON.stringify(result));
        this.viewlist = result.Id;
        console.log('resultId=======',this.viewlist);

  })
}
    //pop up cancel button 
      customHideModalPopup() {     
      this.customFormModal = false;
       }
    }