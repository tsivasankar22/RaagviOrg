public class VFpageDemo{
    public List<Contact> getAllContacts(){
       return [SELECT FirstName, LastName, Email FROM Contact];
    }
}