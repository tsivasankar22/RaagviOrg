({
    searchAccounts: function(cmp, event, helper) {
        var accountName = cmp.get("v.accountNum");

        // Perform the search based on the account name
        var action = cmp.get("c.searchAccountByName");
        action.setParams({
            accountName: accountName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var searchResults = response.getReturnValue();
                cmp.set("v.searchResults", searchResults);
            }
        });
        $A.enqueueAction(action);
    },

        handleCheckboxChange: function(component, event, helper) {
          
            var selectedAccountIds = component.get("v.selectedAccountIds") || [];
            var accountName = event.getSource().get("v.label");
            var accountId = event.getSource().get("v.value");
            var isChecked = event.getSource().get("v.checked");
          
            if (isChecked) {
                selectedAccountIds.push({ id: accountId, name: accountName });
            } else {
                var index = selectedAccountIds.indexOf(accountId);
                if (index !== -1) {
                    selectedAccountIds.splice(index, 1);
                }
            }
             console.log('selectedAccountIds====='+selectedAccountIds);
            component.set("v.selectedAccountIds", selectedAccountIds);
        },
    
     publishAccounts: function(cmp, event, helper) {
        console.log('i am in publsh');
        var selectedAccountIds = cmp.get("v.selectedAccountIds");
        console.log('selectedAccountId========'+selectedAccountIds);         
        
        // Publish the selected account ID using LMS
        var message = {
            selectedAccountIds: selectedAccountIds,
           
            
        };
        //in the message channel tag value 
        var messageChannel = cmp.find("sampleMessageChannel");
        messageChannel.publish(message);
         console.log('messageChannel========'+messageChannel);
    }
})