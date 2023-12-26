public with sharing class AccountSearchController {
    @AuraEnabled
    public static List<Account> searchAccountByName(String accountName) {
        System.debug('accountname====='+accountName);
        String searchKey = '%' + accountName + '%';
        List<Account> searchResults = [SELECT Id, Name, Industry, Phone, BillingCity FROM Account WHERE Name LIKE :searchKey LIMIT 10];
        System.debug('searchResults========'+searchResults);
        return searchResults;
    }
}