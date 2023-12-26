import { LightningElement } from 'lwc';

export default class CustomAccordion extends LightningElement {
    renderedCallback(){
        this.template.querySelectorAll('button').forEach(element =>{
            element.addEventListener("click",evt =>{
                element.classList.toggle("active");
                let panel=element.nextElementSibling;
                if(panel.style.maxHeight){
                    panel.style.maxHeight=null;
                }else{
                    panel.style.maxHeight=panel.scrollHeight +'px';
                }
               
            })
        })
    }
}