({
	doInit: function(component, event, helper) {
        //here getting a fields and new chatting of  pre chat 
        var chatFields = component.find( "prechatAPI" ).getPrechatFields();
    },
    //onclick of stat chatting button and navigate to the chat  box
    startChatting: function(component, event, helper) {
        helper.navigateToChat(component,event,helper);
    },

})