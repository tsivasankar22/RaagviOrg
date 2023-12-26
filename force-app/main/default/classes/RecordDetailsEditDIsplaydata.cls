public with sharing class RecordDetailsEditDIsplaydata {
    @AuraEnabled(cacheable=true)
   public static Financial_Account__c getDataOfFA(String recordId){
    Financial_Account__c getFAData=[select id, Broker__r.Name, Status__c, Name,CreatedBy.Name,LastModifiedBy.Name,Owner.Name,Residential_Loan_Application__r.Name  from Financial_Account__c where Id=:recordId];
    return getFAData;
   } 

}