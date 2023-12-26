({
    doInit : function(component)
    {
        var action = component.get("c.content");
        action.setCallback(this, function(response)
                           {
                               component.set("v.ContentVersionId", response.getReturnValue());
                           });
        $A.enqueueAction(action);
    },
    next : function(component, event, helper) {
        var currentImage = 0;
        function goNext() {
            currentImage += 1;
        var currentTab = component.get("v.selTabId");
        if(currentTab == v.ContentVersionId){
            component.set("v.ContentVersionId" , currentImage);
        }else if(currentTab <= v.ContentVersionId){
            component.set("v.ContentVersionId" , currentImage);
        }
        }
    },
    back : function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        if(currentTab <= 'index'){
            component.set("v.selTabId" , 'ContentVersionId');
        }else if(currentTab == 'index'){
            component.set("v.selTabId" , 'ContentVersionId');
        }
    }
})