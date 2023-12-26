@isTest
private class StepperComponentHandlerTest {
    @isTest
    static void testGetAllEvents() {
        // Insert a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact1=new Contact(LastName='sivasankara');
        insert testContact1;

        // Insert some test cases related to the account
        List<Case> testCases = new List<Case>();
        testCases.add(new Case(AccountId = testAccount.Id,  Subject = 'Test Case 1'));
        testCases.add(new Case(AccountId = testAccount.Id,  Subject = 'Test Case 2'));
        testCases.add(new Case(AccountId = testAccount.Id,  Subject = 'Test Case 3'));
        insert testCases;
         List<Contact> testContact=new LIst<Contact>();
         testContact.add(new contact(AccountId=testAccount.Id,LastName='sankar',Phone='987654321',Email='sivasankae@gmail.com'));
         testContact.add(new contact(AccountId=testAccount.Id,LastName='siva',Phone='987654397821',Email='sivasane@gmail.com'));
        insert testContact; 
        List<Contact> testContact2=new LIst<Contact>();
         testContact2.add(new contact(LastName='sankar',Phone='987654321',Email='sivasankae@gmail.com'));
        insert testContact2; 
        
        // Call the method being tested
        List<Case> results = StepperComponentHandler.getAllEvents(testAccount.Id);
        List<Contact> con=StepperComponentHandler.getcontact(testAccount.Id);
         List<Contact> con1=StepperComponentHandler.getselectedcontact(testContact1.Id);
        List<Case> CaseID = StepperComponentHandler.getCase(testAccount.Id);
        // Verify the results
        System.assertEquals(3, results.size());   
        System.assertEquals('Test Case 1', results[0].Subject);  
        System.assertEquals('Test Case 2', results[1].Subject);  
        System.assertEquals('Test Case 3', results[2].Subject);
        
        //verify tthe contacts
        System.assertEquals(2, con.size()); 
        System.assertEquals('sivasankae@gmail.com', con[0].Email); 
        System.assertEquals('sivasane@gmail.com', con[1].Email);
        System.assertEquals('987654321', con[0].Phone); 
        System.assertEquals('987654397821', con[1].Phone); 
        System.assertEquals(1, testContact2.size());   
        System.assertEquals('987654321', testContact2[0].Phone); 
        System.assertEquals('sivasankae@gmail.com', testContact2[0].Email);
         System.assertEquals(3, CaseID.size());   
        System.assertEquals('Test Case 1', CaseID[0].Subject);  
        System.assertEquals('Test Case 2', CaseID[1].Subject);  
    }
}