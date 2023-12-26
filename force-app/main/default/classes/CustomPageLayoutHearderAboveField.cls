//public with sharing class CustomPageLayoutHearderAboveField {
    
//     @AuraEnabled(cacheable=true)
//     public static Contact aboveHeader(String recordId){
//     Contact con=[select id,S1__c, S2__c, S3__c, S4__c, RF_1_1__c, RFS2__c, User_Department__c, Originator__c from Contact where Id=:recordId];
//     return con;
//    }
//}
public with sharing class CustomPageLayoutHearderAboveField {
    public String selectedaccId { get; set; }
    List<SelectOption> options = new List<SelectOption>();

    public CustomPageLayoutHearderAboveField() {
        selectedaccId = '';
    }

    public List<SelectOption> getListOfAccount() {
        options.add(new SelectOption('', '--Select--'));
        for (Contact acc : [SELECT Id, Name FROM Contact]) {
            options.add(new SelectOption(acc.Id, acc.Name));
        }
        return options;
    }
}
