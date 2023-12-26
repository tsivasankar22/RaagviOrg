public class GroceriesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Groceries__c> showGroceries()
    { 
        return [SELECT Id, Name, Brand_Name__c, Image__c, Price__c, Quantity__c, Total_Price__c FROM Groceries__c];
    }

    @AuraEnabled
    public static String groceriesOrder(Object data, Decimal totalPrice, Integer totalQuantity) {
        //deserialize(jsonString, apexType)
        List<GroceriesOrderWrapper> grocerieData = (List<GroceriesOrderWrapper>) JSON.deserialize(JSON.serialize(data), List<GroceriesOrderWrapper>.class);
        System.debug('object from js --'+ grocerieData);

        Orders__c ord = new Orders__c();
        ord.Order_Total_Price__c = totalPrice;
        ord.Order_Total_Quantity__c = totalQuantity;
        ord.Order_Status__c	= 'New';
        ord.UserId__c = UserInfo.getUserId();
        insert ord;
        System.debug('ord111>>>>>'+ ord);

        List<Groceries_Order__c> gcOrder = new List<Groceries_Order__c>();
        for(GroceriesOrderWrapper groceries : grocerieData)
        {
            System.debug('foreach loop -- '+ groceries);
            Groceries_Order__c gc = new Groceries_Order__c();
            gc.Master_Orders__c = ord.Id;
            gc.Order_Name__c = groceries.cartName;
            gc.Order_Brand__c = groceries.cartBrandName;
            gc.Order_Amount__c = groceries.cartTotalPrice;
            gc.Ordered_Quantity__c = groceries.cartQuantity;
            gc.Price_Per_Quantity__c = groceries.cartPrice;
            System.debug('gc=== '+ gc);
            gcOrder.add(gc);  
            System.debug('gcOrder=== '+ gcOrder);
        }
        insert gcOrder;
        System.debug('data gcOrder>>>>>>>>'+ gcOrder);
        return 'the values from apex -> '+ ord.Id;
    }

    public class GroceriesOrderWrapper {
		@AuraEnabled public String cartId;
		@AuraEnabled public Decimal cartPrice;
		@AuraEnabled public Decimal cartTotalPrice;
		@AuraEnabled public Integer cartQuantity;
		@AuraEnabled public String cartBrandName;
        @AuraEnabled public String cartName;
	}

    //Cart to CartItems

    //deserialize(jsonString, apexType)
    // List<CartItemsOrderWrapper> grocerieData = (List<CartItemsOrderWrapper>) JSON.deserialize(JSON.serialize(data), List<CartItemsOrderWrapper>.class);
    // System.debug('object from js --'+ grocerieData);

    // Cart__c cart = new Cart__c();
    // cart.UserId__c = UserInfo.getUserId();
    // insert cart;
    // System.debug('cart>>>>>'+ cart);

    // List<Cart_Items__c> CartItems = new List<Cart_Items__c>();
    // for(CartItemsOrderWrapper groceries : grocerieData)
    // {
    //     System.debug('foreach loop -- '+ groceries);
    //     Cart_Items__c carts = new Cart_Items__c();
    //     carts.Cart__c = cart.Id; 
    //     carts.Cart_Item_Name__c = groceries.cartName;
    //     carts.Cart_Item_Brand__c = groceries.cartBrandName;
    //     carts.Total_Amount__c = groceries.cartTotalPrice;
    //     carts.Item_Quantity__c = groceries.cartQuantity;
    //     carts.Item_Amount__c = groceries.cartPrice;
    //     System.debug('carts=== '+ carts);
    //     CartItems.add(carts);  
    //     System.debug('carts=== '+ CartItems);
    // }
    // insert CartItems;
    // System.debug('data carts>>>>>>>>'+ CartItems);
    // return 'the values from apex -> '+ cart.Id;

    // public class CartItemsOrderWrapper {
    //     @AuraEnabled public String cartId;
    //     @AuraEnabled public Decimal cartPrice;
    //     @AuraEnabled public Decimal cartTotalPrice;
    //     @AuraEnabled public Integer cartQuantity;
    //     @AuraEnabled public String cartBrandName;
    //     @AuraEnabled public String cartName;
    // }
}