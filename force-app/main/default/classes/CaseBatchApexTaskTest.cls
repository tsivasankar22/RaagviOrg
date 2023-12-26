@isTest
    public class CaseBatchApexTaskTest
    {
        @isTest
        public static void CaseBatchApexTask()
        {
            List<Case> caselist = new List<Case>();
             Case caselist1=new Case();
           caselist1.Status = 'Working';
            caselist1.Origin = 'Email';
            caselist1.Priority = 'High';
        
            caselist.add(caselist1);
       
        insert caselist;
        
        
        Test.startTest();
        CaseBatchApexTask Caselist2 = new CaseBatchApexTask();
        Database.executeBatch(caselist2);
        Test.stopTest();
        Case newcase =  [Select Status, Origin, Priority FROM Case limit 1];
        System.assertEquals(newcase.Origin,'Email');

        }
    }