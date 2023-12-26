import { LightningElement,track,wire ,api} from 'lwc';
import UserProfileShow from '@salesforce/apex/UserProfilePictureShow.UserProfileShow';


export default class UserProfileShowComponent extends LightningElement {
   @track resultList=[];
    @api recordId;
    @track mobile;
    @track title;
    @track email
    @track name;
    @track profile;
   @track  baseurl='https://raagvitech77-dev-ed.my.salesforce.com'
    ContentUrl;
   
   error;

@wire(UserProfileShow)
selectedRecord({ error, data}) {
  if(data) {
   
    if(JSON.stringify(data.RecordOwnerDetails)){
      var bdmAssignUserImage = data.url;
      this.ContentUrl = this.baseurl+'/sfc/servlet.shepherd/document/download/'+bdmAssignUserImage;
      

      this.resultList = JSON.parse(JSON.stringify(data.RecordOwnerDetails));
     // console.log('profilepic==========',this.resultList.UserProfilePic__c);
    }else{
      this.resultList =  null;
  } 
  }else if(error){
    console.log('an error occured '+JSON.stringify(error));
  }
}


}