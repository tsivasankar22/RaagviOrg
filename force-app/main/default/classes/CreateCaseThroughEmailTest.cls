@isTest
    Private class CreateCaseThroughEmailTest {
        @testSetup static void setup(){
       List<Contact> con8=new List<Contact>();
            
            Contact con = new Contact();
            con.LastName='sankara';
            con.Email = 'test@example.com';
            con8.add(con);
          // insert con;
          Contact con6=new Contact();
            con6.LastName='Siva';
            con6.Email = 'test@example.com';
              con8.add(con6);
          // insert con6;
              Contact con7=new Contact();
            con7.LastName='Siva Sankar';
            con7.Email = 'test@example.com';
              con8.add(con7);
           insert con8;
            Case ca=new Case();
            ca.ContactId=con.Id;
            ca.Priority='Medium';
            ca.Status='Open';
            ca.Origin='Email';
            insert ca;            
        }
         @isTest
        static void CaseEmailStoreMethodTest(){
             Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
            testEmail.subject = 'Test Subject';
            testEmail.plainTextBody = 'Test Body';
            testEmail.fromAddress = 'test@example.com';
            testEmail.toAddresses = new List<String>{ 'support@yourorg.com' };
              // EmailMessage emailMessageObj = new EmailMessage();
                //emailMessageObj.TextBody = 'Hlo';
                //emailMessageObj.ThreadIdentifier = 'Re:';
                //emailMessageObj.Subject = 'Test Sub';
                //emailMessageObj.FromAddress = 'test@example.com';
                //emailMessageObj.ToAddress = 'support@yourorg.com';
                //emailMessageObj.HtmlBody = 'Test Html Body';
                //insert emailMessageObj;
          Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
          attachment.body = blob.valueOf('my attachment text');
          attachment.fileName = 'textfileone.txt';
          attachment.mimeTypeSubType = 'text/plain';
          testEmail.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
          Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
          attachmenttext.body = 'my attachment text';
          attachmenttext.fileName = 'textfiletwo3.txt';
          attachmenttext.mimeTypeSubType = 'texttwo/plain';
          testEmail.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
         
          CreateCaseThroughEmail emailAuthorClass = new CreateCaseThroughEmail();
          emailAuthorClass.CaseEmailStoreMethod(testEmail);
            
        }
          @isTest
        static void handleInboundEmail(){
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
            List<Contact> con8=new List<Contact>();
            
            Contact con = new Contact();
            con.LastName='sankara';
            con.Email = 'test@example.com';
            con8.add(con);
          // insert con;
          Contact con6=new Contact();
            con6.LastName='Siva';
            con6.Email = 'test@example.com';
              con8.add(con6);
          // insert con6;
              Contact con7=new Contact();
            con7.LastName='Siva Sankar';
            con7.Email = 'test@example.com';
              con8.add(con7);
           insert con8;
            Case ca=new Case();
            ca.ContactId=con.Id;
            ca.Priority='Medium';
            ca.Status='Open';
            ca.Origin='Email';
            insert ca;
            
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope(); 
        Contact con1=[select id,Email,LastName from Contact where LastName ='sankara' limit 1];
           
        Id emailCaseId = Cases.getCaseIdFromEmailHeaders(testEmail.headers);
          CreateCaseThroughEmail emailProcess = new CreateCaseThroughEmail();
        test.startTest();
        emailProcess.handleInboundEmail(testEmail,env);
        test.stopTest();
        }
       
    }