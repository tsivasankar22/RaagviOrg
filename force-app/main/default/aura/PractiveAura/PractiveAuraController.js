({
    doInit : function(component, event, helper) {
        helper.getAccounts(component);
    },
    
    getSelectedAccount : function(component, event,helper) { 
        var selectedId='';
        //when using <ui:inputCheckbox> instead html checkbox
        //selectedId=event.getSource().get("v.text");                
        selectedId = event.target.getAttribute('id');
        if(document.getElementById(selectedId).checked && component.get("v.SelectedAccount").indexOf(selectedId) < 0)
            component.get('v.SelectedAccount').push(selectedId);
        else{
            var index = component.get("v.SelectedAccount").indexOf(selectedId);
            if (index > -1) {
                component.get("v.SelectedAccount").splice(index, 1); 
            }
        }
    },
      deleteAccount:function(component,event,helper){
        var selectedAccount=component.get("v.SelectedAccount");
        if(selectedAccount.length>0){
            helper.deleteAcc(component,selectedAccount);
        }
        else{
            alert('please select account to delete.')
        }
    },
 })