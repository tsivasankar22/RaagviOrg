public class FileUpadate
{
    public static void AttachmentFile(list<ContentVersion> ContentData)
    {
        ContentVersion ContentList=[SELECT Title from ContentVersion ];
        ContentVersion Cversion=new ContentVersion();
        Cversion.ContentLocation='E';
        Cversion.PathOnClient='sankar T.txt';
        Cversion.Title='sankar T.txt';
        String Versid = [Select contentDocumentid from contentVersion where id=: Cversion.Id].contentDocumentid ;
        ContentDocumentLink Doclink = new ContentDocumentLink();
        Doclink.ContentDocumentId ='ContactId';
        Doclink.LinkedEntityId ='ca';
        Doclink.ShareType = 'I';
        Doclink.Visibility ='AllUsers';  
        Case ca=new Case();
        if(ca.ContactId == ContentList.Title)
        {
            update ContentData;
        }   
    }
}