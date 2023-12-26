public class GoogleContacts {
//   public static void getGoogleContacts(){
//         Http ht=new Http();
//         HttpRequest req=new HttpRequest();
//         req.setEndpoint('Callout:Google'+'/v1/people/me/connections?personFields=phoneNumbers,emailAddresses,genders,names');
//         req.setMethod('GET');       
//     //  req.setHeader('Content-Type', 'application/json');
//         HttpResponse responce=ht.send(req);
//         String etagVar=responce.getBody();
//         String etag=etagVar.resourceName;
//         System.debug('responce debug========'+etagVar);
//         System.debug('responceeee-----'+responce.getStatusCode());
//         System.debug('get code-----'+responce.getBody());     
//     }
    public static void getGoogleContacts(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('Callout:Google'+'/v1/people/me/connections?personFields=phoneNumbers,emailAddresses,genders,names');
        request.setMethod('GET');  
        HttpResponse response = http.send(request);    
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('jsonResponse---------'+jsonResponse);
            List<Object> connections = (List<Object>) jsonResponse.get('connections');
            system.debug('connections---------'+connections);       
            for (Object connection : connections) {
                Map<String, Object> contactData = (Map<String, Object>) connection;
                String etag = (String) contactData.get('etag');
                String resourceName = (String) contactData.get('resourceName');
                system.debug('etag-------------'+etag);
                system.debug('resourceName-------------'+resourceName);
            }
        } else {
            System.debug('Request failed with status code: ' + response.getStatusCode());
        }
    }
    // public static void createGoogleContact() {
    //     Http http = new Http();
    //     HttpRequest request = new HttpRequest();
    //      request.setEndpoint('Callout:Google'+'/v1/people:createContact');
    //     request.setMethod('POST');
    //     request.setHeader('Content-Type', 'application/json');
    //     request.setBody('{"names": [{"familyName": "sankara"}]}');   
    //     HttpResponse response = http.send(request); 
             
    //     System.debug('Response Code: ' + response.getStatusCode());
    //     System.debug('Response Body: ' + response.getBody());
    // }  
  /*  @Future(callout=true)
    public static void createGoogleContactAsync(Id contactId) {
        Contact newContact = [SELECT FirstName, LastName,Email,Phone FROM Contact WHERE Id = :contactId LIMIT 1];      
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('Callout:Google' + '/v1/people:createContact');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');       
        // Construct the JSON payload for creating the contact
        String jsonPayload = '{"names": [{"givenName": "' + newContact.FirstName + '", "familyName": "' + newContact.LastName + '"}], "emailAddresses":[{"value":"'+newContact.Email +'"}], "phoneNumbers": [ { "value":"'+newContact.Phone+'" } ]}';
        request.setBody(jsonPayload);       
        HttpResponse response = http.send(request);       
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String etag = (String) jsonResponse.get('etag');
            String resourceName = (String) jsonResponse.get('resourceName');           
            // Update the Contact record with etag and resourceName
            Contact contactToUpdate = new Contact(Id = contactId);
            contactToUpdate.eTag__c = etag;
            contactToUpdate.Resource_Name__c = resourceName;            
            update contactToUpdate;
        } else {
            System.debug('Request failed with status code: ' + response.getStatusCode());
        }
    }   */
    @Future(callout=true)
    public static void createGoogleContactAsync(Id contactId) {
    Contact newContact = [SELECT FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];      
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('Callout:Google' + '/v1/people:createContact');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');        
    Map<String, Object> jsonPayloadMap = new Map<String, Object>();  
    List<Map<String, Object>> namesList = new List<Map<String, Object>>();
    Map<String, Object> nameMap = new Map<String, Object>();
    if (newContact.FirstName != null) {
        nameMap.put('givenName', newContact.FirstName);
    }
    if (newContact.LastName != null) {
        nameMap.put('familyName', newContact.LastName);
    }
    if (!nameMap.isEmpty()) {
        namesList.add(nameMap);
    }
    if (!namesList.isEmpty()) {
        jsonPayloadMap.put('names', namesList);
    }
    
    List<Map<String, Object>> emailList = new List<Map<String, Object>>();
    Map<String, Object> emailMap = new Map<String, Object>();
    if (newContact.Email != null) {
        emailMap.put('value', newContact.Email);
        emailList.add(emailMap);
    }
    if (!emailList.isEmpty()) {
        jsonPayloadMap.put('emailAddresses', emailList);
    }
    
    List<Map<String, Object>> phoneList = new List<Map<String, Object>>();
    Map<String, Object> phoneMap = new Map<String, Object>();
    if (newContact.Phone != null) {
        phoneMap.put('value', newContact.Phone);
        phoneList.add(phoneMap);
    }
    if (!phoneList.isEmpty()) {
        jsonPayloadMap.put('phoneNumbers', phoneList);
    }
    
    String jsonPayload = JSON.serialize(jsonPayloadMap);
    request.setBody(jsonPayload);       
    HttpResponse response = http.send(request);       
    if (response.getStatusCode() == 200) {
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String etag = (String) jsonResponse.get('etag');
        String resourceName = (String) jsonResponse.get('resourceName');           
        // Update the Contact record with etag and resourceName
        Contact contactToUpdate = new Contact(Id = contactId);
        contactToUpdate.eTag__c = etag;
        contactToUpdate.Resource_Name__c = resourceName;            
        update contactToUpdate;
    } else {
        System.debug('Request failed with status code: ' + response.getStatusCode());
    }
}
    @Future(callout=true)
    public static void DeleteGoogleContactAsync(String resourceName) {
        System.debug('resourceName-----------'+resourceName);       
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('Callout:Google' + '/v1/'+resourceName+':deleteContact');
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/json');          
        HttpResponse response = http.send(request);       
    }
 /*   public static void deleteGoogleContact() {
        String ContactId='fuck';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
         request.setEndpoint('Callout:Google'+'/v1/people/c6889625903105218349:deleteContact');
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/json');   
        HttpResponse response = http.send(request);      
        System.debug('Response Code: ' + response.getStatusCode());
        System.debug('Response Body: ' + response.getBody());
    }   */
    /* public static void updateGoogleContact() {
         String updatedPhoneNumber='9676101827';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
         request.setEndpoint('Callout:Google'+'/v1/people/c4962268408550589172:updateContact?updatePersonFields=names,phoneNumbers,emailAddresses');
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"etag":"%EgoBAggJCy43PT4/GgQBAgUHIgwvWklpK1pRTFlmMD0=", "emailAddresses":[{"value":"tsivasankar@21gmail.com"}], "phoneNumbers": [ { "value": "1234567890" } ] ,"names":[{"familyName":"Sivasankar T"}]}'); 
         //"phoneNumbers":[{"value":"9676101827"}],
        HttpResponse response = http.send(request);      
        System.debug('Response Code: ' + response.getStatusCode());
        System.debug('Response Body: ' + response.getBody());
    }   */  
    @Future(callout=true)
    public static void UpdateGoogleContactAsync(String resourceName) {
       Contact newContact = [SELECT Id,FirstName, Resource_Name__c,eTag__c,LastName,Email,Phone FROM Contact WHERE Resource_Name__c = :resourceName LIMIT 1];
       System.debug('resourceName-----------'+resourceName);     
    //   String requestBody='{"etag":"'+newContact.eTag__c+'","names": [{"givenName": "' + newContact.FirstName + '", "familyName": "' + newContact.LastName + '"}], "emailAddresses":[{"value":"'+newContact.Email +'"}], "phoneNumbers": [ { "value":"'+newContact.Phone+'"}]}' ; 
    //   System.debug('requestBody'+requestBody);
       Http http = new Http();
       HttpRequest request = new HttpRequest();
        request.setEndpoint('Callout:Google' + '/v1/'+resourceName+':updateContact?updatePersonFields=names,phoneNumbers,emailAddresses');
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json');  
       // request.setBody(requestBody); 
       // '{"names": [{"givenName": "' + newContact.FirstName + '", "familyName": "' + newContact.LastName + '"}],   
       Map<String, Object> jsonPayloadMap = new Map<String, Object>();  
       jsonPayloadMap.put('etag', newContact.Etag__c);
       List<Map<String, Object>> namesList = new List<Map<String, Object>>();
       Map<String, Object> nameMap = new Map<String, Object>();
       if (newContact.FirstName != null) {
           nameMap.put('givenName', newContact.FirstName);
       }
       if (newContact.LastName != null) {
           nameMap.put('familyName', newContact.LastName);
       }
       if (!nameMap.isEmpty()) {
           namesList.add(nameMap);
       }
       if (!namesList.isEmpty()) {
           jsonPayloadMap.put('names', namesList);
       }
       
       List<Map<String, Object>> emailList = new List<Map<String, Object>>();
       Map<String, Object> emailMap = new Map<String, Object>();
       if (newContact.Email != null) {
           emailMap.put('value', newContact.Email);
           emailList.add(emailMap);
       }
       if (!emailList.isEmpty()) {
           jsonPayloadMap.put('emailAddresses', emailList);
       }
       
       List<Map<String, Object>> phoneList = new List<Map<String, Object>>();
       Map<String, Object> phoneMap = new Map<String, Object>();
       if (newContact.Phone != null) {
           phoneMap.put('value', newContact.Phone);
           phoneList.add(phoneMap);
       }
       if (!phoneList.isEmpty()) {
           jsonPayloadMap.put('phoneNumbers', phoneList);
       }
       
       String jsonPayload = JSON.serialize(jsonPayloadMap);
       request.setBody(jsonPayload);       
       HttpResponse response = http.send(request);  
       if (response.getStatusCode() == 200) {
           Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
           String etag = (String) jsonResponse.get('etag');
           String resourceName1 = (String) jsonResponse.get('resourceName');          
           // Update the Contact record with etag and resourceName
           Contact contactToUpdate = new Contact(Id = newContact.Id);
           contactToUpdate.eTag__c = etag;
           contactToUpdate.Resource_Name__c = resourceName1;           
           update contactToUpdate;
       } else {
           System.debug('Request failed with status code: ' + response.getStatusCode());
       }   
        system.debug('response------------'+response);
    }
}