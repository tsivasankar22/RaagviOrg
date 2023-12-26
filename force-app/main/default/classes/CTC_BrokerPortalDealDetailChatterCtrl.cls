public with sharing class CTC_BrokerPortalDealDetailChatterCtrl {
    @AuraEnabled
    public static String  getResList(String recordId) {

        Residential_Loan_Application__c  resObj = [SELECT Id, Loan_Status__c 
                                              FROM Residential_Loan_Application__c  
                                              WHERE Id =: recordId limit 1];
        if(resObj.Loan_Status__c =='Active' || resObj.Loan_Status__c =='Paid-out'){
            
            return (String)[SELECT ID FROM Financial_Account__c WHERE Residential_Loan_Application__c =:recordId].Id;
        }else{
            return (String)recordId;
        }
    }
}