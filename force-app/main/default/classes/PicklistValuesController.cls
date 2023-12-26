/* 
        class name :  PicklistValuesController
        Description : four picklist values and four checkbox fields based on the conditions it is stored to some text boxex fields
                      it is in LWC component and that LWC Component called in vf page that vf page added into record detail page miidle of records  
     */

public with sharing class PicklistValuesController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues(String objectName, List<String> fieldNames) {
        System.debug('Object Name: ' + objectName);
        System.debug('Field Names: ' + fieldNames);
        Map<String, List<String>> picklistValuesMap = new Map<String, List<String>>();
        for (String fieldName : fieldNames) {
            picklistValuesMap.put(fieldName, new List<String>());      
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Contact.fields.getMap().get(fieldName).getDescribe();  
            if (fieldResult.isAccessible()) {
                List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry entry : picklistEntries) {
                    picklistValuesMap.get(fieldName).add(entry.getValue());
                }
            }
        }     
        return picklistValuesMap;
    }
    @AuraEnabled
 public static Contact updateField(String recordId, Map<String, String> fieldValues) {
    System.debug('recordID------------'+recordId);
    system.debug('fieldvalues---------'+fieldValues);
    Contact con = [select id,S1Check__c, S2Check__c, S3Check__c, S4Check__c ,S1__c, S2__c, S3__c, S4__c, RF_1_1__c, RFS2__c, User_Department__c, Originator__c from Contact where Id=:recordId];    
    // Loop through the fieldValues map and update the Contact record
    for (String fieldName : fieldValues.keySet()) {
        String value = fieldValues.get(fieldName);
        
        // Use the fieldName and value to update the corresponding field in the Contact record
        if (fieldName == 'RF_1_1__c') {
            con.RF_1_1__c = value;
        } else if (fieldName == 'RFS2__c') {
            con.RFS2__c = value;
        } else if (fieldName == 'User_Department__c') {
            con.User_Department__c = value;
        } else if(fieldName == 'Originator__c'){
            con.Originator__c =value;
        }
     }
           // Construct the concatenated string with line breaks
            String s1Value = 'Originator__c=' + con.Originator__c + '\n' +
            'RFS2__c=' + con.RFS2__c + '\n' +
            'RF_1_1__c=' + con.RF_1_1__c + '\n' +
            'User_Department__c=' + con.User_Department__c;     
           // Check the checkboxes and update text fields accordingly
            if (con.S1Check__c == true && String.isBlank(con.S1__c)) {
                System.debug('i am in S1');
                con.S1__c = s1Value;
            }
            if (con.S2Check__c == true && String.isBlank(con.S2__c)) {
                System.debug('i am in S2');
                con.S2__c = s1Value; 
            }
            if (con.S3Check__c == true && String.isBlank(con.S3__c)) {
                System.debug('i am in S3');
                con.S3__c = s1Value; 
            }
            if (con.S4Check__c == true && String.isBlank(con.S4__c)) {
                System.debug('i am in S4');
                con.S4__c = s1Value; 
            }
                upsert con;            
                return con;
}  
}

