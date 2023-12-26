({
	
    doInit  : function(component, event, helper) {
		var action = component.get("c.getItems");
        action.setCallback(this, function(response){
            var state = response.getState();
           
            if (component.isValid() && state === "SUCCESS") {
           
               
                component.set("v.items", response.getReturnValue());
                 
            }
        });
        
        $A.enqueueAction(action);
	},
    
    createItem : function(component, event, helper){
        
        helper.validateFields (component,component.find("name"));
        helper.validateFields (component,component.find("Price"));
        helper.validateFields (component,component.find("Quantity"));
        if(component.get("v.er") === false)
        {     
            var Item = component.get("v.newItem");            
            helper.createItem (component,Item);             
                       
        }
	}    
})