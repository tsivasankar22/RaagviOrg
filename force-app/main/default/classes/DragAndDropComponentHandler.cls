public with sharing class DragAndDropComponentHandler {
    @AuraEnabled
    public static List<Task> getAllTask(){
        
       // Id loggedInUserId = UserInfo.getUserId();
        return [Select Id,OwnerId, Owner.Name, Subject,Description, Status, WhoId, WhatId, Who.Name, What.Name from Task ];
    }

    @AuraEnabled
    public static void updateTask(Id newTaskId, String newStatus){
        System.debug('status==========='+newStatus);
        Task updateTask = new Task(Id = newTaskId, Status = newStatus);
        Database.upsert(updateTask);
        System.debug('updateTask==========='+updateTask);
    }
    @AuraEnabled
    public static void DataInsert(Task newlist) {
        insert newlist;

    }
    @AuraEnabled(cacheable=true)
    public static List<User> fetchUsers(){
        Id userIdFetch = [select id From profile where Name ='System Administrator'].Id;
        System.debug('ids'+userIdFetch);

        List<User> userProfile = [select id,Name from User where ProfileId =: userIdFetch];
        return userProfile;
    }
}