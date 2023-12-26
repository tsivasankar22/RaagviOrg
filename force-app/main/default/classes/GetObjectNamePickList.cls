//here VisualEditor.DynamicPickList its a standard apex class provided by Salesforce
 //it is work in only app builder for selecting the dynamic  picklist values of meta data 
 global class GetObjectNamePickList extends VisualEditor.DynamicPickList{
   // this method contains when the picklist is initially loaded in the app builder it will have no pre-selected value
    //initially the value is null and you have to select the value in that  dynamic picklist 
    global override VisualEditor.DataRow getDefaultValue(){
        
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(null, '');
        return defaultValue;
    }
  //getValues() method is being used to retrieve a list of ObjectField__mdt records from the database,and hold these records as picklist options.
    global override VisualEditor.DynamicPickListRows getValues() {
        //creating the object and storing all MasterLabel in pickListRows
        VisualEditor.DynamicPickListRows  pickListRows = new VisualEditor.DynamicPickListRows();
        // here MasterLabel is the object names of an a meta data  here like contact , account,case like that 
        for(ObjectField__mdt objectField : [SELECT MasterLabel FROM ObjectField__mdt LIMIT 100]){
            pickListRows.addRow( new VisualEditor.DataRow(objectField.MasterLabel,objectField.MasterLabel));
        }
        return pickListRows;
    }
}