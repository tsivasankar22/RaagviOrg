public with sharing class CTCEmailAuthorController implements Messaging.InboundEmailHandler{  
    @AuraEnabled(cacheable=true)
    public static List<Folder> getEmailTemplateFolders( ) { 
        System.debug('getEmailTemplateFolders>>>>>>');
        List<Folder>  emailTempFolderLists=[SELECT Id, Name, Type FROM Folder WHERE Type = 'Email'];
        return emailTempFolderLists;
    }
    @AuraEnabled(cacheable=true)
    public static List<EmailTemplate> getEmailTemplates(String folderName ) { 
        System.debug('EmailTemplate>>>>>>');
        List<Folder>  emailTempFolderLists=[SELECT Id, Name, Type FROM Folder WHERE Name =: folderName];
        List<EmailTemplate>  emailTempLists= [SELECT Id, Name, FolderId , Body , Subject
                                              FROM EmailTemplate 
                                              WHERE FolderId=:emailTempFolderLists[0].Id];
                                              System.debug('emailTempLists>>Id>>>>'+ emailTempLists);
        return emailTempLists; 
    }  
    //get TO and From Address
    @AuraEnabled(cacheable=true)
    public static List<Case> getCaseEmailAddress(String caseRecordId ){
        System.debug('getToAddress>>>>>>>>>>>>>>');
        List<Case> toAddressList = [SELECT  Id, CTC_Inbound_Email_Address__c,CTC_Outbound_Email_Address__c  FROM Case WHERE Id=: caseRecordId ];
        System.debug('toAddressList>>toAddressList>>>>>>>>>>>>>>>>>>>>>>>'+ toAddressList);
        return toAddressList;
    }    
    @AuraEnabled
    public static void sendEmailToController( String toAddressEmail,String fromEmailAddress, String subjectEmail ,String bodyEmail , String caseRecordId, String[] uploadedFiles){        
        System.debug('toAddressEmail>>>>>>>>>>'+ toAddressEmail);
        System.debug('fromEmailAddress'+ fromEmailAddress);
        System.debug('subjectEmail>>'+subjectEmail);
        System.debug('bodyEmail>>>>>'+bodyEmail);
        System.debug('uploadedFiles>>>>>'+uploadedFiles);
        System.debug('caseRecordId>>>>>'+caseRecordId);
        List<ContentVersion> contentVersionFile = [SELECT VersionData, Title, FileType FROM ContentVersion WHERE ContentDocumentId IN :uploadedFiles AND IsLatest = true]; 
        List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>(); 
        for (ContentVersion cv : contentVersionFile) { 
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment(); 
                efa.setFileName(cv.Title + '.' + cv.FileType); 
                efa.setBody(cv.VersionData); 
                emailFileAttachments.add(efa); 
        } 
        // email.setToAddresses(toAddressEmail);
        // email.setOrgWideEmailAddressId(fromEmailAddress);
        // email.setSubject(subjectEmail);
        // email.setHtmlBody(bodyEmail);
        //email.setEntityAttachments(uploadedFiles);
        // email.setFileAttachments(emailFileAttachments);
        try {
            System.debug('caseRecordId>>try inside>>>'+caseRecordId);
            if( caseRecordId !=null ) {
                createEmailMessage(toAddressEmail,fromEmailAddress,  subjectEmail , bodyEmail ,  caseRecordId );
            }else {
                // createNewCase(new List<Messaging.SingleEmailMessage>{ email });
            }
        } 
        catch(Exception e){
            System.debug('c>>>>>>>>>>>'+e.getMessage());
        }
        // Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> fileAttachment(String caseRecId){
    System.debug('REcords id'+ caseRecId);
    System.debug('fileAttachment>>>>>>>>>>>>>>>>>>>>>>>');
    List<ContentDocumentLink> cd = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Case where id=:caseRecId) and LinkedEntity.Type='Case'];
    System.debug('cd>>>>>>>>>>'+cd);
    List<ContentVersion> conVer=new List<ContentVersion>();
    for(ContentDocumentLink cdc : cd){
        ContentVersion cv =[SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId =:cdc.ContentDocumentId];
        System.debug('cv?>>>>>>>>>>>>'+cv);
        System.debug('cv id>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+cv.Id);
        conVer.add(cv);
    }
    return conVer;
  }
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env){
    Messaging.InboundEmailResult result = new  Messaging.InboundEmailResult();
        try { 
            Id emailCaseId = Cases.getCaseIdFromEmailHeaders(email.headers);            
            System.debug('email.headers>>>>>>>>>>>>>>>>>>'+email.headers);
            System.debug('emailCaseId>95>>>>>>>>>>>>>>>>'+emailCaseId);
            System.debug('email.Subject>email.Subject>>>>>>>>>>>>>>>>'+email.Subject);
            //String emailSubjectForThread=email.subject.remove('Re: ');
            emailCaseId = email.subject.containsIgnoreCase('Re: Thank you for your inquiry.') ? email.subject.remove('Re: Thank you for your inquiry. ') : emailCaseId;
            System.debug('emailCaseId>99>>>>>>>>>>>>>>>>'+emailCaseId);            
            String emailSubject ;
            String emailToAddress;
            String emailFromAddress;
            String emailTextBody ;
            String emailThreadId;
            for(EmailMessage emailMessage : [SELECT Id, ParentId, TextBody,ThreadIdentifier, Subject, FromAddress, ToAddress, HtmlBody  FROM EmailMessage WHERE ParentId=: emailCaseId ])
            {
                emailSubject = emailMessage.Subject ;
                emailToAddress = emailMessage.ToAddress;   
                emailFromAddress = emailMessage.FromAddress;
                emailTextBody = emailMessage.TextBody;
                emailThreadId = emailMessage.ThreadIdentifier;
                System.debug('email.ThreadIdentifier>>>>>>>>>>>>>>>>'+emailMessage.ThreadIdentifier);
                System.debug('emailCaseId>??????????????????'+emailSubject);
                System.debug('Subject>>>>>>'+emailToAddress);
                System.debug('ToAddress>>>>>>'+emailFromAddress);
                System.debug('FromAddress>>>>>>'+emailTextBody);
            }            
              if(emailCaseId != null) {
             System.debug('emailSubjectForThread threads set>>>>'+emailCaseId);
            createEmailMessage(emailToAddress,emailFromAddress,emailSubject,emailTextBody,emailCaseId);
            }else{
                System.debug('else if >?>?>?>?');
                createNewCase(email);
            }
            result.success = true;
        } catch(Exception e){
            result.success = false;
            result.message = e.getMessage();
            System.debug('Exception While creating the case'+e);
        }
        return result;
    }   
    public static void createEmailMessage(String toAddressEmail,String fromEmailAddress, String subjectEmail ,String bodyEmail , String caseRecordId) {       
        System.debug('toAddressEmail>.>>......>>>>>.....>>>>.'+ toAddressEmail);
        System.debug('fromEmailAddress'+ fromEmailAddress);
        System.debug('subjectEmail>>'+subjectEmail);
        System.debug('bodyEmail>>>>>'+bodyEmail);
        System.debug('caseRecordId>>>>>'+caseRecordId);
        subjectEmail = subjectEmail.replace('{!Case.Id}', caseRecordId);       
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{toAddressEmail});
            // email.setTargetObjectId
            // email.TemplateId
            email.setSubject(subjectEmail);
            email.setSaveAsActivity(false);
            email.setHtmlBody(bodyEmail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            System.debug('Email >>>>>>>>>>>>>>>'+email);
            List<EmailMessage> emList = new List<EmailMessage>();
            EmailMessage em = new EmailMessage();
            em.ParentId = caseRecordId ;
            em.FromAddress = fromEmailAddress;
            em.ToAddress = toAddressEmail;
            em.TextBody = bodyEmail;
            em.Subject = subjectEmail;
            emList.add(em);
            System.debug('emList>>>>>>>>>>>>?>??????'+emList);        
            try {
                System.debug('caseRecordId>>try inside>>>'+caseRecordId);
                if( caseRecordId !=null && emList.size()>0) {
                    //createEmailMessage(toAddressEmail,fromEmailAddress,  subjectEmail , bodyEmail ,  caseRecordId);
                    System.debug('emList>>>>>>>>>>>>?>??????'+emList);
                    insert emList;
                }else {
                    // createNewCase(new List<Messaging.SingleEmailMessage>{ email });
                } 
             } 
            catch(Exception e){
                System.debug('c>>>>>>>>>>>'+e.getMessage());
            }
    }
    public static void createNewCase(Messaging.inboundEmail email){
            String fromAdd = email.fromAddress;
            List<Contact> con=[SELECT Id,email FROM Contact WHERE email=:fromAdd];
          // String toAddress;
            System.debug('check>>>>>'+con);
            Case c= new Case();
            List<Case> cases = new List<Case>();
                c.Status='Open';
                c.Priority='Normal';
                c.origin='Email';       
                c.subject=email.Subject;
                c.description=email.plainTextBody;
                c.CTC_Inbound_Email_Address__c = email.fromAddress;
                c.CTC_Outbound_Email_Address__c = email.toAddresses[0];             
                System.debug('to address?>?>?>>?>?>?'+email.toAddresses[0]);              
                INSERT c;
        		//createEmailMessage(email.toAddresses[0],email.FromAddress,email.Subject,email.plainTextBody,c.Id);
               System.debug('c>>>>>>>>>>>>>>>>> case insert'+c);  
    }
    public String limitLength(String input, Integer maxLength){
        String results;
        if(input != null && input.length() > maxLength)
            results = input.substring(0,maxLength);
        else 
            results = input;
        return results;
    }
    public String extractAddress(String inAddress){
        String address;
        String patternString;
        Pattern thePattern;
        Matcher matcher;
        patternString = '.*<(.*)>.*';
        thePattern = Pattern.compile(patternString);
        matcher = thePattern.matcher(inAddress);
        if (matcher.matches()) {
            address = matcher.group(1);
        }
        else{
            address = inAddress;  
        }
        return address;
    }
}