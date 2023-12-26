public class OppProsseror implements Database.Batchable<sObject>, Database.Stateful{
    public Integer recordCount=0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT ID ,Name ,StageName FROM Opportunity]);
        
    }
    Public void execute(Database.BatchableContext bc,List<Opportunity> opps){
        for(Opportunity op:opps){
            op.StageName='Closed Won';
            
        }
        Update opps;
        recordCount=recordCount+opps.size();
        System.debug('count----'+recordCount);
        
    
            }   
    public Void finish(Database.BatchableContext bc){
        System.debug('Total records processed'+recordCount);
    }
}