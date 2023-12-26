public with sharing class  practice
{
    public static void practiceclass()
    {
        List<ContentWorkSpace> obj1=[SELECT Id, Name FROM ContentWorkSpace];
        System.debug('obj1======='+obj1);
    }
}