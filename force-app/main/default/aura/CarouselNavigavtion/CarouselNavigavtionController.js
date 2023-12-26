({
    Next : function(component, event, helper) {
        var currentTab = component.get("v.TabId");
        if(currentTab == 'tab1'){
            component.set("v.TabId" , 'tab2');
        }else if(currentTab == 'tab2'){
            component.set("v.TabId" , 'tab3');
        }
    },
    Back: function(component, event, helper) {
        var currentTab = component.get("v.TabId");
        if(currentTab == 'tab2'){
            component.set("v.TabId" , 'tab1');
        } else if(currentTab == 'tab3'){
            component.set("v.TabId" , 'tab2');
        }
    }
})