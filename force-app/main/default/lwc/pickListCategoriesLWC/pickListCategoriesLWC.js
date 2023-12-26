import { LightningElement ,track,wire} from 'lwc';
import fetchRecords from '@salesforce/apex/PickListCategories.fetchRecords';
import fetch from '@salesforce/apex/PickListCategories.fetch';
export default class PickListCategoriesLWC extends LightningElement {
    @track l_All_Types;
    @track typeOptions;
    @track categories;
    
    @wire(fetchRecords)
    wireData({error, data}){
        if (data){
            try {
                console.log(data);
                this.l_All_Types = data; 
                let options = [];
                  
                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({label: data[key].Type__c, value: data[key].Id,value: data[key].Name });
                }
                this.typeOptions = options; 
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
    }

    handleTypeChange(event){
        console.log('hlo')
        this.categories = event.target.value; 
        console.log('row ction ============',event.target.value);
        fetch()
      .then(result=>{
        console.log('result================',result);

      })
    }
}