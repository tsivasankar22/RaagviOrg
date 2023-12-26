@isTest
private class EmailAuthorTest {
    @isTest
    static void handleInboundEmailTest(){
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
        EmailAuthor emailProcess = new EmailAuthor();
        test.startTest();
        emailProcess.handleInboundEmail(testEmail,env);
        test.stopTest();
    }
    @isTest
    static void getFolderTest(){
        Folder fo=new Folder();
        fo.Name='sankar';
        fo.Type='email';
        EmailAuthor.getFolder();
    }
    @isTest
    static void getEmailBodyTest(){
        EmailTemplate em=new EmailTemplate();
        em.Body='test Body';
        em.Subject='test Subject';
        em.DeveloperName='sankar';
        em.TemplateType='text';
       // insert em;
        EmailAuthor.getEmailTemplate(em.Id);
    }
     @isTest
    static void getEmailTest(){
        Folder fo=new Folder();
        fo.Name='sankar';
        fo.Type='email';
        EmailTemplate em=new EmailTemplate();
        em.Body='test Body';
        em.Subject='test Subject';
        em.DeveloperName='sankar';
        em.TemplateType='text';
        em.FolderId=fo.Id;
       // insert em;
      // EmailAuthor.getEmailBody();
    }
    @isTest
    static void showEmail(){
        Case c=new Case();
        c.Origin='Email';
        c.Priority='Medium';
        c.Status='Open';
        insert c;
        EmailAuthor.showEmail(c.id);
    }
  @isTest
    static void fileAttachmentTest(){
        Case c=new Case();
        c.Origin='Email';
        c.Priority='Medium';
        c.Status='Open';
        insert c;
        test.startTest();
        EmailAuthor.fileAttachment(c.Id);
        test.stopTest();
    }
}