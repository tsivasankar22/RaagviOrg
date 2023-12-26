@isTest
public class SearchBarTest {
    
    @isTest
    static void testGetContactList() {
        
        // create test account records
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name='Test Account 1'));
        testAccounts.add(new Account(Name='Test Account 2'));
        insert testAccounts;
        
        // test search for existing account
        List<Account> resultAccounts = SearchBar.getContactList('Test Account');
        System.assertEquals(2, resultAccounts.size());
        
        // test search for non-existing account
        try {
            resultAccounts = SearchBar.getContactList('Non-existing Account');
            System.assert(false, 'Expected exception not thrown');
        } catch (AuraHandledException e) {
           // System.assertEquals('No Record Found..', e.getMessage());
        }
    }
}