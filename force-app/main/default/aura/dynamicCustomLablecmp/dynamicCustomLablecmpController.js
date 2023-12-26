({
	doInit:function(component,event,helper){  
       var action = component.get("c.custoLabelItem"); 
       
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();           
                component.set("v.customLablVal",result);  
            }  
        });  
        $A.enqueueAction(action);
    },
   
    
})