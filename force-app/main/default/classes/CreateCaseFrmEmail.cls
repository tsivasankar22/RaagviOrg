global class CreateCaseFrmEmail implements Messaging.InboundEmailHandler {
    global static String Id;
    global static Id caseId;
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try
        {
            Id caseId = Cases.getCaseIdFromEmailHeaders(email.headers);
             system.debug('caseId  starting '+caseId);
            if (caseId == null){
            String fromAdd=email.fromAddress;
            Case c1 =new Case();
            c1.Origin ='Email';
            c1.Status ='New';
            c1.Priority='High';
            c1.Subject = email.subject;
            c1.Description=email.plainTextBody;
            c1.email__c=email.fromAddress;
            c1.SuppliedEmail=email.fromAddress;         
            insert c1;  
            system.debug('finesh Queroy');
                CaseId= c1.id;
        }
           Id = CaseId;
            System.debug('Id =========> '+Id);
            sendEmail(email,email.toAddresses,'recordId','body','subject','fromAddress');
            CaseEmailStoreMethod(email);
        }  
        catch(Exception e)
        {
            result.success=false;
        }
        return result;
    }
    @AuraEnabled(cacheable=true)
      public static List<Folder> getFolder(){
          return [SELECT Name 
                  FROM Folder 
                  WHERE type='email'];
      }
      @AuraEnabled
      public static List<EmailTemplate> getEmailBody(String[] recordId){
          return [SELECT Body,Subject FROM EmailTemplate where Id =: recordId];
      }
      @AuraEnabled
      public static List<EmailTemplate> getEmailTemplate(String recordId){
        System.debug('i============'+recordId);
        return [SELECT Name FROM EmailTemplate WHERE FolderId =: recordId];
      }
      @AuraEnabled(cacheable=true)
    public static List<Case> showEmail(id recordId){
      System.debug('recordId>>>'+recordId);
      return [SELECT  contact.Email from Case where Id=:recordId];
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> fileAttachment(String recordId){
      List<ContentDocumentLink> cd = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Case where id=:recordId) and LinkedEntity.Type='Case'];
      List<ContentVersion> conVer=new List<ContentVersion>();
      for(ContentDocumentLink cdc : cd){
          ContentVersion cv =[SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId =:cdc.ContentDocumentId];
          conVer.add(cv);
           } 
       return conVer;
    }
    @AuraEnabled
    global static  void sendEmail(Messaging.InboundEmail email,List<String> toAddress, String fromAddress,String subject, String body,String recordId)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try
        {
             messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
          mail.setToAddresses(toAddress);
          mail.setReplyTo(fromAddress);
          mail.setSenderDisplayName('RAAGVITECH');
        //  mail.setFileAttachments(emailFileAttachments);
          mail.setSubject(subject);
          mail.setHtmlBody(body);    
          Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
          Messaging.SendEmailResult[] resultMail=Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
          if (resultMail[0].isSuccess()) {
              system.debug('after If');
              EmailMessage emailMsgObj = new EmailMessage();
              emailMsgObj.HtmlBody = body;
              emailMsgObj.TextBody = body;
              emailMsgObj.FromAddress = fromAddress; 
              emailMsgObj.ToAddress =toAddress[0];
              emailMsgObj.Subject = subject;
              emailMsgObj.MessageDate = system.now();
              emailMsgObj.ParentId =caseId;
              system.debug('emailMsgObj.ParentId  in send email '+emailMsgObj.ParentId);
              system.debug('emailMsgObj   '+emailMsgObj);
              insert emailMsgObj;     
              System.debug('Insert in send email');     
        }
        } 
        catch(Exception e)
        {
            result.success=false;
        }
        system.debug('finesh Queroy');
    }
    global void CaseEmailStoreMethod(Messaging.InboundEmail email)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try
        {
             String toAddresses;
            if (email.toAddresses != null) {
                toAddresses = String.join(email.toAddresses, '; ');
               system.debug('Email send ----0-->'+toAddresses); 
            EmailMessage emailMsgObj = new EmailMessage();
            emailMsgObj.HtmlBody =  email.htmlBody;
            emailMsgObj.TextBody = email.plainTextBody;
            emailMsgObj.FromAddress = email.fromAddress; 
            emailMsgObj.ToAddress =email.toAddresses[0];
            emailMsgObj.FromName = email.fromName;
            emailMsgObj.Subject = email.subject;
            emailMsgObj.Incoming = true;
            emailMsgObj.Status = '0';
            emailMsgObj.MessageDate = system.now();
            emailMsgObj.ParentId =Id ;
            insert emailMsgObj;
                System.debug('Insert in case ctearte method');
            result.success = true;
            System.debug('DEBUG LEVEL : '+email.binaryAttachments);  
            List<Attachment> attachments = new List<Attachment>();
            if(email.textAttachments != NULL && email.textAttachments.size() > 0){
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    attachments.add(new Attachment(
                        Name = tAttachment.fileName,
                        Body = Blob.valueOf(tAttachment.body),
                        ParentId =Id
                    ));
                }
            }
            if(email.binaryAttachments != NULL && email.binaryAttachments.size() > 0){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    attachments.add(new Attachment(
                        Name = bAttachment.fileName,
                        Body = bAttachment.body,
                        ParentId =Id
                    ));
                }
            }
            insert attachments; 
        }
        } 
        catch(Exception e)
        {
            result.success=false;
        }
        system.debug('finesh Queroy');
    }
}