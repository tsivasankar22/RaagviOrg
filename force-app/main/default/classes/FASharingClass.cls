public class FASharingClass {
    public static void shareFaToBroker(List<Financial_Account__c> fa){
        
        System.debug('FA>>>>'+fa);
        List<Financial_Account__Share> jobShrs  = new List<Financial_Account__Share>();
        
        
         Map<Id, Id> mapOfContactId =  new Map<Id, Id>();
         for(User userObj : [Select Id,contactId,isActive From User]) {
            if(userObj.isActive) {
               // userIdSet.add(userObj.Id); 
                mapOfContactId.put(userObj.contactId, userObj.Id); 
            }
        }
        
        
        for(Financial_Account__c fAObj :fa){
            System.debug('Broker User ID>>>'+fAObj.Broker__c);
            System.debug('Map User ID>>>'+mapOfContactId.get(fAObj.Broker__c));
            Financial_Account__Share managerShr = new Financial_Account__Share();
            managerShr.ParentId = fAObj.Id;
            managerShr.UserOrGroupId = mapOfContactId.get(fAObj.Broker__c);
            managerShr.AccessLevel = 'Read';
            jobShrs.add(managerShr);
            
        }
        // do the DML to create shares
        System.debug('jobShrs>>>>'+jobShrs);
        if(!jobShrs.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(jobShrs,false);    
        }
    }
    
}