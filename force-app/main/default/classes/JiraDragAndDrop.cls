public with sharing class JiraDragAndDrop {
    @AuraEnabled
    public static List<Candidate__c> getAllTask(){
        
        Id loggedInUserId = UserInfo.getUserId();
        return [Select Id, Task_Name__c,Status__c,Candidate__c,CTC_Number__c from Candidate__c where OwnerId = :loggedInUserId];
    }
    
    @AuraEnabled
    public static void updateTask(Id newTaskId, String newStatus){
        Candidate__c updateTask = new Candidate__c(Id = newTaskId, Status__c = newStatus);
        system.debug('newStatus========'+newStatus);
        Database.update(updateTask);
        System.debug('update task ========'+updateTask);
    }
}