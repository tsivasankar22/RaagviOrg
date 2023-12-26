public class DisplayContacts {
    public List<Contact> getAllContacts(){
        return [SELECT FirstName, LastName, Email
               FROM Contact];
    }

}