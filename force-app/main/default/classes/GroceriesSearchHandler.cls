public with sharing class GroceriesSearchHandler {
    public User usr{get;set;}
    public List<Groceries_Order__c> grocerie{get;set;}
    public static Address_Book__c address{get;set;}
    public Address_Book__c adresId{get;set;}
    public Address_Book__c addressfetch{get;set;}
    public String currentRecordId{get;set;}
    public static String docId{get;set;}
    public static list<Address_Book__c> adresBook{get;set;}
    public Orders__C orderData{get;set;}

    public GroceriesSearchHandler(){
        //getting the current user record id 
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
         //String currentUser=UserInfo.getUserId();
        System.debug('currentRecordId----->'+currentRecordId);
        //System.debug('adrressId_PDF====>'+adrressId);


        if(currentRecordId != null && String.isNotBlank(currentRecordId)){
           usr = [SELECT Id, Name, Email, Phone FROM User WHERE Id =:currentRecordId];
           //grocerie=[select Name,Id,OwnerId,Order_Name__c,Order_Brand__c,Order_Amount__c,Ordered_Quantity__c,Price_Per_Quantity__c From Groceries_Order__c WHERE (OwnerId =:currentRecordId AND CreatedDate = TODAY)]; 
            address = [SELECT Name, Street__c, City__c, State__c, Country__c, Postal_Code__c FROM Address_Book__c WHERE (Active_Address__c = true AND OwnerId =:currentRecordId)];
            orderData = [SELECT Id,Name, Order_Total_Price__c, Order_Total_Quantity__c FROM Orders__C WHERE OwnerId =:currentRecordId ORDER BY Name DESC lIMIT 1 ];
            System.debug('orderData=====>'+orderData.Id);
            grocerie = [SELECT Name,Id, Master_Orders__c,Order_Name__c,Order_Brand__c,Order_Amount__c,Ordered_Quantity__c,Price_Per_Quantity__c From Groceries_Order__c WHERE Master_Orders__c =: orderData.Id];
            
            System.debug('address=====>'+address);
            // System.debug('adrressId_PDF====>'+adrressId);
            System.debug('currentRecordId_PDF=====>'+currentRecordId);
            System.debug('usr========='+ usr);
            System.debug('grocerie---->'+grocerie);
        }
       
    } 
    @AuraEnabled(cacheable=true)
    public static List<User> fetchRecords(){
        try {
            List<User> UserList = new List<User>();
 
            UserList = [Select id, Name, Email from User];              
            return UserList;
        } catch (Exception e) {
            System.debug('Exception======= '+e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static String sendPdf(String conDocId,String usrId) {
        
        // PageReference pdf = new pagereference('/apex/ContactDataPDF?id='+usrId);
        // pdf.getParameters().put('id', usrId);
        // System.Debug('User iddddd========,'+usrId);
     
        // Blob body;
        // try {
        //     // returns page as a PDF
        //     body = pdf.getContent();
        // } catch (Exception e) {
        //     body = Blob.valueOf('data');
        // }

        // //insert content version
        // ContentVersion CV = new ContentVersion();
        // CV.Title = 'OrderDetails.pdf';
        // CV.PathOnClient ='OrderDetails.pdf';
        // CV.VersionData =body;
        // CV.FirstPublishLocationId =usrId;
        // insert CV;
        // System.debug('CV>>>>>>>>>>'+CV);
        // docId=CV.Id;
        // System.debug('versionID------>'+docId);

        
        ContentVersion conVer = [SELECT VersionData FROM ContentVersion WHERE Id =:conDocId];
         User userEmail = [SELECT Name FROM User WHERE Id =:usrId];

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('Groceries_OrderBill.pdf');
        attach.Body = conVer.VersionData;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{usrId};
        System.debug('user Id===================='+usrId);
        System.Debug('toAddresses iddddd========,'+toAddresses);
        mail.setToAddresses(toAddresses);
        System.Debug('setToAddresses iddddd========,'+toAddresses);
        mail.setSubject('Groceries_OrderBill');
        String emailBody = 'Hi '+userEmail.Name+', <br>Firstly Thanks For Visit Our Site,Here We Send Mail For Your Groceries Order Bill,We Thought Your Feel Like joyfull And Happy To Use This Site Service And We Ready Improve Our Effeciency With Your Thought,If You Have Any Suggestions Send <b>projeect007@feedback.com</b>This Mail,<br><br>Visit Again,<br>Thank You<br>Regards<br>Project007!';
        mail.setHtmlBody(emailBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach}); 
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        return 'Email Send SuccessFully';
    }


   
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchGroceriesList(String searchParam){
        String likeParam = '%'+searchParam+'%';
        String Query ='';
        if(searchParam !=null)
        {
            Query = 'Select  Id, Name, Brand_Id__c,Brand_Name__c,Image__c,Id__c,Price__c, Total_Price__c, Remaining_Quantity__c,Tags__c,Total_Quantity__c From Groceries__c Where Name Like : likeParam OR Brand_Name__c Like: likeParam Limit 10';
        }
        List<sObject> sObjectList = Database.query(Query);
        System.debug('sObjectList---====='+sObjectList);
        return sObjectList;
    }
    @AuraEnabled(cacheable=true)
    public static Groceries__c details(Id GroceryName){
        System.debug(GroceryName);
        System.debug([select Id,Name,Price__c,Total_Quantity__c from Groceries__c  Where Id =:GroceryName]);
        return [select Id, Name, Image__c, Price__c, Total_Quantity__c, Brand_Name__c from Groceries__c  Where Id =:GroceryName];
    }
    @AuraEnabled
    public static void AddressDisplay(Address_Book__c addresslist) {
        upsert addresslist;
    }
    @AuraEnabled
    public static list<Address_Book__c> fetchAddressBook(){
        try {
            string userId = UserInfo.getUserId();
            List<Address_Book__c> AddressSave=[select id,Name,Street__c,City__c,State__c,Country__c,Postal_Code__c,User__c,OwnerId from Address_Book__c Where OwnerId =:userId];
            return AddressSave;   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Groceries__c> showGroceries()
    { 
        return [SELECT Id, Name, Brand_Name__c, Image__c, Price__c, Quantity__c, Total_Price__c FROM Groceries__c];
    }

    @AuraEnabled
    public static String groceriesOrder(Object data, Integer totalPrice, Integer totalQuantity) {
        //deserialize(jsonString, apexType)
        List<GroceriesOrderWrapper> grocerieData = (List<GroceriesOrderWrapper>) JSON.deserialize(JSON.serialize(data), List<GroceriesOrderWrapper>.class);
        System.debug('object from js --'+ grocerieData);

        Orders__c ord = new Orders__c();
        ord.Order_Total_Price__c = totalPrice;
        ord.Order_Total_Quantity__c = totalQuantity;
        ord.Order_Status__c	= 'New';
        ord.UserId__c = UserInfo.getUserId();
        INSERT ord;
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
        INSERT gcOrder;
        System.debug('data gcOrder>>>>>>>>'+ gcOrder);
        return 'the values from apex -> '+ ord.Id;
    }

    public class GroceriesOrderWrapper {
	    @AuraEnabled 
        public String cartId;
		@AuraEnabled 
        public Integer cartPrice;
		@AuraEnabled 
        public Integer cartTotalPrice;
		@AuraEnabled 
        public Integer cartQuantity;
		@AuraEnabled 
        public String cartBrandName;
        @AuraEnabled 
        public String cartName;
	}

    @AuraEnabled
    public static ContentVersion documnetPreview(String usrId) 
    {
        PageReference pdf = new pagereference('/apex/ContactDataPDF?id='+usrId);
        pdf.getParameters().put('id', usrId);
        System.Debug('User iddddd========,'+usrId);
     
        Blob body;
        try {
            // returns page as a PDF
            body = pdf.getContent();
        } catch (Exception e) {
            body = Blob.valueOf('data');
        }

        User uName = [SELECT Name FROM User WHERE Id =:usrId];

        //insert content version
        ContentVersion CV = new ContentVersion();
        CV.Title = uName.Name+'_OrderDetails.pdf';
        CV.PathOnClient =uName.Name+'_OrderDetails.pdf';
        CV.VersionData =body;
        CV.FirstPublishLocationId =usrId;
        CV.OwnerId = usrId;
        insert CV;
        System.debug('CV>>>>>>>>>>'+CV);
        docId=CV.Id;
        System.debug('versionID------>'+docId);

        System.debug('docId---->'+docId);
        // ContentDocument docList = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =:docId];

        // System.debug('doclist---->'+docList);

        return CV;
    }
    @AuraEnabled
    public static String adressFecthing(String adresId)
    {
      
       System.debug('Addresss iddddd==========='+adresId);
      
        adresBook =[select Id,Name,Street__c,City__c,State__c,Country__c,Postal_Code__c,Active_Address__c From Address_Book__c ];
        System.debug('return1234 ======'+adresBook);
      
        for(Address_Book__c addressbok : adresBook)
        {
            if(addressbok.Id != adresId)
            {
                addressbok.Active_Address__c = false;
            }
            else if (addressbok.Id == adresId) 
            {
                addressbok.Active_Address__c = true;
            }
        }
        
        System.debug('abc=====>'+adresBook);

        upsert adresBook;

        System.debug('abc=====>2'+adresBook);  
        
        return 'Success';
    }
    @AuraEnabled
    public static Address_Book__c addressShow(Id addressId){
        Address_Book__c addreses = [select Name,Street__c,City__c,State__c,Country__c,Postal_Code__c From Address_Book__c WHERE Id=:addressId];
        return addreses;
    }
    
}