import { LightningElement, track, wire, api} from 'lwc';
import searchGroceriesList from '@salesforce/apex/GroceriesSearchHandler.searchGroceriesList';
import details from '@salesforce/apex/GroceriesSearchHandler.details';
import AddressDisplay from '@salesforce/apex/GroceriesSearchHandler.AddressDisplay';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchAddressBook from '@salesforce/apex/GroceriesSearchHandler.fetchAddressBook';
import uId from '@salesforce/user/Id';
import showGroceries from '@salesforce/apex/GroceriesSearchHandler.showGroceries';
import groceriesOrder from '@salesforce/apex/GroceriesSearchHandler.groceriesOrder';
import documnetPreview from '@salesforce/apex/GroceriesSearchHandler.documnetPreview';
import sendPdf from '@salesforce/apex/GroceriesSearchHandler.sendPdf';
import adressFecthing from '@salesforce/apex/GroceriesSearchHandler.adressFecthing';
import addressShow from '@salesforce/apex/GroceriesSearchHandler.addressShow';
import {NavigationMixin} from 'lightning/navigation';
export default class GroceriesSearchHandler extends NavigationMixin(LightningElement){
  contentVID;
  documentID;
  userId = uId;
  @track viewlist='';
  @track viewlist1;
  @track resultList=[];
  @track searchKey;
  @track clickedKey;
  @track dataItems=false;
  @track AddressToShowPopUpOpen=false;
  @track storeAddress=false;
  @track AddressSave =[];
  @track AddAddress=false;
  @track savebutton=false;
  @track placeOrder=false;
  @track address=false;
  @track CancelButton=false;
  @track backButton=false;
  @track addresslist ={
  }; 
  @track PlaceOrderDisable = true;
  @track QuantityDisable = true;
  @track disableContinueShopping = false;
  @track disableCreateOrder = false;
  @track disableBuyNow = true;
  @track disableCancel = false;
  @track disableAddrssAdd = false;
  @track previewDisable = true;
  @track checked;
  @track totalAddress;

  generatePDF()
  {
    console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>pdfenter');
    console.log('Id>>>>>>>',this.userId);

    sendPdf({conDocId : this.contentVID, usrId : this.userId})
    .then(res=>{
       // this.contentVID = res;
        this.ShowToast('Details Will be send to Your Email..', res, 'success', 'dismissable');
        //console.log('contentVID=========',this.contentVID);
        console.log('res=========',res);

        this.PlaceOrderDisable=true;
        this.previewDisable = true;    
    })
    .catch(error=>{
        this.ShowToast('Error', 'Error in send email', 'error', 'dismissable');
    })
    //address display pop up
    this.AddressToShowPopUpOpen = false;
    this.disableBuyNow = true;
    
    //location.reload();

    //after click on place an order refresh the component 
    setTimeout(() => {
      eval("$A.get('e.force:refreshView').fire();");
 }, 1000); 

  }
  ShowToast(title, message, variant, mode){
    
    const evt = new ShowToastEvent({
      title: title,
      message:message,
      variant: variant,
      mode: mode
        
    });
    this.dispatchEvent(evt);
  }
 
  //Groceries Details pop up
  @track customFormModal = false; 
  customShowModalPopup(event) {  
    this.customFormModal = true;
    this.clickedKey = event.target.value;

    console.log('clickedKey========',this.clickedKey);
    //callling a details method for display perticular record all the details in a pop up
    details({GroceryName:this.clickedKey})
    .then(result=>{
      console.log('result123=======',JSON.stringify(result));
      this.viewlist = result.Id;
      console.log('resultId=======',this.viewlist);  
      this.viewlist1 = result;
      console.log('viewList>>>>>>>>>', this.viewlist1);  
    })
  }

