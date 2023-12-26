public with sharing class AccountDetailPageComponentEditFunction {
    // @AuraEnabled(cacheable=true)
    // public static Account getAccountRecordMethod(String recordIdAccount) {
    //     Account accRecordDetails=[select id,Name, Phone,Rating, Industry, AnnualRevenue, Type from account where Id=:recordIdAccount ];
    //     System.debug('record Details--------'+accRecordDetails);
    //   return accRecordDetails;    
    // }
    @AuraEnabled(cacheable=true)
    public static Task taskCode(String recordIdAccount) {
        Task accRecordDetails=[SELECT Id, Status, Subject, Priority, Description, AccountId, CallType, TaskSubtype, Description__c FROM Task where Id=:recordIdAccount ];
        System.debug('record Details--------'+accRecordDetails);
      return accRecordDetails;   
    }
    //   @AuraEnabled
    // public static void updateAccount(String recordId, Map<String, Object> fieldsToUpdate) {
    //     Account accToUpdate = new Account(Id = recordId);
    //     if (fieldsToUpdate.containsKey('Name')) {
    //         accToUpdate.Name = (String)fieldsToUpdate.get('Name');
    //     }
    //     if (fieldsToUpdate.containsKey('Phone')) {
    //         accToUpdate.Phone = (String)fieldsToUpdate.get('Phone');
    //     }
    //     update accToUpdate;
    // }  
    @AuraEnabled
    public static void updateTask(String recordId, Map<String, Object> fieldsToUpdate) {
        System.debug('iD----------'+recordId);       
        Task accToUpdate = new Task(Id = recordId);
        if (fieldsToUpdate.containsKey('Description')) {
            accToUpdate.Description = (String)fieldsToUpdate.get('Description');
        }
        if (fieldsToUpdate.containsKey('Description__c')) {
            accToUpdate.Description__c = (String)fieldsToUpdate.get('Description__c');
        }
        System.debug('fieldsToUpdate----------'+accToUpdate);
        update accToUpdate;  
    }
}