({
	myAction : function(component, event, helper) {
		var action = component.get('c.FirstLightningObjectShowMethod');
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.show', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})