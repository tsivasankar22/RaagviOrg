({
	submitStudentInfo : function(component, event, helper) {
        console.log('i am in starting stage of submit');
        embedded_svc.settings.extraPrechatInfo = [{
            "entityFieldMaps": [{
              "doCreate": true,
              "doFind": true,
              "fieldName": "LastName",
              "isExactMatch": true,
              "label": "Last Name"
            }, {
              "doCreate": true,
              "doFind": true,
              "fieldName": "FirstName",
              "isExactMatch": true,
              "label": "First Name"
            }, {
              "doCreate": true,
              "doFind": true,
              "fieldName": "Email",
              "isExactMatch": true,
              "label": "Email"
            }],
            "entityName": "Contact",
            "saveToTranscript": "Contact"
          }];
        
        // var isValidate = true;   
        // console.log('isvalidate===========',isValidate = true);   
        // var firstName = component.find('fName');
        // console.log('firstName============',firstName);     
        // var firstNameVal = component.find('fName').get('v.value');  
        // console.log('firstNameVal============',firstNameVal);      
        // if($A.util.isUndefinedOrNull(firstNameVal) || $A.util.isUndefined(firstNameVal) || $A.util.isEmpty(firstNameVal)){
        //     firstName.set("v.errors",[{message:'First Name is required'}]);
        //     isValidate = false;
        // }else{
        //     firstName.set("v.errors",null);
        // }        
        
        // if(isValidate){
        //      var action = component.get('c.getCase');
        //      var postData =  component.get('v.CaseInfoAc');  
        //      console.log('postData============',JSON.stringify(postData));     
        //      action.setParams({"insertStudent": postData});
        //      console.log('postData============111111111111',JSON.stringify(postData));
            
        //     action.setCallback(this, function(response) {            
        //     var state = response.getState();  
            // if (state === "SUCCESS") {                
            //     var stringItems = response.getReturnValue();
            //     component.set("v.CaseItrt",stringItems);
            //     component.set("v.CaseInfoAc", null);       
            //     console.log('stringItems============',stringItems);
            //     //Show the success toast message
            //     var toastEvent = $A.get("e.force:showToast");
            //     toastEvent.setParams({
            //         "title":"Success",
            //         "type":"success",
            //         "message":"Form submitted successfully.",                        
            //     });
            //     toastEvent.fire();            
            
            // }
                
    //     }); 
        
    //     $A.enqueueAction(action);
            
    //     }
        
     },
    
})