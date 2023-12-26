public class StudentTriggerHandler
{
    public static void afterInsert(List<Student__c> newList)
    {
        try
        {
            for(Student__c s:newList)
            {
                s.Temaparary_Address__c=s.Permanent_Address__c;
            }
        }
        catch(exception e)
        {
            System.debug('an exception occured ' +e);
            
        }
        
    }
    public static void afterUpdate(List<Student__c> old)
    {
        try
        {
            for(Student__c s:old)
            {
                s.Permanent_Address__c=s.Temaparary_Address__c;
            }
        }
        catch(exception e)
        {
            System.debug('an exception occured ' +e);
            
        }
        
    }
   
    
}