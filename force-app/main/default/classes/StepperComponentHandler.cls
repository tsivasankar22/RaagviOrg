public with sharing class StepperComponentHandler {
    @AuraEnabled(Cacheable=true)
       public static Case[] getAllEvents(Id accId) {
        System.debug('id'+accId);
          return [SELECT CaseNumber, Id,Subject FROM Case WHERE AccountId=:accId];
       }

    @AuraEnabled(cacheable=true)
    public Static list<Contact> getcontact(ID accId){
          Return[SELECT Name,
                        Phone,
                        Email FROM Contact 
                        WHERE AccountId=:accId];
                        
   }
      @AuraEnabled(cacheable=true)
           public static list<Contact> getselectedcontact(Id selectingId){
         System.debug('checkboxid========================'+selectingId);
          system.debug([SELECT Id,Name,Email,Phone FROM Contact WHERE Id=:selectingId]);
           return[SELECT Id,Name,Email,Phone FROM Contact WHERE Id=:selectingId limit 1];
}
@AuraEnabled(cacheable=true)
   public static Case[] getCase(Id accId) {
    System.debug('id'+accId);
      return [SELECT CaseNumber, Id,Subject,LastViewedDate FROM Case WHERE AccountId=:accId ORDER BY LastViewedDate DESC NULLS LAST] ;
  
   }
}