public class dynamicCustomLableCtrl {
    @AuraEnabled
    public static string custoLabelItem(){
        List<String> custmValParm=new List<String>();
        String custmLbl =Label.Testing;
        String custmLblMsg=String.format(custmLbl,custmValParm);
        System.debug('CustomLabelValue' + custmLblMsg);
        return custmLblMsg;
        
    }

}