public class NotificationWrapper {
    @AuraEnabled public string title{ get; set; }
    @AuraEnabled public string body{ get; set; }
    @AuraEnabled public string customNotificationType{ get; set; }
    @AuraEnabled public string targetId{ get; set; }
}