  customHideModalPopup() {  
    this.customFormModal = false;
    //showmodal is true display Items
    this.showModel = true;
  }
  AddressHideModelPopUp(){
    //address showing pop up close
    this.AddressToShowPopUpOpen=false;
    console.log('AddressHideModelPopUp event  model pop up ')
  }
  header='Order Your Favourite One';
  message='Search And Order Groceries in a Easy Manner!!'
  //call a apex method searchGroceriesList for searching a records in a search bar
  @wire(searchGroceriesList, {searchParam :'$searchKey'})
  selectedRecord({ error, data}) {
    if(data) {
      this.resultList=data;
      console.log('searchdata',JSON.stringify(this.resultList));
    }else if(error){
      console.log('an error occured ');
      this.error = error;
      console.log('error==========',error);
    }
  }

  doSearch(event){
    //enter the letters for searching 
    this.searchKey = event.target.value;
    console.log('search key=====',event.target.value);
    if(this.searchKey == null || this.searchKey == ''){
     this.dataItems=false;
    } 
    else {
     this.dataItems=true;
    }
  }
  handelOnClick(event){
    console.log('handle click');
    //pop up close view details
    this.customFormModal = false;  
    console.log('customFormModal ==pop up close ')
    //pop up open address show like only billing address content only
    this.AddressToShowPopUpOpen=true;
    console.log('AddressToShowPopUpOpen== pop up open ')
    //calling a apex method for current user having any address then display
    fetchAddressBook()
    .then(result => { 
      console.log('add========',JSON.stringify(result));
      //current login user address should be saved to addressSave
      this.AddressSave = result;
      
      console.log('add2',this.AddressSave);
      if(this.AddressSave.length != 0){
        console.log('if condition')
        //current user have any address to show 
        this.storeAddress=true;
        this.CancelButton=true;
        // store address showing that time dont want to back and save buttons
        this.backButton=false;
        this.savebutton=false;
        //place on order button show
        this.placeOrder=true;
        //add new address button show
        this.address=true;
        //add address template false 
        this.AddAddress=false;
      }
      else {
        console.log('else condition');
        //current user dont have any address then show fields of address book to save address
        this.AddAddress=true; 
        //save button 
        this.savebutton=true;
        this.CancelButton=true;
        
      }
      console.log('address Save ========',Json.stringify(this.AddressSave));
      console.log('haiii',json.stringify(result));         
    })
    .catch(error => {
      this.error = error;
    });

  
  } 
  @track radiosaveaddress;
  handleRadioChange(event){
    console.log("inside handle Radio change");
    this.checked = event.target.value;
    console.log('radio button checked=====', this.checked);
    addressShow({addressId : this.checked})
    .then(result=>{
      console.log('result=========id============', result);
      this.totalAddress = result;
      console.log('results addressID =========', JSON.stringify(this.totalAddress));
      alert(JSON.stringify(this.totalAddress));
    })
    // console.log('radio buttonnn=====',JSON.stringify(this.totalAddress));
    //selecting a perticular record address 
    adressFecthing({adresId : this.checked})
    .then(result=>{
      console.log('result =========',result);

      this.previewDisable = false;
      //this.radiosaveaddress=result;
      // console.log('Address--->',JSON.stringify(this.radiosaveaddress));
    }).catch(error=>{
      this.error = error;
      console.log('error in adress-->',JSON.stringify(error));
    });
  
  }
  backToStoreAddress(){
    //showing of address book fields
    this.AddAddress=false;
    //any store address is there that asddress should be display
    this.storeAddress=true;
    this.savebutton=false;
    this.backButton=false;
    //add new address button 
    this.address=true;
    //place on order button
    this.placeOrder=true;

   
  }
  handelChange(event){
    //input fields for any new user adding a new address 
    if(event.target.label=='Name')
    {
      this.addresslist.Name = event.target.value;
      window.console.log('Name ==> '+this.addresslist.Name);
    }
    
    if(event.target.label=='Street')
    {
      this.addresslist.Street__c = event.target.value;
      window.console.log('Street==> '+this.addresslist.Street__c);
    }
    else if(event.target.label=='City')
    {
      this.addresslist.City__c = event.target.value;
      window.console.log('City==> '+this.addresslist.City__c);
    }
    else if(event.target.label=='State')
    {
      this.addresslist.State__c = event.target.value;
      window.console.log('State==> '+this.addresslist.State__c);
    }
    else if(event.target.label=='Country')
    {
      this.addresslist.Country__c = event.target.value;
      window.console.log('Country==> '+this.addresslist.Country__c);
    }
    else if(event.target.label=='Postal Code')
    {
      this.addresslist.Postal_Code__c = event.target.value;
      window.console.log('Postal Code==> '+this.addresslist.Postal_Code__c);
    }
  
  }
  
