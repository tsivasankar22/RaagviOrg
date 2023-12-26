@isTest
private class UserProfilePictureShowTest {
    
    @isTest
    static void testUserProfileShow() {
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'User', 
            BDM_Assign_To__c = 'Pavan'
        );
        insert testContact;
        
        User testUser = new User(
            FirstName = 'Testing',
            LastName = 'User1',
            Email = 'testuser@sample.com',
            ContactId = testContact.Id,
            Username = 'testusersedrtyuik@example.com',
            Alias = 'tdrftgr',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = '00e5i000000IfPDAA0',
            LanguageLocaleKey = 'en_US'
            
        );
        // insert testUser;
        
        ContentWorkspace testWorkspace = new ContentWorkspace(
            Name = 'ProfilePictureForUser'
        );
        //   insert testWorkspace;
        
        // ContentDocument testContentDocument = new ContentDocument(
        // Title = testUser.Name,
        //  FileType = 'jpg',
        // LatestPublishedVersionId = null,
        //  ParentId = testWorkspace.Id
        // );
        // insert testContentDocument;
        
        Test.startTest();
        UserProfilePictureShow.WrapperClassProfilepic result = UserProfilePictureShow.UserProfileShow();
        Test.stopTest();
   
        //  System.assertEquals(true, result.Bool);
        //  System.assertEquals(testContentDocument.Id, result.url);
    }
}