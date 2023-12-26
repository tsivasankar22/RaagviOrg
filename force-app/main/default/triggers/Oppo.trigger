trigger Oppo on Opportunity (before update) {
 for(Opportunity oldOpp: Trigger.old)
 { 
 for(Opportunity newOpp: Trigger.new)
 {
 if(oldOpp.id == newOpp.id && oldOpp.Amount != newOpp.Amount)
 newOpp.Amount.addError('Amount cannot be changed');
 }
}
}