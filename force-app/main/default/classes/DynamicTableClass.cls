public with sharing class DynamicTableClass {
    @AuraEnabled(cacheable=true)
    public static List<Object> getObjName() {
        List<Object> objName = new List<Object>();
        List<Schema.SObjectType> sObjects = Schema.getGlobalDescribe().Values();
        for (Schema.SObjectType apiName : sObjects){
            objName.add(apiName.getDescribe().getName());
        }
        return objName; 
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getAllFieldName(String selectedObject) {
        List<String> reqFields = new List<String>();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(selectedObject);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        for(String fieldName : MapofField.keySet()) {
            reqFields.add(fieldName);
        }
        return reqFields;
    }
      @AuraEnabled(cacheable=true)
    public static List<Object> sendData(String objectName,List<String> fieldNames) {
        System.debug('objectName>>>'+objectName);
        System.debug('fieldNames>>>'+fieldNames);

        String query = 'SELECT ' + String.join(fieldNames,',') + ' FROM ' + objectName;
        List<SObject> records = Database.query(query);
        System.debug('records>>>'+records);
		return records;
    }
}