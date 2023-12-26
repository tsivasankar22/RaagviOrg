trigger EmailAlertStudent on Student__c (After insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            StudentEmailAlert.SendEmailNotification(Trigger.new);
        }
    }

}