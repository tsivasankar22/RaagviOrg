public with sharing class BeerSearchLwc {
    @AuraEnabled(cacheable=true)
   public static List<sObject>  searchBeer(String searchParam){
        String likeParam = '%'+searchParam+'%';
        String Query ='';
        if(searchParam !=null)
        {
            Query = 'Select  Id, Name,Brand_Id__c,Brand_Name__c,Image__c,Id__c,Price__c,Remaining_Quantity__c,Tag__c,Total_Quantity__c From Groceries__c Where Name Like : likeParam Limit 10';
        }else{
            Query = 'Select Id, Name,Alchol__c,	Brand_Id__c,Brand_Name__c,Id__c,Image__c,Price__c,Remaining_Quantity__c,Tag__c,Total_Quantity__c From Groceries__c  Limit 50';
        }
        List<sObject> sObjectList = Database.query(Query);
        System.debug('sObjectList---'+sObjectList);
        return sObjectList;
   }
}