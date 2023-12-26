public with sharing class chatterMessageCenter {
    
    @AuraEnabled
    public static List<ChatterPostWrapper> getChatterPosts() {

        List<ChatterPostWrapper> chatterPosts = new List<ChatterPostWrapper>();
        
        // Query for Chatter posts and their comments
        List<FeedITem> feedItems = [SELECT Id, ParentId, Parent.Name, CreatedBy.Name, LastEditDate, Type, CreatedById, 
                                    (SELECT Id, CreatedDate, LastEditDate, CreatedById, CreatedBy.Name, CommentBody FROM FeedComments), 
                                    CommentCount, LikeCount, Title, Body FROM FeedItem where Type ='TextPost'];
                                                            System.debug('feedItems>>>'+feedItems);
           
                                            //                 List<Id> creId = new List<Id>();
                                            //                 System.debug('feedItems'+feedItems[0].FeedComments[0].Id);
                                            //                 for(Residential_Loan_Application__Feed item : feedItems){
                                            //                     Map<Id, FeedComment> myAnotherMap = new Map<Id, FeedComment>(item.FeedComments);
                                            //                     System.debug('myMap'+myAnotherMap.keySet());
                                            //                     for(String str :myAnotherMap.keySet()){
                                            //                         creId.add(str);
                                            //                         System.debug('str>>'+str);
                                            //                     }
                                            //                 }
                                            // System.debug('creId>>'+creId);
                                            // set<Id> credbyId = new Set<Id>();
                                            // for(FeedComment fecom  : [select Id,CreatedById from FeedComment where Id IN :creId]){
                                            //     System.debug('fecom>>'+fecom.CreatedById);
                                            //     credbyId.add(fecom.CreatedById);
                                            // }
                                            // List<String> nickName = new List<String>();
                                            // for(User u :[Select Id ,communityNickName from User Where Id IN :credbyId]){
                                            //     nickName.add(u.communityNickName);
                                               
                                            // }
                                            //  System.debug('nick name>>>'+nickName);
        // ConnectApi.FeedItemInput feedItemss  = AddBrokerDealNumber(feedItems);
      
        
        for (FeedITem item : feedItems) {
            ChatterPostWrapper wrapper = new ChatterPostWrapper();
            wrapper.post = item;
            wrapper.comments = new List<FeedComment>(item.FeedComments);
            // if( wrapper.comments !=null){
            //     wrapper.nickName = new List<String>(nickName);
            // }
            chatterPosts.add(wrapper);
        }
    //     for ( ConnectApi.FeedItemInput item : feedItemss) {
    //         ChatterPostWrapper wrapper = new ChatterPostWrapper();
    //         wrapper.post = feedItemss;
    //        wrapper.comments = new List<FeedComment>(item.FeedComments);
    //         if( wrapper.comments !=null){
    //             wrapper.nickName = new List<String>(nickName);
    //         }
    //         chatterPosts.add(wrapper);
    //    }
       System.debug('chatterPosts>>>'+chatterPosts);
    
        return chatterPosts;
    }
    // Wrapper class for Chatter posts and their comments
    public class ChatterPostWrapper {
        @AuraEnabled public FeedITem post {get;set;}
       @AuraEnabled public List<FeedComment> comments {get;set;}
       // @AuraEnabled public List<String> nickName {get;set;}
    }
    // public static ConnectApi.FeedItemInput AddBrokerDealNumber(List<Residential_Loan_Application__Feed> feedItems){
    //     System.debug('Inside the connectApi Method');
    //     String communityId = Network.getNetworkId();
    //     List<String> feedItemIds = new List<String>(); 
    //     Set<Id> setOfDealIds =  new Set<Id>();
    //     List<FeedComment> fecom;
    //     for (Residential_Loan_Application__Feed FObj : feedItems) { 
            
    //         if(FObj.Type != 'LinkPost'){
                
    //             //if(setOfBrokerMBMOURId.contains(FObj.InsertedById)){
    //             System.debug('inside the link post');
    //             feedItemIds.add(FObj.id);
    //             setOfDealIds.add(FObj.parentId);
    //             fecom = new List<FeedComment>(FObj.FeedComments);
    //             //}
    //         }
    //     }
    //     List<String> feedCommentIds = new List<String>(); 
    //     for(FeedComment FObj : fecom){
    //         feedCommentIds.add(FObj.Id);
    //     }
        
        
    //     //Get the  deal number and borrower name if post is updted
    //     // Map<Id, String> mapOfDealIdWithDealNumber = new Map<Id, String>();
    //     // Map<Id ,String> mapOfDealIdWithBorrowerName =new Map<Id ,String>();
        
    //     // Get all feed items passed into the trigger (Step #1).
    //     if(feedItemIds !=null){
    //         ConnectApi.BatchResult[] results = ConnectApi.ChatterFeeds.getFeedElementBatch(communityId, feedItemIds);       
    //         for (ConnectApi.BatchResult result : results) {
    //             if (result.isSuccess()) {
    //                 Object theResult = result.getResult();  
    //                 if (theResult instanceof ConnectApi.FeedItem) { 
    //                     ConnectApi.FeedItem item = (ConnectApi.FeedItem) theResult;
    //                     ConnectApi.ActorWithId relatedRecordId = (ConnectApi.ActorWithId) item.parent;
    //                     ConnectApi.UserSummary userSummary = (ConnectApi.UserSummary) item.actor;  
    //                     //if(userSummary.isInThisCommunity){

    //                     ConnectApi.FeedItemInput input = ConnectApiHelperForMovedChatter.createFeedItemInputFromBody(item.body);
    //                     return input;
    //                     //  try{
                            
    //                     //     //ConnectApi.ChatterFeeds.updateFeedElement(communityId, item.id, input);
    //                     //     System.debug('ConnectApi.ChatterFeeds.updateFeedElement(communityId, item.id, input)>>'+ConnectApi.ChatterFeeds.updateFeedElement(communityId, item.id, input));
    //                     // }
    //                     // catch(Exception e){
                            
    //                     //      // Do nothing
    //                     // }
                        
    //                     // }                    
    //                 }//else {                    
    //                 // Do nothing. Posting other feed element types isn't supported.                    
    //                 // }                
    //             }else {                
    //                 // Do nothing
    //             }            
    //         }        
            
    //     }if(feedCommentIds !=null){
    //       ConnectApi.BatchResult[] results = ConnectApi.ChatterFeeds.getCommentBatch(communityId, feedCommentIds);     
    //     for (ConnectApi.BatchResult result : results) { 
    //         if (result.isSuccess()) {     
    //             Object theResult = result.getResult();
                
    //             if (theResult instanceof ConnectApi.comment) { 
    //                 ConnectApi.comment item = (ConnectApi.comment) theResult;                    
    //                 ConnectApi.Reference relatedRecordId = (ConnectApi.Reference) item.parent;
    //                 ConnectApi.UserSummary userSummary = (ConnectApi.UserSummary) item.user;  
    //                 //if(userSummary.isInThisCommunity){
                        
    //                    ConnectApi.CommentInput input = ConnectApiHelperForMovedChatter.createCommentInputFromBody(item.body); 
    //                     try
    //                     {
    //                         //ConnectApi.ChatterFeeds.updateComment(communityId, item.id, input);
    //                           System.debug('ConnectApi.ChatterFeeds.updateComment(communityId, item.id, input)>>'+ConnectApi.ChatterFeeds.updateComment(communityId, item.id, input));
    //                     }
    //                     catch(Exception e) 
    //                     {
    //                         // Do nothing
    //                     }
            

    //                 //}        
    //             }//else { 
                    
    //                 // Do nothing. Posting other feed element types isn't supported.                    
    //            // }                
    //         }else {        
    //             // Do nothing
    //         }   
    //     }  
    // }
    // return null;
        
    // }
}