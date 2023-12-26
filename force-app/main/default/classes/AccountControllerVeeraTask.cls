public with sharing class AccountControllerVeeraTask {
    @AuraEnabled(cacheable=true)
    public static List<AccountPicklistFieldWrapper> getAccountPicklistFields() {
        List<AccountPicklistFieldWrapper> picklistFields = new List<AccountPicklistFieldWrapper>();

        // Specify the API name of the field set
        String fieldSetName = 'PickListValues';

        // Retrieve the field set
        List<Schema.FieldSetMember> fieldSetMembers = 
            SObjectType.Account.FieldSets.getMap().get(fieldSetName).getFields();

        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            String fieldName = fsm.getFieldPath();
            Schema.SObjectField field = Account.getSObjectType().getDescribe().fields.getMap().get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (fieldDescribe.isAccessible() && fieldDescribe.isUpdateable() && fieldDescribe.isCreateable() && fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                List<String> picklistValues = new List<String>();
                for (Schema.PicklistEntry picklistEntry : fieldDescribe.getPicklistValues()) {
                    picklistValues.add(picklistEntry.getLabel());
                }

                picklistFields.add(new AccountPicklistFieldWrapper(fieldName, fieldDescribe.getLabel(), picklistValues));
            }
        }
        System.debug('picklist---------'+picklistFields);
        return picklistFields;
    }

    public class AccountPicklistFieldWrapper {
        @AuraEnabled
        public String fieldName { get; set; }
        @AuraEnabled
        public String fieldLabel { get; set; }
        @AuraEnabled
        public List<String> picklistValues { get; set; }

        public AccountPicklistFieldWrapper(String fieldName, String fieldLabel, List<String> picklistValues) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.picklistValues = picklistValues;
        }
    }
}