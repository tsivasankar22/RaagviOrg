@RestResource(urlMapping='/allObjects1/*')
global class SalesforceIntegrationDynamicObjRec
{
    @HttpPost
    global static void createAccount()
    {
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;       
        String jsonString = restReq.requestBody.toString();     
        System.debug('jsonString=====>'+jsonString);
        List<Object> parsedData = (List<Object>) JSON.deserializeUntyped(jsonString);        
        if(parsedData.size() > 0)
        {
            // Get the first item from the list
            Map<String, Object> recordData = (Map<String, Object>) parsedData[0];
            recordData.remove('Id');          
            // Extract the object name from the "type" attribute
            Map<String, Object> attributes = (Map<String, Object>) recordData.get('attributes');
            String objectType = (String) attributes.get('type');
            if(objectType != 'Account')
            {
                recordData.remove('Name');
            }
            // Create an SObject instance for the specified object type
            SObject newRecord = Schema.getGlobalDescribe().get(objectType).newSObject();           
            // Set field values using API names and field values from the recordData map
            for (String key : recordData.keySet())
            {
                if (!key.equals('attributes'))
                {
                    newRecord.put(key, recordData.get(key));
                }
            }          
            // Insert the new record
            Database.SaveResult result = Database.insert(newRecord, false);            
            if(result.isSuccess())
            {
                System.debug('Record inserted successfully: ' + result.getId());
            }else
            {
                System.debug('Record insertion failed with errors: ' + result.getErrors());
            }
        }
    }
}