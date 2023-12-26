public class GoogleToSalesforceContact{
        // Method to make callout to Google Contacts API using Named Credential
    public static void makeGoogleContactsCallout() {
        // Specify the Named Credential Developer Name (e.g., 'Google_API')
        // String namedCredentialName = 'GoogleConnect';
        // Create an HTTP request with the Named Credential endpoint
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Google' + '/v1/people/me/connections?personFields=names,emailAddresses,phoneNumbers');
        request.setMethod('GET');	
        // Send the HTTP request
        Http http = new Http();
        HttpResponse response = http.send(request);
        // Handle the API response
        if (response.getStatusCode() == 200) {
            // Successful API call
            String responseBody = response.getBody();
          //  System.debug('API Response: ' + responseBody);
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            System.debug('params=====' + params);
		    updateSalesforceContacts(params);
            List<Object> namesList = new List<Object>();
            if (params.containsKey('connections')) {
                namesList = (List<Object>) params.get('connections');
            }
            String etag;
            String resourceName;
            String firstName;
            String lastName;
            String phone;
            Map<String, Object> conList = new Map<String, Object>();
            List<Contact> contactsToInsert = new List<Contact>();
            for (Object obj : namesList) {
                conList = (Map<String, Object>) obj;
                if(conList.containsKey('resourceName')){
                    resourceName=(String) conList.get('resourceName');
                    system.debug('resourceName'+resourceName);
                }
                if (conList.containsKey('etag')) {
                    etag = (String) conList.get('etag');
                    System.debug('this is the' + etag);
                }
                List<Object> namesList1 = new List<Object>();
                if (conList.containsKey('names')) {
                    namesList1 = (List<Object>) conList.get('names');
                    for (Object nameObj : namesList1) {
                        Map<String, Object> nameMap = (Map<String, Object>) nameObj;
                        System.debug('nameMap====' + nameMap);
                        if (nameMap.containsKey('givenName')) {
                            lastName = (String) nameMap.get('givenName');
                            System.debug('lastName========' + lastName);
                        }
                        if (nameMap.containsKey('familyName')) {
                            firstName = (String) nameMap.get('familyName');
                            // System.debug('lastName========'+firstName);
                        }
                        // if (nameMap.containsKey('phoneNumbers')) {
                        //     phone = (String) nameMap.get('phoneNumbers');
                        //     // System.debug('lastName========'+firstName);
                        // }
                    }
                    List<Contact> existingContacts = [SELECT Id, FirstName,Resource_Name__c, LastName,Phone FROM Contact WHERE Resource_Name__c = :ResourceName];
                    System.debug('existingContacts-----------------'+existingContacts);
                    if (existingContacts.isEmpty()) {
                        System.debug('after if condition----------------'+existingContacts);                        
                        // If no contact with the same etag exists, create a new contact
                        Contact newContact = new Contact();
                        newContact.FirstName = firstName;
                        newContact.LastName = lastName;
                        newContact.etag__c = etag; // Set the etag__c field with the etag value
                        newContact.Resource_Name__c = resourceName;
                     //   newContact.Phone=phone;
                        contactsToInsert.add(newContact);
                System.debug('contactsToInsert'+contactsToInsert);
                    }
                }
            }
            // Insert the new contacts in Salesforce
            if (!contactsToInsert.isEmpty()) {
                System.debug('i am in insert operation in main method');
                Insert contactsToInsert;
                System.debug('Inserted Contacts:' + contactsToInsert);
            }
        } else {
            // Handle API call errors
            System.debug('API Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
        }
    }
    //Method for update the contact in salesforce. 
    public static void updateSalesforceContacts(Map<String, Object> googleApiResponse) {
        System.debug('i am in  a update ---------');
        List<Object> contactsList = (List<Object>) googleApiResponse.get('connections');
        for (Object contactObj : contactsList) {      
        Map<String, Object> contactMap = (Map<String, Object>) contactObj;
        String resourceName=(String)contactMap.get('resourceName');
        String etag = (String) contactMap.get('etag');  
        List<Contact> existingContacts = [SELECT Id, FirstName,Resource_Name__c, LastName, etag__c,Phone FROM Contact WHERE Resource_Name__c = :resourceName];  
        System.debug('Update Query----------------------'+existingContacts); 
        if (!existingContacts.isEmpty()) {
            System.debug('i am in inside of update if condition');
            Contact existingContact = existingContacts[0];  
            // Update the contact fields based on the new data
            // For example, update the first name and last name
            if (contactMap.containsKey('names')) {
                List<Object> namesList = (List<Object>) contactMap.get('names');
                // List<Object> phoneNumbers=(List<Object>) contactMap.get('phoneNumbers');
                 System.debug('namesList----------'+namesList);
                List<Object> combinedList = new List<Object>();
                combinedList.addAll(namesList);
             //   combinedList.addAll(phoneNumbers);
                for (Object nameObj : combinedList) {
                    Map<String, Object> nameMap = (Map<String, Object>) nameObj;
                    if (nameMap.containsKey('givenName')) {
                        existingContact.FirstName = (String) nameMap.get('givenName');
                    }
                    if (nameMap.containsKey('familyName')) {
                        existingContact.LastName = (String) nameMap.get('familyName');
                    }
                    // if (nameMap.containsKey('phoneNumbers')) {
                    //     existingContact.phone = (String) nameMap.get('phoneNumbers');                      
                    // }
                }
            }   
            System.debug('existing contact---------------'+existingContact);       
            update existingContact;
            } else {
                System.debug('No matching contact found with etag: ' + etag);
            }
        }
    }
}