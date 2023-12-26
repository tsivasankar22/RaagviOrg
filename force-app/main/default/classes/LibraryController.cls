public class LibraryController{
   
	List<ContentFolderItem> newFile= [SELECT Id, Title, FileExtension FROM ContentFolderItem WHERE ParentContentFolderId IN (SELECT Id FROM ContentFolder WHERE Name = 'salesforceCurosel')];
}