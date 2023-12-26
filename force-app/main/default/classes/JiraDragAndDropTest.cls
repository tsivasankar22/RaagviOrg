@isTest
public class JiraDragAndDropTest {
     @testSetup
    static void JiraTest(){
         User testUser = new User(
            Alias = 'pk',
            Email = 'pkps@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testpk@test.com'
        );
        insert testUser;
       Candidate__c testTask = new Candidate__c(
            Task_Name__c = 'Test Task',
            Status__c = 'Done',
            OwnerId = testUser.Id,
            CTC_Number__c = '10000',
           Candidate__c='SAnkara'
        );
        insert testTask;
        
    }
    @isTest
    static void testGetAllTask() {
        Test.startTest();
        
        List<Candidate__c> taskList = JiraDragAndDrop.getAllTask();
        System.debug('taskList------------'+taskList);
        
        System.assertEquals(0, taskList.size());
        System.assertEquals('Test Task', taskList[0].Task_Name__c);
        System.assertEquals('Done', taskList[0].Status__c);
        System.assertEquals('10000', taskList[0].CTC_Number__c);
        
        Test.stopTest();
    }
    /*  @isTest
    static void testUpdateTask() {
        Test.startTest();
        
        List<Candidate__c> taskList = JiraDragAndDrop.getAllTask();
        System.assertEquals(1, taskList.size());
        
        JiraDragAndDrop.updateTask(taskList[0].Id, 'Done');
        
        List<Candidate__c> updatedTaskList = JiraDragAndDrop.getAllTask();
        System.assertEquals(0, updatedTaskList.size());
        System.assertEquals('Done', updatedTaskList[0].Status__c);
        
        Test.stopTest();
    } */
}