@isTest
private class CompareCurrentTimeMetaDataCountyTimeTest {
    @testSetup static void setupMethod(){
        List<Account> matchAccounts = new List<Account>();
        matchAccounts.add(new Account(Name = 'Matching Account 1', BillingCountry = 'Country A'));
        matchAccounts.add(new Account(Name = 'Matching Account 2', BillingCountry = 'Country A'));
        insert matchAccounts; 
    }
    @isTest
   static void testCompareCurrentTimeMetaDataCountyTime() {
        List<BillingCountryTime__mdt> metadataCounties = new List<BillingCountryTime__mdt>();
        metadataCounties.add(new BillingCountryTime__mdt(MasterLabel = 'Country A', ClosingTime__c = '18:00', TimeZone__c = 'America/New_York'));   
        Test.startTest();
        String cronExp = '0 0 0 * * ?'; // Schedule to run daily
        System.schedule('CompareCurrentTimeScheduler', cronExp, new CompareCurrentTimeMetaDataCountyTime());
        Test.stopTest();
    }
    @isTest
    static void testBatchProcessingExecuteMethodTest() {
       List<Account>  testAccounts =[select id,Name,BillingCountry from Account];
        CompareCurrentTimeMetaDataCountyTime batchProcessor = new CompareCurrentTimeMetaDataCountyTime();
        Test.startTest();
        batchProcessor.execute(null, testAccounts);
        Test.stopTest();
    }   
     @isTest
    static void StartMethod() {
      List<Account>  testAccounts =[select id,Name,BillingCountry from Account];
        CompareCurrentTimeMetaDataCountyTime batchProcessor = new CompareCurrentTimeMetaDataCountyTime();
        Test.startTest();
        batchProcessor.start(null);
        Test.stopTest();
    }  
    @isTest
    static void finishMethod(){
         CompareCurrentTimeMetaDataCountyTime batchProcessor = new CompareCurrentTimeMetaDataCountyTime();
        Test.startTest();
        batchProcessor.finish(null);
        Test.stopTest();
    }
}