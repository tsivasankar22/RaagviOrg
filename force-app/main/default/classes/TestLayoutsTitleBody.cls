public class TestLayoutsTitleBody
{
    @AuraEnabled
    public static List<ContentVersion> content()
    {
        List<ContentVersion> contentV = [SELECT Id FROM ContentVersion];
        return contentV;
    }
}