public class CustomFilePreviewController {
    public List<ContentVersion> contentVersionList { get; set; }

    public CustomFilePreviewController() {
        contentVersionList = [SELECT Id, Title, FileExtension, ContentDocumentId FROM ContentVersion];
    }
}