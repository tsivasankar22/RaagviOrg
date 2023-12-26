public with sharing class LWCInlineCtrl {
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccounts(){
        return [SELECT Id, Name, Type, Phone 
                FROM Account WHERE Type !='' LIMIT 10];       
    }
}