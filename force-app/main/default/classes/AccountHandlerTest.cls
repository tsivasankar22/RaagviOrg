@isTest
private class AccountHandlerTest {
    @testSetup static void InsertRecord(){
        Account acc12= new Account();
        acc12.Name='sankar';
        acc12.Phone='9676191827';  
        insert acc12;
        Account acc3=new Account();
        acc3.Name='sankaraaa';
        insert acc3;
    }
    @isTest
    static void insertNewAccount1(){
        Account acc1=[select id,Name from Account where Name='sankar'];
        Account acc = AccountHandler.insertNewAccount(acc1.Name);
        System.assertEquals('sankar', acc.Name);
    }
    @isTest
    static void catchNewAccount(){
        Account acc = AccountHandler.insertNewAccount(null);
        System.assertEquals(null, acc);
    }
    @isTest
    static void getallAccount(){
        List<Account> acc2=[select id,Name,phone from Account];
        List<Account> accList = AccountHandler.getAllAccount();
        System.assertEquals(2,accList.size());
    }
    @isTest
    static void deleAccount()
    {
        List<Account> accIds = [SELECT Id, Name, Phone FROM Account WHERE Name LIKE '%sankar%'];
        List<String> accountIdList = new List<String>();
        for(Account strAccIds : accIds)
        {
            accountIdList.add(strAccIds.Id);
        }
        AccountHandler.delAccount(accountIdList);
    }
    @isTest
    static void catchDelete(){
         List<Account> accIds = [SELECT Id, Name, Phone FROM Account WHERE Name LIKE '%jessu%' limit 0];
        List<String> accountIdList = new List<String>();
        if(accIds.size()<0){
            for(Account strAccIds : accIds)
        {
            accountIdList.add(strAccIds.Id);
        }
        }
        AccountHandler.delAccount(accountIdList);
    }
}