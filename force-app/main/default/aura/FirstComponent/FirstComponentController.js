({
    doSubmit : function(cmp, evt, hlpr) {
        var SampleSave = cmp.get("v.Sample");
        var action = cmp.get("c.FirstLightningObjectSaveMethod");
        action.setParams({ 
            "sampleSave": SampleSave
        });
        $A.enqueueAction(action)
    }
})