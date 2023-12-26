trigger account_trigger on Account (before insert) 
{
    if(Trigger.isInsert)
    {
    AccountTriggerHandler.beforeInsert(Trigger.new); 
    }
}