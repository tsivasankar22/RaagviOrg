public with sharing class ValidationButtons {
    @AuraEnabled
    public static void Buttons(RegistractionForm__c newlist) {
        insert newlist;

    }
}