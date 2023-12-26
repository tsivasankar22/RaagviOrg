/*ClassName     :   SearchBar
* CreatededBy       :   Sivasankara
* Created on        :   30/09/2022
* Description       :   Create a one search box and when am searching a name in account object that reacord name should be displayed.
* Last Modified on  :   04-09-2022
* Last Modified by  :   Sivasankara   */


public inherited sharing class SearchBar 
{
    //to enable apex methods to be cached in global cache ,client or server access to apex control method
    @AuraEnabled(Cacheable = true)
    public static list<Account> getContactList(String strAccName) 
    {
        // name left side and right side checking
        strAccName = '%' + strAccName + '%';
    
        list<Account> lstAccs = [SELECT  Id, Name From Account WHERE  Name LIKE :strAccName];
        
        if(lstAccs.isEmpty()) 
        {
            // exactly no name is there in account object that time error showning no record found
            throw new AuraHandledException('No Record Found..');
        }
        return lstAccs; 
    }
}