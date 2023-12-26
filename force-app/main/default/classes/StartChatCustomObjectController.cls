public class StartChatCustomObjectController {
   /*  @AuraEnabled
    public static void AddressDisplay(Case addresslist) {
        upsert addresslist;
    }
*/
    @AuraEnabled
     public static List<Case> getCase(Case insertStudent){
        insert insertStudent;
        
        return [SELECT Id, ContactPhone, ContactEmail, SuppliedName ,Comments FROM Case];
    }

}