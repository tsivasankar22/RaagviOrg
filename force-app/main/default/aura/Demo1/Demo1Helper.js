({
    navigateToChat: function(component, event, helper) {
        //chat field is the id of all input fields
        var chatFieldsFromUI = component.find("chatField");
        //pre chat api is a chat fields and get a new chat like that
        var chatFieldsFromSetup = component.find("prechatAPI").getPrechatFields();
        var fields = [];
        var fieldsForCT = [];
        for(var key in chatFieldsFromUI){
            var ValueFromUI = chatFieldsFromUI[key];
            var NameFromUI = ValueFromUI.get("v.name");
            var labelFromUI = ValueFromUI.get("v.label");
            var DataFromUI = ValueFromUI.get("v.value");
            fieldsForCT.push(DataFromUI);
            for(var key in chatFieldsFromSetup){
                var ValueFromSetup = chatFieldsFromSetup[key];
                var NameFromSetup = ValueFromSetup.name;
                if(NameFromSetup == NameFromUI){
                    fields.push({label : labelFromUI ,value : DataFromUI,name : NameFromUI});   
                }
            }
        }
        if(component.find("prechatAPI").validateFields(fields).valid) {
            component.find("prechatAPI").startChat(fields);
        } else {
            console.warn("Prechat fields did not pass validation!");
        }
    },
})