public class FirstLightningObjectSave {
    @AuraEnabled
    public static String FirstLightningObjectSaveMethod(Layout__c sampleSave){
        insert sampleSave;
        return sampleSave.Name;
    }
    
    @AuraEnabled
    public static List<Layout__c> FirstLightningObjectShowMethod(){
        List<Layout__c> showFirst = [SELECT Message_Title__c,Message_Body__c,Name FROM Layout__c];
        return showFirst;
    }
}