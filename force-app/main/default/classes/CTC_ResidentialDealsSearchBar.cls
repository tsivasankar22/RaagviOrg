public with sharing class CTC_ResidentialDealsSearchBar {
   @AuraEnabled(Cacheable = true)
   public static List<SObject> sortDealsItem(String dataDisplay ,String ObjName){
        string userId = UserInfo.getUserId();
        String keyNameString = '%' + dataDisplay + '%';
        if(ObjName == 'Residential_Loan_Application__c'){
            List<Residential_Loan_Application__c> residentialqueryList = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c, Loan_Status__c, Rate__c FROM Residential_Loan_Application__c Where (Broker__c LIKE :keyNameString OR Borrower__c Like :keyNameString OR Name Like :keyNameString OR Loan_Status__c Like :keyNameString) AND Contact__r.User__c =:userId];
            return residentialqueryList;
        }
        else if(ObjName == 'Contact'){
            List<Contact> conQueryList = [SELECT Id, Name FROM Contact WHERE Name LIKE :keyNameString];
            return conQueryList;
        }
        else if(ObjName == 'All')
        {          
           List<Residential_Loan_Application__c> residentialquery = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c, Loan_Status__c, Rate__c FROM Residential_Loan_Application__c Where (Broker__c LIKE :keyNameString OR Borrower__c Like :keyNameString OR Name Like :keyNameString OR Loan_Status__c Like :keyNameString) AND Contact__r.User__c =:userId];
            List<Contact> conQuery = [SELECT Id, Name FROM Contact WHERE Name LIKE :keyNameString];
            List<sObject> results = new List<sObject>();
            results.addAll(residentialquery);
            results.addAll(conQuery);
           
            if(dataDisplay != null || dataDisplay!='')
            {
                System.debug('Query In Else ===== >'+results);
                return results;
            }
        }   
     return null;  
    }   
    // @AuraEnabled(cacheable=true)
    // public static List<sObject> searchObjects(String dealsName) {
    //     List<sObject> results = new List<sObject>();
        
    //     // Query Residential Loan Applications
    //     List<Residential_Loan_Application__c> rlApps = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c, Loan_Status__c, Rate__c 
    //                                                     FROM Residential_Loan_Application__c 
    //                                                     WHERE (Broker__c LIKE :('%' + dealsName + '%')  OR Borrower__c Like :('%' + dealsName + '%')  OR Name Like :('%' + dealsName + '%')  OR Loan_Status__c Like :('%' + dealsName + '%') )
    //                                                     AND Contact__r.User__c = :UserInfo.getUserId()];
    //     results.addAll(rlApps);
        
    //     // Query Contacts
    //     List<Contact> contacts = [SELECT Id, Name, Email, Phone 
    //                                 FROM Contact 
    //                                 WHERE (Name LIKE :('%' + dealsName + '%') OR Email LIKE :('%' + dealsName + '%') OR Phone LIKE :('%' + dealsName + '%'))
    //                                ];
    //     results.addAll(contacts);
        
    //     return results;
    // }
}