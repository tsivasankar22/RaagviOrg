public with sharing class UserProfilePictureShow {   
    public class WrapperClassProfilepic{
        @AuraEnabled
        public Contact_Setting__mdt RecordOwnerDetails;
        @AuraEnabled
        public Boolean Bool;
        @AuraEnabled
        public String url;
        public WrapperClassProfilepic(Contact_Setting__mdt RecordOwnerDetails, Boolean Bool, String url){
            this.RecordOwnerDetails = RecordOwnerDetails;
            this.Bool = Bool;
            this.url = url;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static WrapperClassProfilepic  UserProfileShow (){
        String UserContactId='';
        String AssignValueToUser='';
        String   staticresourceId='';
        Contact_Setting__mdt MetaDataDetails;
        for(User userObj : [SELECT Id, ContactId FROM User 
                            WHERE Id =:userInfo.getUserId() LIMIT 1]){
                                UserContactId =  userObj.ContactId;
                                System.debug('User>>>>>>>>>'+userObj);
                                System.debug('UserContactId>>'+UserContactId);
                            }
        System.debug('user object'+UserContactId);
        if(UserContactId != '' || UserContactId != null){
            for(Contact obj : [SELECT ID, BDM_Assign_To__c 
                               FROM Contact 
                               WHERE Id =: UserContactId]){
                                   AssignValueToUser = obj.BDM_Assign_To__c; //assign to particular user
                                   
                               }
            System.debug('contact login id '+AssignValueToUser);  //selected value
            
        }
        System.debug('assign '+AssignValueToUser);
        if(AssignValueToUser != null){
            for(Contact_Setting__mdt obj : [select ID,UserName__c,UserProfilePic__c,UserEmail__c,UserTitle__c,UserPhone__c from Contact_Setting__mdt 
                                            WHERE UserName__c =: AssignValueToUser LIMIT 1]){
                                                MetaDataDetails =  obj;
                                            }
            System.debug('meta data details ===='+MetaDataDetails);
        }
        
        
        if(MetaDataDetails != null ){
            Set<Id> WorkspaceFolderId =  new Set<Id>();
            System.debug('i am in inside of an a meta data details ');
            List<ContentWorkSpace> obj1 = [SELECT Id, Name FROM ContentWorkSpace];
            System.debug('obj<========>'+obj1);
            for(ContentWorkSpace obj : [SELECT Id, Name  
                                        FROM ContentWorkSpace where Name ='ProfilePictureForUser' ]){
                                            System.debug('i am in inside of an a meta data details Queoery'); 
                                            System.debug('obj.Id====== '+obj.Id);
                                            WorkspaceFolderId.add(obj.Id);
                                            System.debug('WorkspaceFolderId=========='+WorkspaceFolderId);
                                            
                                        }
            Id ImageUrlContentDocument;
            System.debug('i am in a meta of content document ');
            for(ContentDocument obj : [SELECT ID, FileType,LatestPublishedVersionId, Title, ParentId,LastModifiedDate
                                       FROM ContentDocument 
                                       WHERE Title =: MetaDataDetails.UserName__c]){
                                           ImageUrlContentDocument = obj.ID;  
                                           System.debug('obj==========='+ [SELECT ID, FileType,LatestPublishedVersionId, Title, ParentId,LastModifiedDate
                                                                           FROM ContentDocument 
                                                                           WHERE Title =: MetaDataDetails.UserName__c]);
                                       }
            
            return new WrapperClassProfilepic(MetaDataDetails, true, (String)ImageUrlContentDocument);
        }else{
            return new WrapperClassProfilepic(null, false, null);
        }
    }
    
}