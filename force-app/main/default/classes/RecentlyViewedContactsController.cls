public with sharing class RecentlyViewedContactsController 
{
    //this method returns a data table format of current user records 
    @AuraEnabled(cacheable = true)
    public static List<Residential_Loan_Application__c> getCurrentUserRecords(String userId,String objectApiName)
    {
        List<Residential_Loan_Application__c> listOfDeals = new List<Residential_Loan_Application__c>();
        //string userId = UserInfo.getUserId();
        System.debug('userID====>'+userId);
        System.debug('objectApiName===>'+objectApiName);
        listOfDeals = [
                    SELECT Id, Name, 
                            Broker__c, 
                            Borrower__c, 
                            Loan_Amount__c,
                            Loan_Status__c,
                            Rate__c,
                            LastViewedDate
                            FROM Residential_Loan_Application__c  Where Contact__r.User__c =:userId
                ];  
                System.debug('listOfDeals======>'+listOfDeals);
                return listOfDeals;
    }
    @AuraEnabled
    public static String userId()
    {
        // get the current user's contact Id
        Id ids =[SELECT ContactId FROM User WHERE Id=:UserInfo.getUserId()].ContactId;
        return ids;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> recordInsert(String objectName) {
        List<String> fieldNames = new List<String>();
        try {
            // Retrieve the object metadata
            Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
            // Iterate through the fields and add their API names to the list
            for (Schema.SObjectField field : describeResult.fields.getMap().values()) {
                fieldNames.add(field.getDescribe().getName());
            }
        } catch (Exception ex) {
            System.debug('Error in recordInsert====>'+ex);
            // Handle any exceptions
            // You might want to log the exception or return an error message to the Lightning component
        }
        return fieldNames;
    }
}