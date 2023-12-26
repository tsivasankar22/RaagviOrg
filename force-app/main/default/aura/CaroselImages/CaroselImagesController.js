({
    doInit : function(component) 
    {
        var action = component.get("c.ContentList");
        action.setCallback(this,function(response){
            component.set('v.imagelist',response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
});