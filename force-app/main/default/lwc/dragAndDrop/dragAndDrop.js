import { LightningElement, track, wire } from 'lwc';
import taskData from '@salesforce/apex/DragAndDropComponentHandler.getAllTask';
import updateTask from '@salesforce/apex/DragAndDropComponentHandler.updateTask';
import DataInsert from '@salesforce/apex/DragAndDropComponentHandler.DataInsert';
import fetchUsers from '@salesforce/apex/DragAndDropComponentHandler.fetchUsers';
export default class DragAndDropComponent extends LightningElement {
    @track taskNewList = [];
    @track taskInProgressList = [];
    @track taskCompletedList = [];
    @track taskPeerReviewList=[];
    @track taskQAtestingList=[];
    @track dropTaskId;
    @track TaskpeerReview=true;
    @track TaskQaTesting=true;
    @track taskDone=true;
    @track Takinprogress=true;
    @track taskStatus;
    @track customFormModal = false; 
    @track l_All_Types;
    @track typeOptions;
    @track newlist={ 
        };
        value = 'To-Do';

        get options() {
            return [
                { label: 'To-Do', value: 'To - Do' },
                { label: 'In Progress', value: 'In Progress' },
                { label: 'Peer Review', value: 'Peer Review' },
                { label: 'QA Testing', value: 'QA Testing' },
                { label: 'Done', value: 'Done' },
            ];
        }
        @wire(fetchUsers, {})
        wireData({error, data}) {
            if (data) {
                try {
                    console.log('user data===========',data);
                    this.l_All_Types = data; 
                    let options = [];
                      
                    for (var key in data) {
                        // Here key will have index of list of records starting from 0,1,2,....
                        options.push({label: data[key].Name, value: data[key].Id });
                    }
                    this.typeOptions = options;
                } catch (error) {
                    console.error('check error here', error);
                }
            } else if (error) {
                console.error('check error here', error);
            }
        }
    customShowModalPopup() {            
        this.customFormModal = true;
    }
    customHideModalPopup() {     
        this.customFormModal = false;
    }
    connectedCallback(){
        this.getTaskData();
    }
    handelChange(event){
        if(event.target.label=='CTC Number')
    {
      this.newlist.CTC_Number__c = event.target.value;
      window.console.log('CTC_Number__c ==> '+this.newlist.CTC_Number__c);
    }
    if(event.target.label=='Description')
    {
      this.newlist.Description__c = event.target.value;
      window.console.log('Description__c ==> '+this.newlist.Description__c);
    }
    
    if(event.target.label=='Status')
    {
     console.log('inside of an a if Status')
      this.newlist.Status = event.target.value;
      window.console.log('Status ==> '+this.newlist.Status);
    }
    if(event.target.label=='Assigned To')
    {
     console.log('i am in assigned to')
      this.newlist.OwnerId = event.target.value;
      window.console.log('Assigned To ==>' +this.newlist.OwnerId);
    }

       
    }
    handelOnClick()
    {
        DataInsert({newlist : this.newlist})
        
        .then(result=>{
            
         this.newlist = {
         };
         console.log('check');
         this.customFormModal = false;
         setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       }, 1000); 
       console.log('refresh==================')
      })  
    }     
    getTaskData(){
        taskData()
        .then(result =>{
            let taskNewData = [];
            let taskInProgressData = [];
            let taskCompletedData = [];
            let taskPeerReviewData=[];
            let taskQAtestingData=[];
            for(let i = 0; i < result.length; i++){
                let task = new Object();
                task.Id = result[i].Id;
                task.Subject = result[i].Subject;
                task.Status = result[i].Status;
                task.Description = result[i].Description;
                task.WhoId = '/'+result[i].WhoId;
                task.WhatId = '/'+result[i].WhatId;
                task.CTC_Number__c=result[i].CTC_Number__c;
                task.Description__c=result[i].Description__c;
                task.OwnerId=result[i].OwnerId;
                task.OwnerName=result[i].Owner.Name;
                console.log('result[i].OwnerId===============',result[i].OwnerId)
                console.log('result[i].Owner.Name===============',result[i].Owner.Name)
                if(result[i].WhoId !== undefined){
                    task.ContactName = result[i].Who.Name;
                }
                if(result[i].WhatId !== undefined){
                    task.AccountName = result[i].What.Name;
                 }
                if(task.Status === 'To - Do'){
                    taskNewData.push(task);
                    console.log('taskNewData------------------------');
                }
                 else if(task.Status !== 'To - Do' && task.Status !== 'Done' && task.Status !== 'In Progress' && task.Status !=='QA Testing' ){                
                    taskPeerReviewData.push(task);
                    console.log('taskPeerReviewData------------------------');
                }
                else if(task.Status !== 'To - Do' && task.Status !== 'Done' && task.Status !== 'In Progress' && task.Status !== 'Peer Review' ){               
                       taskQAtestingData.push(task);
                       console.log('QaTesting------------------------');
                }              
                else if(task.Status !== 'To - Do' && task.Status !== 'Done' && task.Status !=='QA Testing' && task.Status !== 'Peer Review' ){                 
                    taskInProgressData.push(task);
                    console.log('taskInProgressData------------------------');
                }else if(task.Status !== 'To - Do' && task.Status !=='QA Testing' && task.Status !== 'Peer Review' && task.Status !== 'In Progress' ){
                    taskCompletedData.push(task);
                }
            }
             this.taskNewList = taskNewData;
             this.taskInProgressList = taskInProgressData;
             this.taskCompletedList = taskCompletedData;
             this.taskPeerReviewList=taskPeerReviewData;
             this.taskQAtestingList=taskQAtestingData;
        }).catch(error => {
           // window.alert('$$$Test1:'+ error);
        })
    }
     // drag start here .The user starts to drag an element
    taskDragStart(event){
        const taskId = event.target.id.substr(0,18);
        this.taskStatus = event.target.dataset.value;
        this.dropTaskId = taskId;
        let draggableElement = this.template.querySelector('[data-id="' + taskId + '"]');
        draggableElement.classList.add('drag');
        console.log('----------------->taskstatus',this.taskStatus);
        this.handleTaskDrag(taskId,taskStatus);
    }
       //The user has finished dragging an element
    taskDragEnd(event){
        //drag stop here
        const taskId = event.target.id.substr(0,18);
        let draggableElement = this.template.querySelector('[data-id="' + taskId + '"]');
        draggableElement.classList.remove('drag');
    }
    //drop the element ...A dragged element is dropped on the target
    handleDrop(event){
        this.cancel(event);
        const columnUsed = event.target.id;
        console.log('column used iddddddddddd=========',event.target.id)
        console.log('columnUsed========>',columnUsed);   
        console.log('==========================>siva status',this.taskStatus);

        for(let taskNewStatus=0;taskNewStatus<=0;taskNewStatus++){
            if((this.taskStatus === 'To-Do')  && (columnUsed.includes('InProgress'))){
                console.log('======>1',this.taskStatus);
                taskNewStatus = 'In Progress';
                console.log('in progressssssss==========',taskNewStatus);
            }
            else if((this.taskStatus === 'PeerReview') && (columnUsed.includes('QaTesting'))){
                console.log('======>2',this.taskStatus);
                taskNewStatus = 'QA Testing';
                console.log('To - Do======',taskNewStatus)
               
            }
            else if((this.taskStatus === 'QaTesting') && (columnUsed.includes('done'))){    

                console.log('======>3',this.taskStatus);
                taskNewStatus = 'Done';
                console.log('complete-=============',taskNewStatus)             
            }
            else if((this.taskStatus ==='InProgress') && (columnUsed.includes('PeerReview'))){
                console.log('======>4',this.taskStatus);
                taskNewStatus = 'Peer Review';
                console.log('peer review-=============',taskNewStatus)              
            }
            else if((this.taskStatus === 'done') && (columnUsed.includes('QaTesting'))){
           
                console.log('======>5',this.taskStatus);
                taskNewStatus = 'QA Testing';
                console.log('QA Testing-=============',taskNewStatus)             
            }
            else if((this.taskStatus ==='InProgress') && (columnUsed.includes('To-Do'))){
               
                console.log('======>6',this.taskStatus);
                taskNewStatus = 'To - Do';
                console.log('newTask=============',taskNewStatus)              
            }
            else if((this.taskStatus === 'PeerReview') && (columnUsed.includes('InProgress'))){

                console.log('======>7',this.taskStatus);
                taskNewStatus = 'In Progress';
                console.log('InProgress======',taskNewStatus)
               
            }
            else if((this.taskStatus === 'QaTesting') && (columnUsed.includes('PeerReview'))){    

                console.log('======>8',this.taskStatus);
                taskNewStatus = 'Peer Review';
                console.log('PeerReview-=============',taskNewStatus)             
            }
            else if(this.taskStatus==='To-Do' && taskNewStatus == 0)
            {
                taskNewStatus='To - Do'
            }
            else if(this.taskStatus==='InProgress' && taskNewStatus == 0)
            {
                taskNewStatus='In Progress'
            }
            else if(this.taskStatus==='PeerReview' && taskNewStatus == 0)
            {
                taskNewStatus='Peer Review'
            }
            else if(this.taskStatus==='QaTesting' && taskNewStatus == 0)
            {
                taskNewStatus='QA Testing'
            }
            else if(this.taskStatus==='done' && taskNewStatus == 0)
            {
                taskNewStatus='Done'
            }
           // window.alert(columnUsed + '=============&===== '+ taskNewStatus + '=====task status==='+this.taskStatus);
            this.updateTaskStatus(this.dropTaskId, taskNewStatus);
            let draggableElement = this.template.querySelector('[data-role="drop-target"]');
            draggableElement.classList.remove('over');
      }
    }
        //after drag is over clear the element..A dragged element enters the drop target
     handleDragEnter(event){
        this.cancel(event);
    }
      //deagged element add...A dragged element is over the drop target
    handleDragOver(event){
        this.cancel(event);
        let draggableElement = this.template.querySelector('[data-role="drop-target"]');
        draggableElement.classList.add('over');
    }
        //deagged element remove to ...A dragged element leaves the drop target
    handleDragLeave(event){
        this.cancel(event);
        let draggableElement = this.template.querySelector('[data-role="drop-target"]');
        draggableElement.classList.remove('over');
    }
    handleTaskDrag(taskId,taskStatus){
        console.log('handle Task Drag======== '+ taskId);
        console.log('=============>task Status',taskStatus);
    }
    updateTaskStatus(taskId, taskNewStatus){
        updateTask({newTaskId: taskId, newStatus: taskNewStatus}).then(result =>{
            this.getTaskData();
        }).catch(error =>{
            console.log('update=================='+ JSON.stringify(error));
        })
    }
    cancel(event) {
        if (event.stopPropagation) event.stopPropagation();
        if (event.preventDefault) event.preventDefault();
        return false;
    };
}