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
        var currentTab = component.get("v.selTabId");
        if(currentTab == 'tab1'){
            component.set("v.selTabId" , 'tab2');
        }else if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab3');
        }
    },
    back : function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab1');
        } else if(currentTab == 'tab3'){
            component.set("v.selTabId" , 'tab2');
        }
    }
})