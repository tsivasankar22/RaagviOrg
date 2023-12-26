public with sharing class CustomRecordDetailPage {
    @AuraEnabled(cacheable=true)
    public static Account getAccount(String recordId) {
        try {
           
            Account accQuery = [select id,AccountNumber, Amount__c, AnnualRevenue, Phone, Name, Description from Account Where Id =: recordId];
            System.debug('accQuery'+accQuery);
            return accQuery;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}