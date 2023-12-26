import { LightningElement } from 'lwc';
export default class UpcomingPosts extends LightningElement {
    header="Jira is a project management tool that helps teams plan, prioritize, and track issues"
    
    drag(event){
        console.log('target id : ',event.target.id);
        //method retrive the id data transfer
        event.dataTransfer.setData("divId", event.target.id);
        console.log('drag==============')
    }
    allowDrop(event){
        // to stop the normal action of an element
        event.preventDefault();
        console.log('allow drop')
    }
    drop(event){
        // event.dataTransfer.getData("divId") method retrieves drag data as a string for the specified type.
        var divId = event.dataTransfer.getData("divId");
        console.log('divId=========='+divId);
        //To access elements rendered by a component
        var draggedElement = this.template.querySelector('#' +divId);
        console.log('draggedElement============'+draggedElement);
        //add the box in perticular drag element
        draggedElement.classList.add('completed');

        event.target.appendChild(draggedElement);
        console.log('DAS'+  event.target.appendChild(draggedElement));
        console.log('drop==========s')
        Event.target.appendChild(draggedElement);
    }
    drop1(event){
         // event.dataTransfer.getData("divId") method retrieves drag data as a string for the specified type.
        var divId = event.dataTransfer.getData("divId");
        console.log('Div Id========='+divId);
         //To access elements rendered by a component
        var draggedElement = this.template.querySelector('#' +divId);
        console.log('draggedElement==============='+draggedElement);
        //add the box in perticular drag element
        draggedElement.classList.add('completed');
        event.target.appendChild(draggedElement);
        console.log('drop111111111==========s')
        console.log('DAS'+  event.target.appendChild(draggedElement));
        Event.target.appendChild(draggedElement);      
    }  
}