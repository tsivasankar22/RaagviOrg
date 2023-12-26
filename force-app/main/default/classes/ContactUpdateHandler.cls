/* 
        class name :  ContactUpdateHandler
        Description : four picklist values and four checkbox fields based on the conditions it is stored to some text boxex fields                    
     */
public with sharing class ContactUpdateHandler {
    public static void updateS1Field(List<Contact> contacts) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact con : contacts) {
            String s1Value = 'Originator__c=' + con.Originator__c + '\n' +
                             'RFS2__c=' + con.RFS2__c + '\n' +
                             'RF_1_1__c=' + con.RF_1_1__c + '\n' +
                             'User_Department__c=' + con.User_Department__c;
            // Check the checkboxes and update text fields accordingly
            if (con.S1Check__c == true && String.isBlank(con.S1__c)) {
                System.debug('i am in S1');
                con.S1__c = s1Value;
                contactsToUpdate.add(con);
            }
            if (con.S2Check__c == true && String.isBlank(con.S2__c)) {
                System.debug('i am in S2');
                con.S2__c = s1Value;
                contactsToUpdate.add(con);
            }
            if (con.S3Check__c == true && String.isBlank(con.S3__c)) {
                System.debug('i am in S3');
                con.S3__c = s1Value;
                contactsToUpdate.add(con);
            }
            if (con.S4Check__c == true && String.isBlank(con.S4__c)) {
                System.debug('i am in S4');
                con.S4__c = s1Value;
                contactsToUpdate.add(con);
            }
        }
        if (!contactsToUpdate.isEmpty()) {
          //  update contactsToUpdate;
        }
    }
}
