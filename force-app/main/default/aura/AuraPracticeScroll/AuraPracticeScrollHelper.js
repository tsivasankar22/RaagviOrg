({
     shiftDiv: function(component, event, helper,lWidth) {
            var changeposition=component.get("v.intervalId");
            var myimage = document.getElementById('tofloat');     
            if(changeposition <lWidth){
           
              myimage.style.left=changeposition+'px';
              myimage.style.background="radial-gradient(green,blue)";
              changeposition=changeposition+5;
              component.set("v.intervalId",changeposition);
         }

         else{
                   component.set("v.intervalId",0);
                   myimage.style.left="0px";
                  changeposition=component.get("v.intervalId");
         }

     }
})