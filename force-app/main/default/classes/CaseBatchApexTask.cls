global class CaseBatchApexTask implements Database.Batchable<sObject> ,Database.stateful 
{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       // String query= 'SELECT Origin,Status,Priority from Case where Origin=Email AND Priority=High AND Status=Working';
        return Database.getQueryLocator([SELECT Origin,Status,Priority from Case ]);
    }
    global void execute(Database.BatchableContext bc,List<Case> scope)
    {
        List<Task> tasklist= new List<Task>();
        for(Case caselist : Scope)
        {
            if(caselist.Origin=='Email' && caselist.Priority=='High' && caselist.Status=='Working')
            {
                
                Task tasklist1=new Task(Subject='Email',Priority='High',Status='Working', WhatId=caselist.Id );
                tasklist.add(tasklist1);
            }
            System.debug(tasklist);
        }
        if(tasklist.size()>0){
            insert tasklist;
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}