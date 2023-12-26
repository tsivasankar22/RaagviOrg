({
    newCaseAction : function(component, event, helper) {
        var homePageNewslabel = $A.get("$Label.HomePageNewsLabel");
        component.set('v.homePageNews', homePageNewslabel);
    }
})