  handelOnchange()
  //after filling all the input address then save the record in object 
  {   
    AddressDisplay({addresslist : this.addresslist})
    .then(result=>{  
      this.addresslist = {
      };
      console.log('check');
     // this.AddressToShowPopUpOpen=false;

     //after saving the record showing purpose current user how many address is there so calling apex method here
     fetchAddressBook()
     .then(result => { 
       console.log('stored addresss    =====',JSON.stringify(result));
      this.AddressSave=result;
      this.AddressToShowPopUpOpen=true;
      console.log('address pop up')
      this.storeAddress=true;
      console.log('store address ')
      this.AddAddress=false;
      this.CancelButton=true;
      this.address=true;
      this.placeOrder=true;
      this.savebutton=false;
      this.backButton=false;

      this.dispatchEvent(new ShowToastEvent({
        title: 'Address is Saved!!',
        message: 'ThankYou!!',
        variant: 'success'
      })); 
    })
    })  
  }

  //Code For Generate Bill
  generateBill()
  {
    console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>enterBill');
    documnetPreview({usrId : this.userId})
    .then(result =>{
      this.documentID=result;
      this.contentVID=this.documentID.Id;
      this.PlaceOrderDisable=false;
      console.log('result>>>',result);
      console.log('>>>>>>>>>>>>>>>>>>>>>>>',this.documentID.Id);
      this[NavigationMixin.Navigate]({ 
        type:'standard__webPage',
        attributes:{ 
          url: 'https://rtsandbox-dev-ed.my.site.com/Project007'+'/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+this.contentVID
        }
      })
    }).catch(error=>{
      console.log('error>>>',JSON.stringify(error));
    });

    this.disableCancel = true;
    this.disableAddrssAdd = true;
    this.previewDisable = true;
  }

  AddNewAddress()
  {
    console.log('i am in add new address');
    //view details pop up
    this.customFormModal = false; 
    //address to show pop up
    this.storeAddress=false; 
     //show fields of address book to save address
    this.AddAddress=true;
    //save button
    this.savebutton=true;
    this.backButton=true;
    //place on order button
    this.placeOrder=false;
     //add new address button show
    this.address=false;
    console.log('i am in last new address')
    this.disableBuyNow = false;
  }

  ////////      Add To Cart     ////////
  @track totalInCart = 0;
  @track cartData = [];
  @track array = []; 
  @track cost;
  @track totalPrice = 0;
  @track showModel = true;
  @track totalQuantity = 0;
  @wire(showGroceries) grocerieItem;
  @track cartThere = true;
  @api usedInCommunity

