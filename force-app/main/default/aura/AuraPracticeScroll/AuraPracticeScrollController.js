({
    doInit : function(component, event, helper) {
       var lWidth = window.screen.width ;

       window.setInterval($A.getCallback(function() { 
                helper.shiftDiv(component, event, helper,lWidth);
            } ), 100);
    },          
})