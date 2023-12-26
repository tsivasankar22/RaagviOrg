import { LightningElement,track ,wire } from 'lwc';
import showGroceries from '@salesforce/apex/BearController.showGroceries';
import { NavigationMixin } from 'lightning/navigation';
export default class BearController extends NavigationMixin(LightningElement) {
    @track totalInCart = 0;
    @track cartData = [];
    @track quantity=0;
    @track showModel=true;
   // @track showNewComponet=false;
    @wire(showGroceries) showGroceries;


    increment(event){

        this.quantity++;
        console.log('increment========',this.quantity)

    }
    decrement (event){
        this.quantity > 0 && this.quantity--;
        console.log('decrement========',this.quantity)
    }

    handleAddToCart(event)
    {
        this.cartData.push({ CartName: event.target.dataset.name,
            
            CartId: event.target.value,
            CartPrice__c: event.target.dataset.price,
            CartImage__c: event.target.dataset.image,
            CartTotal_Quantity__c: event.target.dataset.quantity 
        });
        console.log('card name ============',event.target.dataset.name);
        console.log('cartdata',JSON.stringify(this.cartData));
        this.totalInCart = this.cartData.length;
        console.log('size',this.totalInCart);
    }

    handleOpenCart(event){
        this.showModel = false;
    } 

    closeModal() {
        this.showModel = true;
    }

    DeleteCartItem(event){
        console.log("im here");
        for(var i=0;i<this.cartData.length;i++){
            if(this.cartData[i].CartId == event.target.value){
                const obj = this.cartData;
                obj.splice(i,1);
                this.cartData=[...obj];
                console.log('im inside the if loop');
                break;
            } 
        }
        console.log('cartData>>>>',JSON.stringify(this.cartData));
        this.totalInCart = this.cartData.length;
        console.log('size>>>>>>>>',this.cartData.length);
        
    }
  
    placeOrder(event){

       this.showNewComponet=true;

    }
}