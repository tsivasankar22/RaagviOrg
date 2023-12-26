/*
Class Name : AccordionHandler
Created By : Shiva Shankar
Created date : 12-04-2023
Description: this class contains insert record into Feedback__c object 
Last Modifyed Date : 24-04-2023
*/
public with sharing class AccordionHandler {
    
    // This method creates a new record in the Feedback__c object and sends an automatic response email
    @AuraEnabled
    public static void createFeedback(String firstname, String lastname, String reason, String suggestions) {
        String userId = UserInfo.getUserId();
        User currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
        
        Feedback__c newFeedback = new Feedback__c();
        newFeedback.FirstName__c = firstname;
        newFeedback.LastName__c = lastname;
        newFeedback.Feedback_Rating__c = reason;
        newFeedback.Suggestions__c = suggestions;
        insert newFeedback;
        
        sendAutoResponseEmail(currentUser.Email, firstname);
        System.debug('currentUser.Email========='+currentUser.Email);

        System.debug('insert====' + newFeedback);
    }
    
    // This method sends an automatic response email
    private static void sendAutoResponseEmail(String recipientEmail, String recipientName) {

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ recipientEmail });
        System.debug('setToAddresses============'+recipientEmail);
        email.setSubject('Thank you for your feedback');
        email.setPlainTextBody('Dear ' + recipientName + ',\n\nThank you for your feedback. We appreciate your input and will take it into consideration.\n\nBest regards,\nYour Company');
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        System.debug('results------------'+results);
        if (results[0].isSuccess()) {
            System.debug('Automatic response email sent successfully.');
        } else {
            System.debug('Failed to send automatic response email: ' + results[0].getErrors()[0].getMessage());
        }
    }
}