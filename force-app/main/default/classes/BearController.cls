public with sharing class BearController {
    
    @AuraEnabled(cacheable=true)
   public static List<sObject>  getAllBears(String searchParam){
        String likeParam = '%'+searchParam+'%';
        String Query ='';
        if(searchParam !=null)
        {
            Query = 'Select  Id, Name, Brand_Id__c,Brand_Name__c,Image__c,Id__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c From Groceries__c Where Name Like : likeParam Limit 10';
        }else{
            Query = 'Select Id, Name,Brand_Id__c,Brand_Name__c,Id__c,Image__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c From Groceries__c  Limit 50';
        }
        List<sObject> sObjectList = Database.query(Query);
       // System.debug('sObjectList---====='+sObjectList);
        return sObjectList;
   }
//    @AuraEnabled(cacheable=true)
//    public static Groceries__c details(Id GroceryName){
//     System.debug(GroceryName);
//     System.debug([select Id,Name,Price__c,Total_Quantity__c from Groceries__c  Where Id =:GroceryName]);
//     return [select Id,Name,Price__c,Total_Quantity__c ,Brand_Name__c from Groceries__c  Where Id =:GroceryName LIMIT 10];
//     // return [select Id,Name,Price__c,Total_Quantity__c ,Brand_Name__c from Groceries__c];
//    }
}