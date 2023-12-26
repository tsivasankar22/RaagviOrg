trigger CreateGoogleContactOnNewContact on Contact (after insert, before delete, after update) {
    List<Id> contactIdsToProcess = new List<Id>();
    List<Contact> contactsToDelete = new List<Contact>();
    List<Contact> updatedContacts = new List<Contact>();
    
    if (Trigger.isAfter && Trigger.isInsert) {
        for (Contact con : Trigger.new) {
            contactIdsToProcess.add(con.Id);
        }
        
        if (!contactIdsToProcess.isEmpty()) {
            for (Id contactId : contactIdsToProcess) {
                GoogleContacts.createGoogleContactAsync(contactId);
            }
        }
    }
    
    if (Trigger.isBefore && Trigger.isDelete) {
        contactsToDelete.addAll(Trigger.old);
        
        if (!contactsToDelete.isEmpty()) {
            for (Contact con : contactsToDelete) {
                String resourceName = con.Resource_Name__c;
                GoogleContacts.deleteGoogleContactAsync(resourceName);
            }
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Contact newCon : Trigger.new) {
            Contact oldCon = Trigger.oldMap.get(newCon.Id);
            
            // Check if relevant fields (FirstName, LastName, Email, Phone) have changed
            if (newCon.FirstName != oldCon.FirstName || newCon.LastName != oldCon.LastName ||
                newCon.Email != oldCon.Email || newCon.Phone != oldCon.Phone) {
                updatedContacts.add(newCon);
            }
        }
        
        if (!updatedContacts.isEmpty()) {
            for (Contact updatedCon : updatedContacts) {
                String resourceName = updatedCon.Resource_Name__c;
                GoogleContacts.updateGoogleContactAsync(resourceName);
            }
        }
    }
}