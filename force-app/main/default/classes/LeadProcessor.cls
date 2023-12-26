global with sharing class LeadProcessor implements Database.Batchable<sObject> {

    global Integer count = 0;
    global Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator (
            'SELECT Id, Name, LeadSource FROM Lead'
        );
    }

    global void execute (Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> lList = new List<Lead>();
        for(Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            lList.add(l);
            count += 1;
        }
        update lList;
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('count===' + count);
    }
    
}