trigger ClosedOpportunityTrigger on Opportunity (after insert,after update)
{
    List<task> task1 = new List<task>();
    for(Opportunity opp : Trigger.new )
    {
        if(opp.StageName == 'Closed Won')
        {
            
        
            task1.add(new Task(Subject='Follow Up Test Task',WhatId=opp.Id));
        }
        
    }
    if(task1.size()>0)
    {
        insert task1;
    }
}