@isTest
public class CaseTaskSchedulerTest {
    @isTest
    static void CaseTaskTestMethod(){
        //creating test data
        Group testGroup = new Group(Name='Mentors', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        
        Case newCase = new Case();
        newCase.Reason='Installation';
        newCase.Subject = 'okok';
        newCase.SuppliedName = 'sankar';
        newCase.SuppliedEmail = 'tsivasankara21@gmail.com';
        newCase.Description='OK Boss';
        newCase.Status = 'Open';
        newCase.OwnerId = testGroup.Id;
        insert newCase;
        // Call the method to be tested
        Test.startTest();
        CaseTaskScheduler.createCase(newCase.Subject,newCase.SuppliedName, newCase.SuppliedEmail, newCase.Reason, newCase.Description);
        Test.stopTest();    
    }
    
}