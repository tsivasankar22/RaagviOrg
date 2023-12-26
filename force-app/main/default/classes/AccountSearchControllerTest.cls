@isTest
public class AccountSearchControllerTest 
{
	@isTest
    static void searchAccountByNameTest()
    {
        Account acc = new Account(Name='TestSiva');
        insert acc;
        Test.startTest();
        	List<Account> accList = AccountSearchController.searchAccountByName(acc.Name);
        Test.stopTest();
        System.assertEquals(1,accList.size());
    }
}