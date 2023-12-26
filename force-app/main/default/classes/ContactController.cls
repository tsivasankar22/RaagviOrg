public with sharing class ContactController {

    @AuraEnabled (cacheable = true)
    public static List<Contact> getContacts() {
        try {
            return [
                SELECT Id, FirstName, LastName, Email 
                FROM Contact
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        // throw new AuraHandledException('Forced error');
    }
}