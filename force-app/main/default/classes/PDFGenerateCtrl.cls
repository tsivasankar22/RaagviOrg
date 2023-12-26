public class PDFGenerateCtrl {
   
    public User usr{get;set;}
    public String currentRecordId{get;set;}
    public static String docId;
    public PDFGenerateCtrl(){
        //getting the current user record id 
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        System.debug('currentRecordId----->'+currentRecordId);
        if(currentRecordId != null && String.isNotBlank(currentRecordId)){
            usr = [SELECT Id, Name,Email FROM User WHERE Id =:currentRecordId];
            System.debug('usr========='+ usr);
        }
       
    } 
 
    @AuraEnabled(cacheable=true)
    public static List<User> fetchRecords(){
        try {
            List<User> UserList = new List<User>();
 
            UserList = [Select id, Name, Email from User];              
            return UserList;
        } catch (Exception e) {
            System.debug('Exception======= '+e.getMessage());
            return null;
        }
    }
 
    @AuraEnabled
    

        public static String sendPdf(String usrId) {
            
            PageReference pdf = new pagereference('/apex/ContactDataPDF?id='+usrId);
            pdf.getParameters().put('id', usrId);
            System.Debug('User iddddd========,'+usrId);
         
            Blob body;
            try {
                // returns page as a PDF
                body = pdf.getContent();
            } catch (Exception e) {
                body = Blob.valueOf('data');
            }
      
 
       //insert content version
    //    ContentVersion CV = new ContentVersion();
    //    CV.Title = 'OrderDetails.pdf';
    //    CV.PathOnClient ='OrderDetails.pdf';
    //    CV.VersionData =body;
    //    CV.FirstPublishLocationId =usrId;
    //    insert CV;
       
    //    docId=CV.Id;
    //    documnetPreview(docId);
    //    System.debug('ContentDocumentId---->'+CV.ContentDocumentId);
    //    System.debug('versionID------>'+docId);
       
       Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
       attach.setContentType('application/pdf');
       attach.setFileName('OrderDetails.pdf');
       attach.Body = body;
       
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[]{usrId};
       system.debug(usrId+'user Id====================');
       System.Debug('toAddresses iddddd========,'+toAddresses);
       mail.setToAddresses(toAddresses);
       System.Debug('setToAddresses iddddd========,'+toAddresses);
       mail.setSubject('Order Details');
       mail.setHtmlBody('Generate PDF');
       mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach}); 
       // Send the email
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
       return 'Email sent Successfully with PDF.';
       }
       
       @AuraEnabled
       public static List<ContentDocument> documnetPreview(String dacId) 
       {
       System.debug('docId---->'+dacId);
       List<ContentDocument> docList = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =:dacId];
       
       System.debug('doclist---->'+docList);
       
           return docList;
       }  
    }