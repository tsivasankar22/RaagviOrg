public class VFExample{

    public List<Contact> getAllContacts(){
       return [SELECT FirstName, LastName, Email FROM Contact];
    }
}