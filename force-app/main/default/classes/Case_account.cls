public class Case_account {
    public static void relatedContacts(){
        List<Account> acc = [Select Id From Account];
        List<Case> cas = new List<Case>();
        for(Account account: acc)
        {
            Case c = new Case();
            c.Origin ='Phone';
            c.Reason='Performance';
            c.AccountId=account.Id;
            cas.add(c);
        }
        Insert cas;     
        System.debug('cas'+cas);
    }
    
}