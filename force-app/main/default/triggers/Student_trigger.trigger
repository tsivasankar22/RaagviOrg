trigger Student_trigger on Student__c (before insert , before Update) 
{
    if(Trigger.isInsert)
    {
        StudentTriggerHandler.afterInsert(Trigger.new);  
    }
    else if(Trigger.isUpdate)
    {
        StudentTriggerHandler.afterUpdate(Trigger.old);
    }
    
}