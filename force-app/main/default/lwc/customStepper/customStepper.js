import { LightningElement, wire,track} from 'lwc';
import getFiles from '@salesforce/apex/WorkspaceDocumentWrapper.getFiles';
export default class customStepper extends LightningElement {
    @track workspaceDocuments;
    @track JavaQuestionsList=false;
    @track salesforceQuestions=false;
    @track data =[];
    @track questions = [
        {
            question: "1.What is Salesforce?   ",
            options: ["An RCM system", "A Chrome extension","A CRM system",  "An app on your laptop"],
            answer: "A CRM system"
        },
        {
            question: "2.What type of objects are included with Salesforce?",
            options: ["Custom Objects","Standard Objects","Basic Objects", "Functional Objects"],
            answer: "Standard Objects"
        },
        {
            question: "3.How many reports and dashboards can you subscribe to in total?",
            options: ["Five", "Four", "Three", "Two"],
            answer: "Five"
        }
    ];
    @track javaQuestions=[
        {
            question:"1.Which of these are selection statements in Java?",
            options:["Continue()","break()","for()","if()"],
            answer: "if()"
        },
        {
            question: "2.Identify the modifier which cannot be used for constructor",
            options: ["Private","Static","Public", "protected"],
            answer: "Static"
        },
        {
            question: "3.What is the size of float and double in java?",
            options: ["32 And 64", "64 And 64", "32 And 32", "64 And 32"],
            answer: "32 And 64"
        },

    ]
    activeSectionName = 'Salesforce';
    @track customFormModal = false; 
    customHideModalPopup() {     
        this.customFormModal = false;
    }
    @track selectId;
    @track targetname
    customShowModalPopup(event) { 
        this.customFormModal = true;
        this.targetname=event.target.value;
        this.selectId=event.target.dataset.id;
        console.log('targetname------------',this.targetname);
        console.log('data--------',JSON.stringify(this.data.title));
        console.log('value------------',this.selectId); 
        if( this.targetname == 'Salesforce')  {
            console.log('i am in salesforceQuestions');
           this.salesforceQuestions=true; 
           this.JavaQuestionsList=false;
        } 
        else if(this.targetname == 'Java') {
            console.log('i am in java questions');
            this.salesforceQuestions=false;
            this.JavaQuestionsList=true;
        }      
        // let titlesByWorkspace = {};

        //     this.data.forEach((workspace) => {
        //     const workspaceName = workspace.workspaceName;
        //     const documents = workspace.documents;
            
        //     titlesByWorkspace[workspaceName] = [];
            
        //     documents.forEach((document) => {
        //         const title = document.title;
        //         console.log('titleeeeee===============',title);
        //         const id = document.id;
                
        //         titlesByWorkspace[workspaceName].push({id, title});
        //     });
        //     });

        //     console.log('title---------------',titlesByWorkspace);

      
    }
    handleSectionToggle(event){
        this.activeSectionName = event.detail.openSections;
        console.log('selection -----------',JSON.stringify(this.activeSectionName));
    }

    @wire(getFiles)
    wiredGetFiles({data , error}) {
        if (data) {
            console.log("+++++data++++", JSON.stringify(data));
            this.workspaceDocuments = data;
            this.data=this.workspaceDocuments;
            console.log('workspaceDocuments: ', JSON.stringify(this.workspaceDocuments));
        } else if (error) {
            console.error(error);
        }
    }
      //user select the questions and ans 
      @track selectedAnswers = {};
      handleChange(event) {
        let question = event.target.name;
        let answer = event.target.value;
        this.selectedAnswers[question] = answer;
    }
    handelOnClick() {
        console.log('i am in a handle on click');
        let correctAnswers = 0;
        for (let i = 0; i < this.questions.length; i++) {
            let question = this.questions[i];
            if (this.selectedAnswers[question.question] === question.answer) {
                correctAnswers++;
            }
        }

        alert("You got " + correctAnswers + " out of " + this.questions.length + " questions correct!");
        console.log('correct answers',correctAnswers);
        if(correctAnswers <= 1){
            console.log('i am in a log of wrong anserws ');
            const myDemoEvent = new CustomEvent('helpevent');
            this.dispatchEvent(myDemoEvent);
           
        }

        else if (correctAnswers > 1) {
            console.log('i am in a inside if ');
            let url = 'https://raagvitech77-dev-ed.lightning.force.com/'+'/sfc/servlet.shepherd/document/download/'+this.selectId;
            console.log('url--------', url);
            //This code will create a hidden a element with the href attribute set to the URL of the file to download
            let link = document.createElement('a');
            link.setAttribute('href', url);
            link.setAttribute('download', '');
            link.style.display = 'none';
            //add and remove like one value is there after click remove 
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            const myDemoEvent = new CustomEvent('democlickevent');
            this.dispatchEvent(myDemoEvent);
        }
       
        this.customFormModal = false;
    }
}