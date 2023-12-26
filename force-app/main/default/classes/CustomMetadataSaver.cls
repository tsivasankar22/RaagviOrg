public with sharing class CustomMetadataSaver {
    @InvocableMethod
    public static void updateMetadataRecord(List<FlowInput> inputs) {
        System.debug('inputs--------'+inputs);
        List<String> billingCountryTimeValues = new List<String>();
        List<String> closingTimeValues = new List<String>();
        
        for (FlowInput input : inputs) {
            billingCountryTimeValues.add(input.billingCountryTime);
            closingTimeValues.add(input.closingTime);
        }
        System.debug('billingCountryTimeValues--------'+billingCountryTimeValues);
        System.debug('closingTimeValues-------------'+closingTimeValues);
        List<BillingCountryTime__mdt> recordsToUpdate = [SELECT Id, DeveloperName, MasterLabel, ClosingTime__c FROM BillingCountryTime__mdt WHERE ClosingTime__c IN :billingCountryTimeValues]; //DeveloperName IN :billingCountryTimeValues];
        List<BillingCountryTime__mdt> recList=new List<BillingCountryTime__mdt>();
        System.debug('recordsToUpdate--------'+recordsToUpdate);
        for (BillingCountryTime__mdt record : recordsToUpdate) {
            // Update the ClosingTime__c field directly
            record.ClosingTime__c = closingTimeValues.get(billingCountryTimeValues.indexOf(record.ClosingTime__c));
            System.debug('record--------'+record);
            recList.add(record);
        }
      
       // update recList;
    }
    
    public class FlowInput {
        @InvocableVariable(required=true)
        public String billingCountryTime;
        @InvocableVariable(required=true)
        public String closingTime;
    }
}