  handleAddCart(event)
  {
    //customFormModal is false add items inside cart
    this.customFormModal = false;

    //In Already stored same item in cart throw alert message
    for(let i=0; i<this.cartData.length; i++){
      console.log('cartData=====', this.cartData.length);
      console.log('this.viewlist1.Id11111111111111=========',this.viewlist1.Id)
      if(this.cartData[i].cartId==this.viewlist1.Id){
       
        console.log('this.viewlist1.Id=========',this.viewlist1.Id)
        alert('Already added in Cart');
        this.cartThere = false;
        console.log('cartThere==false===', this.cartThere);
        break;
      }
    }

    // If condition true adding the items in cart
    if(this.cartThere == true){
      console.log('cartThere==true===', this.cartThere);
      this.cartData.push({ 
        cartId: this.viewlist1.Id,
        cartName: this.viewlist1.Name,
        cartBrandName: this.viewlist1.Brand_Name__c,
        cartImage__c: this.viewlist1.Image__c, 
        cartPrice: this.viewlist1.Price__c, 
        cartTotalPrice : this.viewlist1.Price__c,
        cartQuantity : 1 
      });
      console.log('cartData===', JSON.stringify(this.cartData));
      //I'm assigning cartdatalength in totalIncart
      this.totalInCart = this.cartData.length;
      console.log('totalInCart===', this.totalInCart);
      //Toast notification for adding item
      this.dispatchEvent(new ShowToastEvent({
        title: 'Product added in Cart Successfully',
        message: 'Thank You!',
        variant: 'success'
      })); 
    }
    else{
      //Again add new item it's added to cart
      this.cartThere = true;
      console.log('cartThere111=====', this.cartThere);
    }
      
  }

  handleAddToCart(event){
    //In Already stored same item in cart throw alert message
    for(let i=0; i<this.cartData.length; i++){
      console.log('cartData=====', this.cartData.length);
      if(this.cartData[i].cartId==event.target.value){
        alert('Already added in Cart');
        this.cartThere = false;
        console.log('cartThere==false===', this.cartThere);
        break;
      }
    }

    // If condition true adding the items in cart
    if(this.cartThere == true){
      console.log('cartThere==true===', this.cartThere);
      this.cartData.push({ 
        cartId: event.target.dataset.id,
        cartName: event.target.dataset.name,
        cartBrandName: event.target.dataset.brand,
        cartImage__c: event.target.dataset.image, 
        cartPrice: event.target.dataset.price, 
        cartTotalPrice: event.target.dataset.price,
        cartQuantity: 1 
      });
      console.log('cartData===', JSON.stringify(this.cartData));
      //I'm assigning cartdatalength in totalIncart
      this.totalInCart = this.cartData.length;
      console.log('totalInCart===', this.totalInCart);
      //Toast notification for adding item
      this.dispatchEvent(new ShowToastEvent({
        title: 'Product added in Cart Successfully',
        message: 'Thank You!',
        variant: 'success'
      })); 
    }
    else{
      this.cartThere = true;
      console.log('cartThere111=====', this.cartThere);
    }
  }

  handelCreateOrder(){
    console.log('create order');
    for(var i=0;i<this.cartData.length;i++){
      console.log('cart Name',this.cartData[i].cartName);
      this.array.push(this.cartData[i]);
      console.log('array data',JSON.stringify(this.array));
    }

    groceriesOrder({data: this.array, totalPrice: this.totalPrice, totalQuantity: this.totalQuantity})
    .then(result=>{  
      this.dispatchEvent(new ShowToastEvent({
        title: 'Order Created Successfully',
        message: 'Thank You!',
        variant: 'success'
      })); 
    })

    this.disableContinueShopping = true;
    this.disableCreateOrder = true;
    this.disableBuyNow = false;
  }

  handleOpenCart(){
    //showmodal is false inside goto opencart
    this.showModel = false;
    //Cart inside updating TotalPrice
    this.totalPrice=0;
    for(let i=0; i<this.cartData.length; i++){
      let prize = this.cartData[i].cartPrice;
      let quantity = this.cartData[i].cartQuantity;
      let sum = prize * quantity;
      this.totalPrice = sum + this.totalPrice;
    }

    this.totalQuantity = 0;
    for(let i=0; i<this.cartData.length; i++){
      let quantity = this.cartData[i].cartQuantity;
      this.totalQuantity = quantity + this.totalQuantity;
    }

    if(this.totalQuantity == 0)
    {
      this.disableCreateOrder = true;
    }
    else
    {
      this.disableCreateOrder = false;
    }
  } 

