import { LightningElement ,api,wire} from 'lwc';
import getObjName from '@salesforce/apex/DynamicTableClass.getObjName';
import getAllFieldName from '@salesforce/apex/DynamicTableClass.getAllFieldName';
import sendData from '@salesforce/apex/DynamicTableClass.sendData';
export default class DynamicTableShubham extends LightningElement {
    objName;
    objData;
    filData;
    searchField;
    fieldName;
    seleObjNeme;
    searchTerm;
    showObjName=[];
    showFilName =[]
    fieldDataInPill=[];
    showTableComp=false;
    @api tableData;
    @wire(getObjName)
    getData({data,error}){
        if(data){
            console.log('data>>'+data);
            this.objName = data;
        }else{
            console.log('error>>'+error);
        }
    }
    onChangeObjName(event){
        this.filData = false
        this.objData = true;
        console.log('inside the on change');
        this.searchTerm = event.target.value;
        this.showObjName =[];
        console.log(' this.searchTerm ', this.searchTerm);
        console.log(' this.searchTerm ', event.target.value);
        this.objName.forEach(element => {
            if( element.includes(this.searchTerm)){
                console.log('inside the if');
                this.showObjName.push(element);
                console.log('this.showObjName>>',this.showObjName);
            }else{
               // this.showObjName.push();
            }
            
        });
    }
    selectObjName(event){
        this.objData = false
        console.log('namme>>',event.target.outerText);
        this.seleObjNeme = event.target.outerText;

        getAllFieldName({selectedObject:this.seleObjNeme}).then(result=>{
            console.log('result>>',result);
            this.fieldName = result;

        }).catch(error=>{
            console.log('error>>',error);
        })
        
    }
    onChangeFieldName(event){
        this.objData = false
        this.filData = true;
        this.searchField = event.target.value;
         this.showFilName =[];

        console.log(' this.searchTerm ', this.searchField);
        this.fieldName.forEach(ele => {
            console.log('inside the for each fiel');
            if( ele.includes(this.searchField)){
                console.log('inside the if');
                this.showFilName.push(ele);
                console.log('this.showObjName>>',this.showFilName);
            }else{
               // this.showObjName.push();
            }
            
        });
        
    }
    selectfilName(event){
        this.filData = false;
        console.log('namme>>',event.target.outerText);
        const filePill = event.target.outerText;
        console.log('filePill>>>',filePill);
        this.fieldDataInPill.push(filePill);// [...this.fieldDataInPill, ...filePill];
        console.log('this.fieldDataInPill>>>',this.fieldDataInPill);
        //const seleObjNeme = event.target.outerText;

    }
    handleRemoveFields(event){
        console.log('Remove was calling');
        //const index = event.target.dataset.index;
        const index = event.target.dataset.index?event.target.dataset.index: event.detail.label;
        console.log('index',index);
        const pillfields=this.fieldDataInPill;
        pillfields.splice(index,1);
        this.fieldDataInPill=[...pillfields];
        console.log('this.fieldDataInPill>>>',this.fieldDataInPill);
        // const ids=this.rID;
        // ids.splice(index,1);
        // this.rID=[...ids];
        // console.log(index,this.files);
    }
    createTable() {
        sendData({ objectName: this.seleObjNeme, fieldNames: this.fieldDataInPill })
            .then((data) => {
                this.tableData = data;
    
                const childComponent = this.template.querySelector('c-dynamic-table-child');
                if (childComponent) {
                    console.log('Calling callFromParent() in the child component');
                    childComponent.callFromParent();
                }
    
                this.showTableComp = true;
            })
            .catch((error) => {
                console.log('error>>>', error);
            });
    }
    
    
}