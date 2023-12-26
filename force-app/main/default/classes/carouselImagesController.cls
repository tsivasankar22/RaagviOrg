public class carouselImagesController 
{
	@AuraEnabled
    public static List<ContentDocument> ContentList()
    {
        List<ContentDocument> contentV = [SELECT Id, Title FROM ContentDocument where FileExtension ='jpg' ORDER BY ContentModifiedDate desc limit 10];
        return contentV;
    }
}