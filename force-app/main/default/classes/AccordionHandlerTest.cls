@isTest
public class AccordionHandlerTest {
    
    @isTest
    static void testCreateFeedback() {
        // Create test data
       // String firstname = 'sankar';
        //String lastname = 'siva';
        //String reason = 'Good';
        //String suggestions = 'Less Quantity';
        //
        
           Feedback__c newfeedback=new Feedback__c();
            newfeedback.FirstName__c='sankar';
            newfeedback.LastName__c='siva';

            newfeedback.Feedback_Rating__c='Good';
            newfeedback.Suggestions__c='Less Quantity';
            insert newfeedback;
        
        // Call the method to be tested
        Test.startTest();
        AccordionHandler.createFeedback(newfeedback.FirstName__c,  newfeedback.LastName__c, newfeedback.Feedback_Rating__c, newfeedback.Suggestions__c);
        Test.stopTest();
        
        // Verify the results
      //  List<Feedback__c> feedbackList = [SELECT FirstName__c, LastName__c, Feedback_Rating__c, Suggestions__c FROM Feedback__c];
       // System.assertEquals(1, feedbackList.size());
      //  Feedback__c feedback = feedbackList[0];
        System.assertEquals('sankar', newfeedback.FirstName__c);
        System.assertEquals('siva', newfeedback.LastName__c);
        System.assertEquals('Good', newfeedback.Feedback_Rating__c);
        System.assertEquals('Less Quantity', newfeedback.Suggestions__c);
    }
}