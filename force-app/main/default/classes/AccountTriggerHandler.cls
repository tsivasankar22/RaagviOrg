public class AccountTriggerHandler 
{
    public static void beforeInsert (List <Account>newList)
    {
       for(Account acc : newList)
           acc.Description = 'test Description';
    }
}