public class InlineEditing {
    @AuraEnabled(Cacheable = true)  
    //to cache the method results on the client.To set cacheable=true, a method must only get data
    public static List<Contact> getContacts() {
        // getContacts() is a menthod and i am  fetching the data into that method()  
        return [SELECT Id, Name, FirstName, LastName, Phone, Email ,LeadSource
                FROM Contact 
                WHERE Email != null
                AND Phone != null
                ORDER BY CreatedDate limit 20];
    }


}