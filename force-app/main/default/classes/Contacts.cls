public with sharing class Contacts {
    @AuraEnabled(cacheable=true)
    public static List<Groceries__c> showContacts()
    { 
        List<Groceries__c> groceryList = new List<Groceries__c>();
        groceryList = [Select  Id, Name, Brand_Id__c,Brand_Name__c,Image__c,Id__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c From Groceries__c];
        return groceryList;  
    }
}