  increment(event){
    console.log('Increment Event Id=======', event.target.value);
    for(var i=0; i<this.cartData.length; i++){
      if(this.cartData[i].cartId ==  event.target.value){ 
        console.log('Matched Id======', this.cartData[i].cartId);
        //Increment Quantity
        this.cartData[i].cartQuantity++;
        console.log('Update Increment Quantity=======', this.cartData[i].cartQuantity);
        console.log('Price quantity=======', this.cartData[i].cartTotalPrice);
        //price and quantity multiply to assigning cost
        this.cost = this.cartData[i].cartPrice * this.cartData[i].cartQuantity;
        //I'm assign cost to totalprice
        this.cartData[i].cartTotalPrice = this.cost;
        console.log('TotalPrice Increment Quantity======', this.cost);

        this.totalPrice=0;
        for(let i=0; i<this.cartData.length; i++){
          let prize = this.cartData[i].cartPrice;
          let quantity = this.cartData[i].cartQuantity;
          let sum = prize * quantity;
          console.log('sum=====', sum);
          this.totalPrice = sum + this.totalPrice;
          console.log('total Price increment for loop=======', this.totalPrice);
        }

        this.totalQuantity = 0;
        for(let i=0; i<this.cartData.length; i++){
          let quantity = this.cartData[i].cartQuantity;
          this.totalQuantity = quantity + this.totalQuantity;
        }
      } 
    }
  }

  decrement(event){
    console.log('Decrement Event Id========', event.target.value);
    for(var i=0; i<this.cartData.length; i++){
      if(this.cartData[i].cartId == event.target.value){  
        console.log('Matched Id=========', this.cartData[i].cartId);
        //Decrement quantity
        this.cartData[i].cartQuantity--;
        console.log('Update Decrement Quantity=========', this.cartData[i].cartQuantity);
        console.log('Price Quantity=========', this.cartData[i].cartTotalPrice);
        //price and quantity multiply to assigning cost
        this.cost = this.cartData[i].cartPrice * this.cartData[i].cartQuantity;
        //I'm assign cost to totalprice
        this.cartData[i].cartTotalPrice = this.cost;
        console.log('TotalPrice Decrement Quantity==========', this.cost);
        this.totalPrice=0;
        for(let i=0; i<this.cartData.length; i++){
          let prize = this.cartData[i].cartPrice;
          let quantity = this.cartData[i].cartQuantity;
          let sum = prize * quantity;
          console.log('sum=====', sum);
          this.totalPrice = sum + this.totalPrice;
          console.log('total Price increment for loop=======', this.totalPrice);
        }
        this.totalQuantity = 0;
        for(let i=0; i<this.cartData.length; i++){
          let quantity = this.cartData[i].cartQuantity;
          this.totalQuantity = quantity + this.totalQuantity;
        }
      }
      if(this.cartData[i].cartQuantity < 1){
        //Quantity below 1 delete Item
        this.deleteCartItem(event);
      }
    }
  }

  deleteCartItem(event){
    console.log("im here");
    for(var i=0; i<this.cartData.length; i++){
      if(this.cartData[i].cartId==event.target.value){
        const obj = this.cartData;
        obj.splice(i,1);
        console.log('im inside the if con');
      } 
    }
    console.log('cartdata========',JSON.stringify(this.cartData));
    console.log('size======',this.cartData.length);
    this.totalInCart = this.cartData.length;
    console.log('SizetotalInCart======', this.cartData.length);    
    this.totalPrice=0;
    for(let i=0; i<this.cartData.length; i++){
      let prize = this.cartData[i].cartPrice;
      let quantity = this.cartData[i].cartQuantity;
      let sum = prize * quantity;
      console.log('sum=====', sum);
      this.totalPrice = sum + this.totalPrice;
      console.log('total Price increment for loop=======', this.totalPrice);
    }
    this.totalQuantity = 0;
    for(let i=0; i<this.cartData.length; i++){
      let quantity = this.cartData[i].cartQuantity;
      this.totalQuantity = quantity + this.totalQuantity;
    }
  } 
}