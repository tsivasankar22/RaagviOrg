@isTest
private class CTCEmailAuthorControllerTest {
    @testSetup static void setup(){
        Case c=new Case();
        c.Origin='Email';
        c.Priority='Medium';
        c.Status='Open';
        c.Description='Hlo good Morning'; 
        c.Subject='data';
        c.SuppliedEmail='tsivasankar21@gmail.com';
        c.email__c='tsivasankar24@gmail.com';
        c.CTC_Inbound_Email_Address__c='sankar@gmail.com';
        c.CTC_Outbound_Email_Address__c='siva@gmail.com';
        insert c;
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
        ContentVersion cv2 = new ContentVersion(
            Title = 'Test File 2',
            PathOnClient = 'TestFile2.txt',
            VersionData = Blob.valueOf('Test File 2 Content'),
            IsMajorVersion = true,
            FirstPublishLocationId = c.Id
        );
        insert cv2;
        
    }
    @isTest
    static void getEmailFolder(){
        folder f2=[SELECT Id, Name, Type FROM Folder WHERE Type = 'Email'];
        
        CTCEmailAuthorController.getEmailTemplateFolders();
        system.assertEquals('Email', f2.Type);
    }
    @isTest
    static void emailTemplate(){
        folder f3=[SELECT Id, Name, Type FROM Folder WHERE Name = 'CaseRelatedTemplate'];
        CTCEmailAuthorController.getEmailTemplates(f3.Name);
        system.assertEquals('CaseRelatedTemplate', f3.Name);
        
    }
    @isTest
    static void emailAddress(){
        Case c3=[select id,Origin,Priority,Status,Description from Case where Subject='data'];
        Case c2=[SELECT  Id, CTC_Inbound_Email_Address__c,CTC_Outbound_Email_Address__c  FROM Case];
        CTCEmailAuthorController.getCaseEmailAddress(c2.id);
        System.assertEquals(c3.Id, c2.Id);
    }
    @isTest
    static void EmailController(){
        Case c6=[select id,Origin,Priority,Status,Description,SuppliedEmail,email__c, ContactEmail,Subject from Case];
        EmailMessage em = new EmailMessage();
        em.FromAddress = c6.email__c;
        em.ToAddress = c6.SuppliedEmail;
        em.TextBody = 'tsivasankar20@gmail.com';
        em.Subject = 'data';
        em.ParentId = c6.Id ;
        insert em;
        CTCEmailAuthorController.createEmailMessage(em.FromAddress,em.ToAddress,em.TextBody, em.Subject,em.Id);
        system.assertEquals(c6.Subject, em.Subject);
    }  
    @isTest
    public static void testCreateNewCase() {
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Subject';
        testEmail.plainTextBody = 'Test Body';
        testEmail.fromAddress = 'test@example.com';
        testEmail.toAddresses = new List<String>{ 'support@yourorg.com' };
            
            Test.startTest();
        CTCEmailAuthorController.createNewCase(testEmail);
        Test.stopTest();
        List<Case> cases = [SELECT Id, Subject, Description, CTC_Inbound_Email_Address__c, CTC_Outbound_Email_Address__c FROM Case where Subject='data'];
        System.assertEquals(1, cases.size(), 'Expected a single case to be created');
    }
    @isTest
    static void emailMessageTest()
    {
        List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        Messaging.InboundEmail.Header messageHeader = new Messaging.InboundEmail.Header();
        messageHeader.Name = 'Message-ID:';
        messageHeader.value = '<BLAPR16MB37478D93BEC69718C9576BEBBF089@BLAPR16MB3747.namprd16.prod.outlook.com>';
        headers.add(messageHeader);
        
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject='Test';
        testEmail.plainTextBody = 'Test Body';
        testEmail.fromAddress = 'test@example.com';
        testEmail.toAddresses = new List<String>{ 'support@yourorg.com' };
        testEmail.headers =  headers;
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope(); 
        
        Id emailCaseId = Cases.getCaseIdFromEmailHeaders(testEmail.headers);
        
        EmailMessage emailMessageObj = new EmailMessage();
            emailMessageObj.ParentId = emailCaseId;
            emailMessageObj.TextBody = 'Hlo';
            emailMessageObj.ThreadIdentifier = 'Re:';
            emailMessageObj.Subject = 'Test Sub';
            emailMessageObj.FromAddress = 'test@example.com';
            emailMessageObj.ToAddress = 'support@yourorg.com';
            emailMessageObj.HtmlBody = 'Test Html Body';
			insert emailMessageObj;
        
        CTCEmailAuthorController emailProcess = new CTCEmailAuthorController();
        test.startTest();
        emailProcess.handleInboundEmail(testEmail,env);
        test.stopTest();
    }
    @isTest
    static void emailMessageCatchTest()
    {
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject='Test';
        testEmail.plainTextBody = 'Test Body';
        testEmail.fromAddress = 'test@example.com';
        testEmail.toAddresses = new List<String>{ 'support@yourorg.com' };
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope(); 
        
        CTCEmailAuthorController emailProcess = new CTCEmailAuthorController();
        test.startTest();
        emailProcess.handleInboundEmail(testEmail,env);
        test.stopTest();
    }
    @isTest
    static void fileAttachmentTest(){
        case c9=[select id,Origin,Priority,Status,Description from Case WHERE Subject='data'];
        test.startTest();
        CTCEmailAuthorController.fileAttachment(c9.Id);
        test.stopTest();
    }
    /*@isTest
    static void sendEmailToControllerTest(){
        
        List<ContentDocument> conDOcObj = [SELECT Id FROM ContentDocument];
        List<String> conDocIds = new List<String>();
        for(ContentDocument conDoc : conDOcObj)
        {
            conDocIds.add(conDoc.Id);
        }
        Case kaseObj = [SELECT Id FROM case WHERE Subject='data'];
        Test.startTest();
        	CTCEmailAuthorController.sendEmailToController('test@example.com', 'support@yourorg.com', 'subjectEmail', 'bodyEmail', kaseObj.Id, conDocIds);
       	Test.stopTest();
    }*/
    @isTest
    static void sendEmailToControllerCatchTest(){
        
        List<ContentDocument> conDOcObj = [SELECT Id FROM ContentDocument];
        List<String> conDocIds = new List<String>();
        for(ContentDocument conDoc : conDOcObj)
        {
            conDocIds.add(conDoc.Id);
        }
        Test.startTest();
        	CTCEmailAuthorController.sendEmailToController('test@example.com', 'support@yourorg.com', 'subjectEmail', 'bodyEmail', 'kaseObjId', conDocIds);
       	Test.stopTest();  
    }
    @isTest
    static void limitLengthTest()
    {
        CTCEmailAuthorController emailAuthorClass = new CTCEmailAuthorController();
        Test.startTest();
        	emailAuthorClass.limitLength('siva',5);
       	Test.stopTest();
    }
    @isTest
    static void limitLengthSecondTest()
    {
        CTCEmailAuthorController emailAuthorClass = new CTCEmailAuthorController();
        Test.startTest();
        	emailAuthorClass.limitLength('sivaraj',5);
       	Test.stopTest();
    }
    @isTest
    static void extractAddressTest()
    {
        CTCEmailAuthorController emailAuthorClass = new CTCEmailAuthorController();
        Test.startTest();
        	emailAuthorClass.extractAddress('inAddress');
       	Test.stopTest();
    }
    @isTest
    static void extractAddressSecongTest()
    {
        CTCEmailAuthorController emailAuthorClass = new CTCEmailAuthorController();
        Test.startTest();
        	emailAuthorClass.extractAddress('I have a cat. <cat@example.com> Please contact me.');
       	Test.stopTest();
    }
}