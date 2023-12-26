public with sharing class IdentityVerificationStatusHandler {
    @AuraEnabled
    public static string doSubmit(string userid, string appid, String identityVerificationStatus){
        system.debug('userid====>'+ userid);
        system.debug('appid====>'+ appid);
        system.debug('identityVerificationStatu====>'+ identityVerificationStatus);
        string appname;
        List<Residential_Loan_Application__c> lapp = [select id, Name from Residential_Loan_Application__c where Id =: appid];
        
        system.debug('lapp'+ lapp);
        
        if(lapp.size() > 0) {
            appname =  lapp[0].Name;
        }
        system.debug('appname===>'+ appname);
        return null;
    }
    @AuraEnabled
    public static String UpdateIdentityVerification(String applicationId, String status){
        Residential_Loan_Application__c applicationList = [SELECT Id,Identity_Verification_Status__c,Name
                                                           FROM Residential_Loan_Application__c
                                                  		   WHERE Id=:applicationId];

        applicationList.Identity_Verification_Status__c = status;
        Update applicationList;
        return status;
    }

}