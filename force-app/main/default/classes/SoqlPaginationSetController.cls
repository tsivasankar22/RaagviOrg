public class SoqlPaginationSetController {
    
    public List<Contact> lstContact;
    Public Integer noOfRecords {get;set;}
    Public Integer size {get;set;}
    
    public SoqlPaginationSetController(){
        lstContact = new List<Contact>();
        size = 10;
    }
    
    public ApexPages.StandardSetController ssc{
        get{
        	if(ssc == null){
            	String queryResult = 'SELECT Id, Name, Email,Phone FROM Contact ORDER BY Name';
            	ssc = new ApexPages.StandardSetController(Database.getQueryLocator(queryResult));
            	ssc.setPageSize(size);
            	noOfRecords = ssc.getResultSize();
            }
            return ssc;
        }
        set;
    }
    
    public List<Contact> getContacts(){
        return (List<Contact>)ssc.getRecords();
    }
}