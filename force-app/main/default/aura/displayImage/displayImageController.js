({
     myAction : function(component, event, helper) {
          
        var oppt = component.get("c.ContentVersionId");
        oppt.setParams({
           
        });
        oppt.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                  var storeResponse = response.getReturnValue();            
                var count = 0;
                var i = 0;
                if (storeResponse == null) {
                    
                } else {
                    for (i = 0; i < storeResponse.length; i++) {
                        if (storeResponse[i].order < 0)
                            count++;
                    }                   
                    
                    component.set("v.ContentVersionId", storeResponse);
                                  
            }
            }
        });
        $A.enqueueAction(oppt);
          if(speed<500){
            alert("Min Interval 500 Millisecond");
        }else{
         /*   $('.carousel').carousel({
                interval: speed
            });
            $('.carousel').carousel({
                interval: true
            });  */
        }
    },
     Previous : function(component, event, helper) {
        "{('ContentVersionId')}".carousel('Previous'); 
    },
    Next : function(component, event, helper) {
        "{('ContentVersionId')}".carousel('next'); 
        "{('ContentVersionId')}".carousel(200);
        
    },

})