@isTest
private class CreateCaseAndTaskSchedulerTest {
    @isTest
    static void testSchedulable() {
        // Create a Mentor Queue
        Group mentorGroup = new Group(Name='Mentors', Type='Queue');
        insert mentorGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId())) {
            QueuesObject testQueue = new QueueSObject(QueueID = mentorGroup.Id, SObjectType = 'Case');
            insert testQueue;
        }
        Case mentorCase = new Case();
        mentorCase.Subject = 'Test Case';
        mentorCase.Status = 'Open';
        mentorCase.OwnerId = mentorGroup.Id;
        insert mentorCase;
        
        // Instantiate the CreateCaseAndTaskScheduler class
        CreateCaseAndTaskScheduler scheduler = new CreateCaseAndTaskScheduler();
        
        // Test the Schedulable aspect
        Test.startTest();
        String cronExp = '0 0 * * * ?'; // Run every hour
        System.schedule('Test Job', cronExp, scheduler);
        Test.stopTest();
        
        // Verify the job is scheduled
        List<CronTrigger> cronTriggers = [SELECT Id, CronExpression, State FROM CronTrigger WHERE CronJobDetail.Name = 'Test Job'];
        System.assertEquals(1, cronTriggers.size(), 'Batch job not scheduled');
        System.assertEquals('WAITING', cronTriggers[0].State, 'Batch job not in waiting state');
    }
    
    @isTest
    static void testBatchable() {
        // Create a Mentor Queue
        Group mentorGroup1 = new Group(Name='Mentors', Type='Queue');
        insert mentorGroup1;
         System.runAs(new User(Id=UserInfo.getUserId())) {
            QueuesObject testQueue1 = new QueueSObject(QueueID = mentorGroup1.Id, SObjectType = 'Case');
            insert testQueue1;
        }
        
        // Create a Case owned by Mentor Queue
        Case mentorCase = new Case();
        mentorCase.Subject = 'Test Case';
        mentorCase.Status = 'Open';
        mentorCase.OwnerId = mentorGroup1.Id;
        insert mentorCase;
        
        // Create a Support Queue
        Group supportGroup = new Group(Name='Support', Type='Queue');
        system.debug('supportGroup========'+supportGroup);
        insert supportGroup;
        
        // Instantiate the CreateCaseAndTaskScheduler class
        CreateCaseAndTaskScheduler scheduler = new CreateCaseAndTaskScheduler();
        
        // Test the Batchable aspect
        Test.startTest();
        Database.executeBatch(scheduler);
        Test.stopTest();
        
        // Verify the task is created and case is closed
        List<Task> tasks = [SELECT Id, OwnerId, WhatId FROM Task WHERE WhatId = :mentorCase.Id];
        System.debug('tasks======'+tasks);
        System.debug('supportGroup.Id======'+supportGroup.Id);
         System.debug('tasks[0].OwnerId======'+tasks[0].OwnerId);
        System.assertEquals(1, tasks.size(), 'Task not created');
        System.assertEquals('00G5i000002D8GWEA0', tasks[0].OwnerId, 'Task owner incorrect');
        
        List<Case> updatedCases = [SELECT Id, Status FROM Case WHERE Id = :mentorCase.Id];
        System.assertEquals(1, updatedCases.size(), 'Case not found');
        System.assertEquals('Closed', updatedCases[0].Status, 'Case status not updated');
    }
}