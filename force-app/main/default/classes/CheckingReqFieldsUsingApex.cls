public with sharing class CheckingReqFieldsUsingApex {
    public static List<String> checkRequiredField( String strObjName ) {        
        SObjectType objType = Schema.getGlobalDescribe().get( strObjName );
        Map < String, Schema.SObjectField > mapFields = objType.getDescribe().fields.getMap();
        List<String> reqFields = new List<String>();
        for (String strField : mapFields.keySet()) {
            SObjectField field = mapFields.get(strField);
            Schema.DescribeFieldResult fieldResult = field.getDescribe();          
            if (!fieldResult.isNillable() && !fieldResult.isDefaultedOnCreate()) {
                reqFields.add(fieldResult.getLocalName());
               // System.debug(fieldResult.getLocalName() + ' is required.');
            }
        }  
        System.debug(reqFields + ' are required.');
        return reqFields;
    }
     public static List<SObject> queryWithRequiredFields(String objectName) {
        List<String> reqFields = CheckingReqFieldsUsingApex.checkRequiredField(objectName);
        System.debug(reqFields + '-----------reqFields');
        String query = 'SELECT ' + String.join(reqFields, ',') + ' FROM ' + objectName + ' WHERE Id = \'a045i000008Tm9NAAS\'';
        System.debug(query + '-----------query');
         list<SObject> listOfObj = Database.query(query);
         System.debug('listOfObj=====>'+listOfObj);
         return Database.query(query);
    }
}