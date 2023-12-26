public with sharing class MyFirstApexClass
{
    @AuraEnabled(Cacheable=true)
    public static Residential_Loan_Application__c[] getAllEvents(Id accId)
    {
        System.debug('id'+accId);
        System.debug('return=============='+[SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c FROM Residential_Loan_Application__c WHERE Contact__c=:accId]);
        return [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c FROM Residential_Loan_Application__c WHERE Contact__c=:accId];
    }
}