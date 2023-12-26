public class carouselCommunity 
{   
    @AuraEnabled
    public static List<ContentVersion> content()
    {
        List<ContentVersion> contentV = new List<ContentVersion>();
        return [SELECT Id FROM ContentVersion];
    }
}