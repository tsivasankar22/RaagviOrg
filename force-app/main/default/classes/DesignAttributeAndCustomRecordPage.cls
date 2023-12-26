public with sharing class DesignAttributeAndCustomRecordPage {
    @AuraEnabled(cacheable=true)
    public static List<sObject> fetchRecs(String objName, String fields, Integer NumberOfRecords) {
    
        String query = 'SELECT ' + fields + ' FROM ' + objName + ' LIMIT :NumberOfRecords';
        System.debug('query========' + query);

        // Execute the query and return the results
        return Database.query(query);
    }
//     @AuraEnabled
// public static Map<String, Integer> getRelatedObjectCounts(String objName, String recordId) {
//     // Get the describe result for the object
//     Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
//     // Get the child relationships for the object
//     List<Schema.ChildRelationship> childRelationships = objDescribe.getChildRelationships();

//     // Define a map to hold the related object names and their record counts
//     Map<String, Integer> relatedObjectCounts = new Map<String, Integer>();

//     // Loop through the child relationships to find the related objects we're interested in
//     for(Schema.ChildRelationship relationship : childRelationships) {
//         String childObjectName = relationship.getChildSObject().getDescribe().getName();
//         // Check if the related object has a child relationship with the parent object
//         List<Schema.ChildRelationship> parentChildRelationships = relationship.getChildSObject().getDescribe().getChildRelationships();
//         Boolean hasParentChildRelationship = false;
//         for(Schema.ChildRelationship parentChildRelationship : parentChildRelationships) {
//             if(parentChildRelationship.getChildSObject().getDescribe().getName() == objName) {
//                 hasParentChildRelationship = true;
//                 break;
//             }
//         }
//         if (hasParentChildRelationship) {
//             String query = 'SELECT COUNT() FROM ' + childObjectName + ' WHERE ' + relationship.getField() + ' = \'' + recordId + '\'';
//             Integer recordCount = Database.countQuery(query);
//             relatedObjectCounts.put(childObjectName, recordCount);
//         }
//     }

//     return relatedObjectCounts;
// }
    
// @AuraEnabled
// public static Map<String, Integer> getRelatedObjectCounts(String objName, String recordId) {
//     // Get the describe result for the object
//     Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
//     // Get the child relationships for the object
//     List<Schema.ChildRelationship> childRelationships = objDescribe.getChildRelationships();

//     // Define a map to hold the related object names and their record counts
//     Map<String, Integer> relatedObjectCounts = new Map<String, Integer>();

//     // Loop through the child relationships to find the related objects we're interested in
//     for(Schema.ChildRelationship relationship : childRelationships) {
//         String childObjectName = relationship.getChildSObject().getDescribe().getName();
//         // Check if the related object has a child relationship with the parent object
//         List<Schema.ChildRelationship> parentChildRelationships = relationship.getChildSObject().getDescribe().getChildRelationships();
//         Boolean hasParentChildRelationship = false;
//         for(Schema.ChildRelationship parentChildRelationship : parentChildRelationships) {
//             if(parentChildRelationship.getChildSObject().getDescribe().getName() == objName) {
//                 hasParentChildRelationship = true;
//                 break;
//             }
//         }
//         if (hasParentChildRelationship) {
//             String query = 'SELECT COUNT() FROM ' + childObjectName + ' WHERE ' + relationship.getField() + ' = \'' + recordId + '\'';
//             Integer recordCount = Database.countQuery(query);
//             relatedObjectCounts.put(childObjectName, recordCount);
//         } else if (childObjectName == 'Case') {
//             String query = 'SELECT COUNT() FROM ' + childObjectName + ' WHERE ' + relationship.getField() + ' = \'' + recordId + '\'';
//             Integer recordCount = Database.countQuery(query);
//             relatedObjectCounts.put(childObjectName, recordCount);
//         }
//     }

//     return relatedObjectCounts;
// }

@AuraEnabled
public static Map<String, Integer> getRelatedObjectCounts(String objName, String recordId) {
    // Get the describe result for the object
    Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
    // Get the child relationships for the object
    List<Schema.ChildRelationship> childRelationships = objDescribe.getChildRelationships();
  //  System.debug('childRelationships-----------'+childRelationships);

    // Define a map to hold the related object names and their record counts
    Map<String, Integer> relatedObjectCounts = new Map<String, Integer>();

    // Loop through the child relationships to find the related objects we're interested in
    for(Schema.ChildRelationship relationship : childRelationships) {
        String childObjectName = relationship.getChildSObject().getDescribe().getName();
        System.debug('childObjectName-----------'+childObjectName);
        // Check if the related object has a child relationship with the parent object
        List<Schema.ChildRelationship> parentChildRelationships = relationship.getChildSObject().getDescribe().getChildRelationships();
       
      //  System.debug('parentChildRelationships-----------'+parentChildRelationships);
        Boolean hasParentChildRelationship = false;
        for(Schema.ChildRelationship parentChildRelationship : parentChildRelationships) {
            String parentObjectName = parentChildRelationship.getChildSObject().getDescribe().getName();
            System.debug('parentObjectName------------------'+parentObjectName);
            if(parentChildRelationship.getChildSObject().getDescribe().getName() == objName) {
                hasParentChildRelationship = true;
                break;
            }
        }
        if (hasParentChildRelationship && relationship.getChildSObject().getDescribe().isQueryable()) {
            String query = 'SELECT COUNT() FROM ' + childObjectName + ' WHERE ' + relationship.getField() + ' = \'' + recordId + '\'';
            Integer recordCount = Database.countQuery(query);
            relatedObjectCounts.put(childObjectName, recordCount);
        }
    }
    System.debug('relatedObjectCounts-----------'+relatedObjectCounts);
    return relatedObjectCounts;
}
}