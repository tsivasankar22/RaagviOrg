public without sharing class CustomNotificationFromApex {

    @AuraEnabled
    public static void notifyUsers(NotificationWrapper wrapp) {
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle(wrapp.title);
        notification.setBody(wrapp.body);

        // Set the notification type and target
        notification.setNotificationTypeId(wrapp.customNotificationType);
        notification.setTargetId(wrapp.targetId);
        
        // Actually send the notification
        try {
            notification.send(getUserIds());
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<CustomNotificationType> getNotificationList() {
        List<CustomNotificationType> notificationTypeList = new  List<CustomNotificationType>();
        notificationTypeList = [SELECT Id, CustomNotifTypeName, DeveloperName FROM CustomNotificationType ];
        return notificationTypeList;
    }

    public static set<String> getUserIds() {
        set<String> userids = new set<String>();
        for(User usr : [select id from User Where Profile.UserLicense.Name = 'Salesforce' and IsActive = true]){
            userids.add(usr.id);
        }
        return userids;
    }
}