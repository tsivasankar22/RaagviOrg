trigger trigg on Account (before insert) {
     
 for(Account acco: Trigger.new)
 { 
 acco.NumberOfEmployees = 1;
 }
}