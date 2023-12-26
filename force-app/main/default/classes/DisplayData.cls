public class DisplayData {
	public List<Contact> contactList;
    public Integer noOfRecords{get;set;}
    public Integer size{get;set;}
    public DisplayData(){
        contactList = new List<Contact>();
        size = 10;                              
    }
    public ApexPages.StandardSetController ssc{
        get{
            if(ssc==null){
                String s1='SELECT Id,Name,Phone,Email FROM Contact ORDER BY Name';
                ssc= new ApexPages.StandardSetController(Database.getQueryLocator(s1));
                ssc.setPageSize(size);
                noOfRecords=ssc.getResultSize();
            }
            return ssc;
        }
        set;
    }
    public List<Contact> getContacts(){
        return (List<Contact>)ssc.getRecords();
    }
}