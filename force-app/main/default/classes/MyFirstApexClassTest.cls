@isTest
public class MyFirstApexClassTest 
{
	@isTest
    static void getAllEventsTest()
    {
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        Test.startTest();
        	List<Residential_Loan_Application__c> result = MyFirstApexClass.getAllEvents(con.Id);
        Test.stopTest();
        System.assertEquals(0, result.size());
    }
}