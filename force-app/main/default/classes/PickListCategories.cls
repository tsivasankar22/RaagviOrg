public with sharing class PickListCategories {
    @AuraEnabled(cacheable=true)
    public static List<Groceries__c> fetchRecords(){
        try {
            List<Groceries__c> GrociesList = new List<Groceries__c>();
 
            GrociesList = [Select Type__c  from Groceries__c where Type__c ='fruits' Limit 2];              
            return GrociesList;
        } catch (Exception e) {
            System.debug('Exception======= '+e.getMessage());
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Groceries__c> fetch(){
        try {
            List<Groceries__c> GrociesList = new List<Groceries__c>();
 
            GrociesList = [Select Type__c  from Groceries__c where Type__c ='fruits'];              
            return GrociesList;
        } catch (Exception e) {
            System.debug('Exception======= '+e.getMessage());
            return null;
        }
    }
}