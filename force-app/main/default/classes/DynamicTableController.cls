//this is a wrapper class name is DynamicTableController
public with sharing class DynamicTableController {

    @AuraEnabled
    public static TableInfoWrapper getTableInfo(String sObjectName){
        // Define a wrapper class to hold table information.
        TableInfoWrapper tableInfoWrapper = new TableInfoWrapper();
        try{
            // Get the list of fields for the specified object and set it in the wrapper.
            tableInfoWrapper.columns = getFields(sObjectName);
            // Get the plural label for the specified object and set it in the wrapper.
            tableInfoWrapper.sObjectPluralLabel = sObjectPluralLabel(sObjectName);
            // Create a set to hold the names of the fields to query.
            Set<String> fieldSet = new Set<String>();
            // Loop through the list of fields and add the appropriate fields to the field set.
            for(FieldWrapper fieldWrapper:tableInfoWrapper.columns){
                if(fieldWrapper.type.toUpperCase() == 'REFERENCE'){
                    if(fieldWrapper.fieldName.endsWith('Id')){
                       // If the field is a reference to another object, get the name field of the referenced object.
                        String fldString = fieldWrapper.fieldName.removeEnd('Id') + '.Name';
                        fieldSet.add(fldString);
                    }else if(fieldWrapper.fieldName.endsWith('__c')){
                        // If the field is a custom reference to another object, get the name field of the referenced object.
                        String fldString = fieldWrapper.fieldName.removeEnd('__c') + '__r.Name';
                        fieldSet.add(fldString);
                    }
                    else {
                        // If the field is a lookup or master-detail field, get the name field of the referenced object.
                        String fldString = fieldWrapper.fieldName + '.Name';
                        fieldSet.add(fldString);
                    }
                }else {
                    // If the field is not a reference field, add it to the field set.
                    fieldSet.add(fieldWrapper.fieldName);
                }
            }
            // If there are fields to query, get the records for the specified object and field set and set it in the wrapper.
            if(fieldSet.size() > 0){
                tableInfoWrapper.tableData = getRecords(sObjectName,fieldSet);
            }
        }catch (Exception exp){
            // If an exception occurs, log the message and throw an AuraHandledException.
            System.debug('Exception Message ::'+exp.getMessage() + ' At Line Number ::'+exp.getLineNumber());
            throw new AuraHandledException(exp.getMessage() +  ' at Line '+exp.getLineNumber());
        }
        // Return the table information wrapper.
        return tableInfoWrapper;
    }
    
    Public class TableInfoWrapper{
        @AuraEnabled public List<FieldWrapper> columns {get;set;}
        @AuraEnabled public String tableData {get;set;}
        @AuraEnabled public String sObjectPluralLabel {get;set;}
    }
    private static List<FieldWrapper> getFields(String sObjectName){
        List<FieldWrapper> fieldWrappers = new List<FieldWrapper>();  // create an empty list of FieldWrapper objects
        ObjectField__mdt objectField= new ObjectField__mdt();  // create a new ObjectField__mdt object
        objectField = [SELECT Related_Field_API_Names__c FROM ObjectField__mdt WHERE MasterLabel =:sObjectName];  // query the metadata object for related field API names
     
        if(objectField.Related_Field_API_Names__c !=null){
            if(objectField.Related_Field_API_Names__c.contains(' ')){
                objectField.Related_Field_API_Names__c = objectField.Related_Field_API_Names__c.replaceAll(' ','');  // replace all spaces in the related field API names string
            }
            List<String> fieldAPINames = objectField.Related_Field_API_Names__c.toLowerCase().split(',');  // create a list of related field API names
     
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();  // get a map of all sObject types
            Schema.SObjectType objectType = schemaMap.get(sObjectName);  // get the sObject type from the sObjectName string
            Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();  // get a map of all fields for the sObject type
     
            for (String fieldName: fieldMap.keySet()) {  // loop through each field name in the fieldMap
                if(fieldAPINames.contains(fieldName.toLowerCase())){  // if the field name is in the list of related field API names
                    FieldWrapper wrapper = new FieldWrapper();  // create a new FieldWrapper object
                    wrapper.label = fieldMap.get(fieldName).getDescribe().getLabel();  // set the label variable of the FieldWrapper object to the label of the field
                    wrapper.type = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());  // set the type variable of the FieldWrapper object to the type of the field
                    wrapper.fieldName = String.valueOf(fieldMap.get(fieldName));  // set the fieldName variable of the FieldWrapper object to the name of the field
                    fieldWrappers.add(wrapper);  // add the FieldWrapper object to the list of FieldWrapper objects
                }
            }
        }
        return fieldWrappers;  // return the list of FieldWrapper objects
    }
    // access the AuraEnabled
    Public class FieldWrapper{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String type {get;set;}
        @AuraEnabled public String fieldName {get;set;}
    }
    private static String sObjectPluralLabel(String sObjectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();  // Gets a map of all available sObject types in the org.
        Schema.SObjectType objectType = schemaMap.get(sObjectName);  // Gets the sObject type based on the sObject name parameter.
        return objectType.getDescribe().getLabelPlural();  // Returns the plural label for the sObject type.
    }
    
    private static String getRecords(String sObjectName,  Set<String> fieldSet) {
        List<sObject> lstResult = new List<sObject>();  // Declares a list of sObjects to store the query results.
        String result = '[]';  // Declares a default JSON string for the query results.
        List<String> fieldList =  new List<String>(fieldSet);  // Converts the input field set to a list of field names.
        String query = 'SELECT '+String.join(fieldList,',')+' FROM ' + sObjectName;  // Constructs a SOQL query string using the sObject name and field list.
        System.debug('query===================================='+query);
        for (SObject sobj : Database.query(query)) {  // Executes the SOQL query and iterates through the results.
            lstResult.add(sobj);  // Adds each query result to the list of sObjects.
        }
        if (lstResult.size() > 0) {  // If the query returned any results,
            result = JSON.serialize(lstResult);  // serialize the list of sObjects into a JSON string.
        }
        return result;  // Returns the JSON string of query results.
    }  

