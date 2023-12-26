public class UploadFileCaseObject {
    public static void FileAttachment(){
        //List<Attachment> Attachments=[SELECT ID ,Name,OwnerId FROM Attachment];
        
        
        //   Cversion.OwnerId = Attachment.OwnerId;
        try{
           
            String textFile = 'This is a first file of attachment';
            ContentVersion Cversion=new ContentVersion();
            Cversion.ContentLocation='S';
            Cversion.PathOnClient='Salesforce.txt';
            Cversion.Title='Salesforce.txt';
            Blob textData = Blob.valueOf(textFile);
            Cversion.VersionData = textData;
           
            //List<Case> newlist=[select CaseNumber,ContactId from Case];
           // for(Case c:newList){
                
            //}
            String str=apexpages.currentpage().getparameters().get('id');
            Case ca = [SELECT id , ContactId from Case Where id=:str];
            String Versid = [Select contentDocumentid from contentVersion where id=: Cversion.Id].contentDocumentid ;
            ContentDocumentLink Doclink = new ContentDocumentLink();
            Doclink.ContentDocumentId ='Versid';
            Doclink.LinkedEntityId ='ca';
            Doclink.ShareType = 'I';
            Doclink.Visibility ='AllUsers';
            insert doclink;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    
}