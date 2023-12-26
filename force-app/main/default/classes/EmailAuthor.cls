global class  EmailAuthor implements Messaging.InboundEmailHandler {
  global String Id;
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    {
        Id caseId = Cases.getCaseIdFromEmailHeaders(email.headers);
       Id = CaseId;  
    }
    return null;
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
    public static void sendEmail(List<String> toAddress, String fromAddress,String subject, String body,String[] ids,String recordId) {  
      System.debug('ids-----------------'+ids); 
      System.debug('toAddress-----------------'+toAddress); 
      System.debug('fromAddress-----------------'+fromAddress); 
      System.debug('subject-----------------'+subject);  
      ID orgId = UserInfo.getOrganizationId();
      String sOrgId = (string)orgId;
      ID caseId = recordId; // replace this with your case id
      String sCaseId = (string)caseId;
      String threadIdPart1 = 'ref:_' + sOrgId.left(5) + sOrgId.right(10).replace('0','');
      threadIdPart1 = threadIdPart1.substring(0,threadIdPart1.length()-3);
      String threadIdPart2 = '._' + sCaseId.Left(5) + sCaseId.right(10).left(5).replace('0','') + sCaseId.right(5);
      threadIdPart2 = threadIdPart2.substring(0,threadIdPart2.length()-3)+':ref';
      String threadId = threadIdPart1 + threadIdPart2;  
      System.debug('Thread Id^^'+threadId);
 
        
          List<ContentVersion> contentVersionFile = [SELECT VersionData, Title, FileType FROM ContentVersion WHERE ContentDocumentId IN :ids AND IsLatest = true]; 
          List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>(); 
          for (ContentVersion cv : contentVersionFile){ 
                  Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment(); 
                  efa.setFileName(cv.Title + '.' + cv.FileType); 
                  efa.setBody(cv.VersionData); 
                  emailFileAttachments.add(efa); 
            }         
          messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
          mail.setToAddresses(toAddress);         
          mail.setReplyTo(fromAddress);
          mail.setSenderDisplayName('RAAGVITECH');
          mail.setFileAttachments(emailFileAttachments);
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
              emailMsgObj.ParentId =recordId ;
              emailMsgObj.ReplyToEmailMessageId = threadId;
              system.debug('parent iddddddddddddd==='+emailMsgObj.ParentId);
              system.debug('emailMsgObj.ReplyToEmailMessageId==='+emailMsgObj.ReplyToEmailMessageId);
              system.debug('emailMsgObj   '+emailMsgObj);
              insert emailMsgObj;     
          }
     }   
  }