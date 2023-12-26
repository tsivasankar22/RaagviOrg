import { LightningElement, track, wire } from 'lwc';
import showGroceries from '@salesforce/apex/GroceriesController.showGroceries';
import groceriesOrder from '@salesforce/apex/GroceriesController.groceriesOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class addCart extends  NavigationMixin(LightningElement) {

  @track totalInCart = 0;
  @track cartData = [];
  @track array = []; 
  @track cost;
  @track showModel = false;
  @track totalPrice = 0;
  @track totalQuantity = 0;  
  @wire(showGroceries) grocerieItem;
  @track cartThere = true;

  handleAddToCart(event){
    for(let i=0; i<this.cartData.length; i++){
      console.log('cartData=====', this.cartData.length);
      if(this.cartData[i].cartId==event.target.value){
        alert('Already added in Cart');
        this.cartThere = false;
        console.log('cartThere==false===', this.cartThere);
        break;
      }
    }

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
    console.log('Json Cart', JSON.stringify(this.cartData));
    for(let i=0;i<this.cartData.length;i++){
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
  }

  handleOpenCart(event){
    this.showModel = true;

    this.totalPrice=0;
    this.totalQuantity = 0;
    for(let i=0; i<this.cartData.length; i++){
      let prize = this.cartData[i].cartPrice;
      let quantity = this.cartData[i].cartQuantity;
      let sum = prize * quantity;
      this.totalPrice = sum + this.totalPrice;
      this.totalQuantity = quantity + this.totalQuantity;
    }
  
  } 

  closeModal() {
    this.showModel = false;
  }

  increment(event){
    console.log('Increment Event Id=======',  event.target.value);
    for(let i=0; i<this.cartData.length; i++){
      if(this.cartData[i].cartId == event.target.value){ 
        console.log('Matched Id======', this.cartData[i].cartId);
        //Increment Quantity
        this.cartData[i].cartQuantity++;
        console.log('Update Increment Quantity=======', this.cartData[i].cartQuantity);
        console.log('Price quantity=======', this.cartData[i].cartTotalPrice);
        //price and quantity multiply to assigning cost
        this.cost = this.cartData[i].cartPrice * this.cartData[i].cartQuantity;
        console.log('TotalPrice Increment cost======', this.cost);
        //I'm assign cost to totalprice
        this.cartData[i].cartTotalPrice = this.cost;
        console.log('Increment cartTotalPrice======',this.cartData[i].cartTotalPrice);

        //I'm Updating total price and total Quantity
        this.totalPrice=0;
        this.totalQuantity = 0;
        for(let i=0; i<this.cartData.length; i++){
          let prize = this.cartData[i].cartPrice;
          console.log('prize=====', prize);
          let quantity = this.cartData[i].cartQuantity;
          console.log('quantity====',quantity);
          let sum = prize * quantity;
          console.log('sum=====', sum);
          this.totalPrice = sum + this.totalPrice;
          console.log('total Price increment for loop=======', this.totalPrice);
          //total Quantity
          this.totalQuantity = quantity + this.totalQuantity;
          console.log('this totalQuantity=====', this.totalQuantity);
        }
      }
    }
  }

  decrement(event){
    console.log('Decrement Event Id========', event.target.value);
    for(let i=0; i<this.cartData.length; i++){
      if(this.cartData[i].cartId == event.target.value){  
        console.log('Matched Id=========', this.cartData[i].cartId);
        //Decrement quantity
        this.cartData[i].cartQuantity--;
        console.log('Update Decrement Quantity=========', this.cartData[i].cartQuantity);
        console.log('Price Quantity=========', this.cartData[i].cartTotalPrice);
        //price and quantity multiply to assigning cost
        this.cost = this.cartData[i].cartPrice * this.cartData[i].cartQuantity;
        console.log('TotalPrice Decrement cost========', this.cost);
        //I'm assign cost to totalprice
        this.cartData[i].cartTotalPrice = this.cost;
        console.log('Decrement TotalPrice========', this.cartData[i].cartTotalPrice);

        //I'm Updating total price and total Quantity
        this.totalPrice=0;
        this.totalQuantity = 0;
        for(let i=0; i<this.cartData.length; i++){
          let prize = this.cartData[i].cartPrice;
          let quantity = this.cartData[i].cartQuantity;
          let sum = prize * quantity;
          console.log('sum decrement========', sum);
          console.log('this totalPrice====', this.totalPrice);
          this.totalPrice = sum + this.totalPrice;
          console.log('total Price decrement for loop=======', this.totalPrice);
          //total Quantity
          this.totalQuantity = quantity + this.totalQuantity;
          console.log('this totalQuantity=====', this.totalQuantity);
        }
      }

      if(this.cartData[i].cartQuantity < 1){
        //Quantity below 1 delete Item
        this.deleteCartItem(event);
      }
    }
  }

  deleteCartItem(event){
    console.log('Im here');
    for(let i=0;i<this.cartData.length;i++){
      if(this.cartData[i].cartId==event.target.value){
        const obj = this.cartData;
        obj.splice(i,1);
        // this.cartData=[...obj];
        console.log('Im Inside the If con');
      } 
    }
    console.log('cartdata======', JSON.stringify(this.cartData));
    console.log('size=====', this.cartData.length);
    this.totalInCart = this.cartData.length;
    console.log('TotalInCart====', this.cartData.length);
    
    //I'm Updating total price and total Quantity
    this.totalPrice=0;
    this.totalQuantity = 0;
    for(let i=0; i<this.cartData.length; i++){
      let prize = this.cartData[i].cartPrice;
      let quantity = this.cartData[i].cartQuantity;
      let sum = prize * quantity;
      console.log('sum=====', sum);
      this.totalPrice = sum + this.totalPrice;
      console.log('total Price increment for loop=======', this.totalPrice);
      //total Quantity
      this.totalQuantity = quantity + this.totalQuantity;
      console.log('this totalQuantity=====', this.totalQuantity);
    }
  }
}