@AuraEnabled
public static void updateAcc(Object acc, List<String> recordIds, String sObjectName) 
{
    
    System.debug('Object acc: ' + acc);
    System.debug('Record IDs: ' + recordIds);
    System.debug('Object name: ' + sObjectName);
    
    
    Map<String, Object> mapData = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(acc));
    System.debug('mapData'+mapData);
    List<sObject> listobj = new List<sObject>();

    Set<String> recSet = new Set<String>(recordIds);
    List<String> recList = new List<String>(recSet);

    for (String recId : recList) {
        Map<String, Object> obj =(Map<String, Object>) mapData.get(recId);
        

        System.debug('obj map'+obj);
        if (obj != null) {
            sObject sobj = (sObject) Type.forName(sObjectName).newInstance();
           sobj.Id = recId;
          
            for (String fieldName : obj.keySet()) {
                Object fieldValue = obj.get(fieldName);
                System.debug('fieldname '+fieldName);
                SObjectField sobjField = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName);
                if (sobjField != null) {
                    Schema.DisplayType fieldType = sobjField.getDescribe().getType();
                    System.debug('field Type '+fieldType);
                   
                    if (fieldType == Schema.DisplayType.String ) {
                        sobj.put(fieldName, (String) fieldValue);
                    } else if (fieldType == Schema.DisplayType.Integer) {
                        sobj.put(fieldName, Integer.valueOf(fieldValue));
                    } else if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Percent || fieldType == Schema.DisplayType.Currency) {
                        sobj.put(fieldName, Double.valueOf(fieldValue));
                    } else if (fieldType == Schema.DisplayType.Date) {
                        sobj.put(fieldName, Date.valueOf((String)fieldValue));
                    }
                    else if (fieldType == Schema.DisplayType.DateTime) {
                       
                        try {
                            String datetimeStr = (String)fieldValue;
                            String dateStr = datetimeStr.substring(0, 10);
                            String timeStr = datetimeStr.substring(11, 19);
                            String formattedDateTimeString = dateStr + ' ' + timeStr;
                            System.debug(formattedDateTimeString);
                            sobj.put(fieldName, DateTime.valueOf(formattedDateTimeString));
                        } catch (Exception e) {
                            System.debug('An exception occurred: ' + e.getMessage());
                        }
                 
                    }
                    else if (fieldType == Schema.DisplayType.Boolean) {
                        sobj.put(fieldName, (Boolean) fieldValue);
                    } else{
                        sobj.put(fieldName, (String) fieldValue);
                    }
                                    
                }
            }
            listobj.add(sobj);
        }
    }
       // Update the records
        List<Database.SaveResult> results = Database.update(listobj);
        // Check the results
        for (Integer i = 0; i < results.size(); i++) {
        if (results[i].isSuccess()) {
            System.debug('Record updated successfully: ' + results[i].getId());
        } else {
            System.debug('Failed to update record: ' + results[i].getErrors()[0].getMessage());
        }
    }
} 
}