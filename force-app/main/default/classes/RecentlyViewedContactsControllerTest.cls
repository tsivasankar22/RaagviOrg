@isTest
public class RecentlyViewedContactsControllerTest {

    @isTest
    static void testGetCurrentUserRecords() {
        // Create test data
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

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            User__c = testUser.Id
        );
        insert testContact;

        Residential_Loan_Application__c testDeal = new Residential_Loan_Application__c(
            Name = 'Test Deal',
            Broker__c = 'Test Broker',
           // Borrower__c = testContact.Id,
            Borrower__c = testContact.Id,
            Loan_Amount__c = 100000,
            Loan_Status__c = 'Void',
            Rate__c = 3.5,
            Contact__c = testContact.Id
        );
        insert testDeal;

        // Call the method to be tested
        Test.startTest();
        List<Residential_Loan_Application__c> deals = RecentlyViewedContactsController.getCurrentUserRecords(testUser.Id, 'Residential_Loan_Application__c');
        Test.stopTest();

        // Assert that the method returns the correct values
        System.assertEquals(1, deals.size());
        System.assertEquals('Test Deal', deals[0].Name);
        System.assertEquals('Test Broker', deals[0].Broker__c);
        System.assertEquals(testContact.Id, deals[0].Borrower__c);
        System.assertEquals(100000, deals[0].Loan_Amount__c);
        System.assertEquals('Void', deals[0].Loan_Status__c);
        System.assertEquals(3.5, deals[0].Rate__c);
    }

    @isTest
    static void testRecordInsert() {
        // Call the method to be tested
        Test.startTest();
        List<String> fields = RecentlyViewedContactsController.recordInsert('Residential_Loan_Application__c');
        Test.stopTest();

        // Assert that the method returns the correct values
        System.assertEquals(19, fields.size());
        System.assertEquals('Id', fields[0]);
        System.assertEquals('OwnerId', fields[1]);
        System.assertEquals('IsDeleted', fields[2]);
        System.assertEquals('Name', fields[3]);
        System.assertEquals('CreatedDate', fields[4]);
        System.assertEquals('CreatedById', fields[5]);
        System.assertEquals('LastModifiedDate', fields[6]);
    }
    @IsTest
    static void testUserId() {
       User userRecord = [SELECT Id, ContactId FROM User WHERE Id=:UserInfo.getUserId()];
       Id contactId = userRecord.ContactId;

        
        Test.startTest();
        String userId = RecentlyViewedContactsController.userId();
        Test.stopTest();
        
        System.assertEquals(userRecord.ContactId, userId);
    }
}