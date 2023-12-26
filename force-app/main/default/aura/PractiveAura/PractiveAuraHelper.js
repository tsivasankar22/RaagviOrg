({
 getAccounts : function(component) {
  var action=component.get("c.getAllAccount");
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();                
                if(result.length>0){
                    component.set("v.AccountList",result);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteAcc:function(component,selectedAccount){
        var action=component.get("c.delAccount");
        action.setParams({
            lstAccountId:selectedAccount
        });
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                if(result!=''){
                    alert(result);
                } else{
                    this.getAccounts(component);
                    alert('Account deleted successfully');                    
                }
            } 
        });
        $A.enqueueAction(action);
    }
 })