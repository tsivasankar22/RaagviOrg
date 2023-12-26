public class AccountHandler{
    public static Account insertNewAccount(String accountName){  
        Account acctToBeInserted = new Account(Name=accountName);    
        try{
            insert acctToBeInserted;
        }catch(DMLException e){
            System.debug('Inside DMLException catch ,error is ' + e.getMessage());
            acctToBeInserted = NULL;   
            }
       return acctToBeInserted;                 
       }
       @AuraEnabled
    public static List<Account> getAllAccount(){
        return [SELECT Id,Name,Phone FROM Account];
    }  
    @AuraEnabled
    public static String delAccount(String[] lstAccountId){
        string msg='';
        List<Account> lstAcc=[SELECT Id FROM Account WHERE Id IN: lstAccountId];
        try{
            if(lstAcc.size()>0)
                delete lstAcc;
        }
        catch(Exception ex){
            msg=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
        }
        return msg;
    }
}