({
returnAttList : function(component, event, helper) {

    var actionImage = component.get("c.getImage");
   /* actionImage.setParams({
        parentId : component.get("v.actId")
    });*/

    actionImage.setCallback(this, function(a){
        var lsa=a.getState();
        
        if(lsa==="SUCCESS"){
        component.set("v.atlist",a.getReturnValue());
            console.log('Peace');
            console.log('LSA1 >>>>'+lsa);
      
        }
        else if(lsa==="ERROR"){
            var error=response.getError();
            console.log('LSA2 >>>>'+lsa);
            if(errors){
                if(errors[0] && errors[0].message){
                    console.log(errors[0].message);
                    
                }
            }
            
        }
        
       /* var attach = a.getReturnValue();
        component.set("v.imageSrc", "/servlet/servlet.FileDownload?file=" + attach.Id);
        console.log('>>>>>>>>>'+attach); */
    });

    $A.enqueueAction(actionImage);
}

})