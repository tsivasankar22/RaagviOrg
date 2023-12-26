public class CTC_ContactUsPageCtrl {
    public class wrapContactUsDetail{
        @AuraEnabled
        @TestVisible
        public UW_Team_Assignment__mdt accounOwnerDetail;
        @AuraEnabled
        @TestVisible
        public Boolean Bool;
        @AuraEnabled
        @TestVisible
        public String url;
        public wrapContactUsDetail(UW_Team_Assignment__mdt accounOwnerDetail, Boolean Bool, String url){
            this.accounOwnerDetail = accounOwnerDetail;
            this.Bool = Bool;
            this.url = url;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static wrapContactUsDetail getLoggedinUserAccountInfo(){
        String loggedInContactId='';
        String UWTeamAssignment='';
        UW_Team_Assignment__mdt UWDetail;
         for(User userObj : [SELECT Id, ContactId FROM User 
                             WHERE Id =:userInfo.getUserId() LIMIT 1]){
                                loggedInContactId =  userObj.ContactId;
                                
                             }
        if(loggedInContactId != '' || loggedInContactId != null){
            for(Contact obj : [SELECT ID, UW_Team_Assignment__c 
                                FROM Contact 
                                WHERE Id =: loggedInContactId]){
                                    UWTeamAssignment = obj.UW_Team_Assignment__c;
            }
            
        }
        if(UWTeamAssignment != null){
            for(UW_Team_Assignment__mdt obj : [SELECT ID, UW_Team_API_Name__c, UW_Team_Name__c,
                                               UW_Name__c, UW_Title__c, UW_Phone__c, UW_Email__c 
                                               FROM UW_Team_Assignment__mdt 
                                               WHERE UW_Team_Name__c =: UWTeamAssignment LIMIT 1]){
                                                   UWDetail =  obj;
                                               }
        }
                
        if(UWDetail != null ){
            Set<Id> contactusFolderId =  new Set<Id>();

            for(ContentWorkSpace obj : [SELECT Id, Name  
                                        FROM ContentWorkSpace 
                                        WHERE  Name='ProfilePictureForUser']){
                                            contactusFolderId.add(obj.Id);
                                            
                                        }
            Id contactUsPageImageId;
            
            for(ContentDocument obj : [SELECT ID, FileType,LatestPublishedVersionId, Title, ParentId,LastModifiedDate
                                       FROM ContentDocument 
                                       WHERE ParentId IN : contactusFolderId AND Title =: UWDetail.UW_Team_API_Name__c]){
                                           contactUsPageImageId = obj.ID;  
                                       }
            return new wrapContactUsDetail(UWDetail, true, (String)contactUsPageImageId);
        }else{
            return new wrapContactUsDetail(null, false, null);
        }
    }
}