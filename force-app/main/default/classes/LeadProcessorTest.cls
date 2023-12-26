@isTest
public with sharing class LeadProcessorTest {
    @isTest
    public static void testBatch() {
        List<Lead> lList = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead();
            l.LastName = 'Batch'+i;
            l.company = 'Company';
            l.status = 'Random';
            lList.add(l);
        }
        insert lList;
        
        Test.startTest();
        LeadProcessor leads = new LeadProcessor();
        Id batchId = Database.executeBatch(leads);
        Test.stopTest();
    }
}