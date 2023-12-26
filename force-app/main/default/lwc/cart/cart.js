import { LightningElement, track, wire, api } from 'lwc';
import showContacts from '@salesforce/apex/Contacts.showContacts';
export default class Cart extends LightningElement{

    @track totalInCart = 0;
    @track cartData = [];
    //  selectedData={
    //     CartName:'',
    //     CartId:'',
    //     CartPhone:'',
    //     CartImage_URL__c:'',
    //     CartQuantity__c:''
    //  }
    @track showModel = true;
    @track showNewComponet = false;
    @wire(showContacts) contacts;
    @track recordId;
    @track clickedButtonLabel = 'Add To Cart'; 
    @track boolVisible = false;  
    @track addtocardId;
    handleAddToCart(event)
    {
        const label = event.target.label;  
        
        console.log('value>>>',event.target.value);
        if(label === 'Add To Cart' && event.target.value) {  

            this.cartData.push({ 
                CartName: event.target.dataset.name,
                CartId: event.target.value,
                CartPhone: event.target.dataset.phone,
                CartImage_URL__c: event.target.dataset.image,
                CartQuantity__c: event.target.dataset.quantity,
                quantity : 1 
            });
            console.log('cartdata',JSON.stringify(this.cartData));
            this.totalInCart = this.cartData.length;
            console.log('size',this.totalInCart);
            console.log('id>>>>>>>>>',this.cartData[0].CartId);
            // this.template.querySelectorAll(`[value="${this.cartData[0].CartId}"]`).forEach(element => {
            //     console.log('inside');
            //     element.clickedButtonLabel = 'Go To Cart'; 
            //     this.boolVisible = true; 
            //  });
            if(this.cartData[0].CartId===event.target.value){
                //console.log('event.target.value=======',event.target.value)
             
            }


        } 
        else if(label === 'Go To Cart') 
        {  
               
            this.boolVisible = false; 
            this.showModel = false; 
        }   
    }

    handleOpenCart(event){
        this.showModel = false;
    } 

    closeModal() {
        this.showModel = true;
    }

    DeleteCartItem(event){
        console.log("im here");
        for(var i=0; i<this.cartData.length; i++){
            if(this.cartData[i].CartId == event.target.value){
                const obj = this.cartData;
                obj.splice(i,1);
                this.cartData=[...obj];
                console.log('im inside the if loop');
                break;
            } 
        }
        console.log('cartData>>>>', JSON.stringify(this.cartData));
        this.totalInCart = this.cartData.length;
        console.log('size>>>>>>>>', this.cartData.length);  
    }

    increment(event){
        console.log('Increment Event Id', event.target.value);
        for(var i=0; i<this.cartData.length; i++){
            console.log('I value', i);
            if(this.cartData[i].CartId == event.target.value){ 
                console.log('Matched Id',this.cartData[i].CartId);
                this.cartData[i].quantity++;
                console.log('quantity', this.cartData[i].quantity);
            } 
        }
    }

    decrement(event){
        console.log('Decrement Event Id', event.target.value);
        for(var i=0; i<this.cartData.length; i++){
            console.log('I value', i);
            if(this.cartData[i].CartId == event.target.value){  
                console.log('Matched Id',this.cartData[i].CartId);
                this.cartData[i].quantity--;
                console.log('quantity', this.cartData[i].quantity);
            }
            if(this.cartData[i].quantity<1){
                this.DeleteCartItem(event);
            }
        }
    }
  
    placeOrder(event){

       this.showNewComponet=true;

    }
}