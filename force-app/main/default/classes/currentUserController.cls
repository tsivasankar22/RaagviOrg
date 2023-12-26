public with sharing class currentUserController 
{
    @AuraEnabled
    public static User updateUserDetails(Id userId,String FirstName,String LastName,String Phone,String Email,String Username,String Alias,Boolean IsActive) 
    {
        System.debug('Id--->'+userId);

        User u = [SELECT Id, FirstName, LastName, Phone, Email, Username, Alias, IsActive FROM User WHERE Id =:userId];
        
        u.Phone = Phone;

        update u;
        
        System.debug('Updates>>>>>'+u);

        return u;  
    }
}