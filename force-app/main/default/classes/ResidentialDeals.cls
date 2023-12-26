public with sharing class ResidentialDeals {
    @AuraEnabled(Cacheable = true)
    //this method doing search functionality
    //in search functionality it perform two thing 
    //1. search with filter
    //2.search without filters
    public static List<Residential_Loan_Application__c> sortDealsItem(String dataDisplay,String filterView){
        string userId = UserInfo.getUserId();
        String keyNameString = '%' + dataDisplay + '%';
     if((dataDisplay != null || dataDisplay!='') && (filterView ==null || filterView == '')){
        List<Residential_Loan_Application__c> rla1 = [
                                                        SELECT Id, Name, 
                                                                Broker__c, 
                                                                Borrower__c, 
                                                                Loan_Amount__c,
                                                                Loan_Status__c,
                                                                Rate__c,
                                                                LastViewedDate
                                                                FROM Residential_Loan_Application__c 
                                                               
                                                        ];
            System.debug('rla1>>>'+rla1);
            return [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           
                   ];
         }  
     else if((dataDisplay != null || dataDisplay!='') && filterView == 'All Deals'){
        List<Residential_Loan_Application__c> rla = [SELECT Id, Name,
                    Broker__c, 
                    Borrower__c, 
                    Loan_Amount__c,
                    Loan_Status__c,
                    Rate__c,
                    LastViewedDate
                    FROM Residential_Loan_Application__c Where Contact__r.User__c =:userId
                ];
            System.debug('data>>>'+rla);
            return [SELECT Id, Name,
                               Broker__c, 
                               Borrower__c, 
                               Loan_Amount__c,
                               Loan_Status__c,
                               Rate__c,
                               LastViewedDate
                               FROM Residential_Loan_Application__c Where Contact__r.User__c =:userId
                   ];
                  
        }        
            return null;     
    }
    //in this method contain filters 
    //filters based on picklist value
    @AuraEnabled(cacheable = true)
    public static List<Residential_Loan_Application__c> filterDeals (String filterView){
        List<Residential_Loan_Application__c> listOfDeals = new List<Residential_Loan_Application__c>();
         string userId = UserInfo.getUserId();
         List<Id> lastViewedIdList = new List<Id>();
         if(filterView == 'RecentlyViewed'){
         // Retrieve the object type dynamically       
         for(RecentlyViewed r : [SELECT Id FROM RecentlyViewed WHERE Type = 'Residential_Loan_Application__c']){
         lastViewedIdList.add(r.Id);
             
          }
        // System.debug('ids == >  '+lastViewedIdList);

         listOfDeals=[SELECT Id, Name, 
                                 Broker__c, 
                                 Borrower__c, 
                                 Loan_Amount__c,
                                 Loan_Status__c,Rate__c, 
                                 LastModifiedDate, 
                                 LastModifiedById, 
                                 LastViewedDate 
                                 FROM Residential_Loan_Application__c WHERE Id=:lastViewedIdList AND LastViewedDate >= LAST_N_DAYS:2
                                 ORDER BY LastViewedDate DESC ];
                   // System.debug([SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c, LastModifiedDate, LastModifiedById, LastViewedDate FROM Residential_Loan_Application__c WHERE Id=:lastViewedIdList ORDER BY LastViewedDate DESC]);
                }

                
        // String strquery = 'SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c, Rate__c, LastModifiedDate, LastModifiedById, LastViewedDate FROM Residential_Loan_Application__c ';
        // if(){
        //     strquery+='WHERE Loan_Status__c =\'Application\' AND '+Contact__r.User__c =:userId;
        // }
        // Database.Query(strquery)
     else if(filterView == 'Application'){ 
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Application' AND Contact__r.User__c =:userId
            ];   
        }
        else if(filterView == 'Commitment'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Commitment' AND Contact__r.User__c =:userId
            ];           
        }
        else if(filterView == 'Active'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Active' AND Contact__r.User__c =:userId
            ];         
        }
        else if(filterView == 'Paid Out'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Paid Out' AND Contact__r.User__c =:userId
            ];               
        }  
        else if(filterView == 'Void'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Void' AND Contact__r.User__c =:userId
            ];          
        }
        else if(filterView == 'Cancelled'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Cancelled' AND Contact__r.User__c =:userId
            ];        
        }
        else if(filterView == 'Decline'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c,
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c 
                           WHERE Loan_Status__c ='Decline' AND Contact__r.User__c =:userId
            ];         
        } 
       else if(filterView == 'All Deals'){
            listOfDeals = [
                SELECT Id, Name, 
                           Broker__c, 
                           Borrower__c, 
                           Loan_Amount__c,
                           Loan_Status__c,
                           Rate__c,
                           LastViewedDate
                           FROM Residential_Loan_Application__c  Where Contact__r.User__c =:userId
            ];  
        }
        System.debug('listOfDeals>>'+listOfDeals);
        return listOfDeals;
    }
 }