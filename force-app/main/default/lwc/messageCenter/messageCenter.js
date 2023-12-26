import { LightningElement,wire,track } from 'lwc';
//import { fetch } from 'lightning/platformRequest';
import getChatterPosts from '@salesforce/apex/chatterMessageCenter.getChatterPosts';
import CONTACT_ICON from '@salesforce/resourceUrl/contactIcon';
export default class MessageCenter extends LightningElement {
    chatterPosts = [];
    @track abc;
    hoursTime=[];
    @track orgData =[];
    @track likeStateSize01 = false; 
    icon = CONTACT_ICON;
    @track numItemsToShow = 5;
    horizontalAlign = 'tab';
    connectedCallback() {
        this.loadChatterPosts();
    }
    
      loadChatterPosts() {
        getChatterPosts()
            .then(result => {
              //  console.log('result>>>>'+result);

            //     //this.orgData = result;
                result.forEach(element => {
                   console.log('date>>'+element.CreatedDate);
                    console.log('::::::::::::::::',JSON.stringify(element),':::::::::::::::::::::::::::::::::::');
                    //////////////////Feed Item last modified date ....////////////////

                    var lastModiedDatefronmData = new Date(element.post.LastEditDate);
                    console.log('comentssssssssss>>>'+element.comments.Id);
                    var timeoflastModiedDatefronmData = lastModiedDatefronmData.getTime();
                    console.log('myDate>>>>>',timeoflastModiedDatefronmData);

                    var systemDate = new Date();
                    var timeofsystemDate = systemDate.getTime();
                  //  console.log('current time',systemDate);

                    var resultDate = timeofsystemDate-timeoflastModiedDatefronmData;
                   // console.log('r>>>',resultDate);

                    var convertingHours =Math.round(resultDate/(1000*60*60));
                  //  console.log('last time>>',convertingHours);

                    if(convertingHours){
                      //  console.log('inside convertingHours' ,convertingHours);
                        if(convertingHours>=48){
                            if(convertingHours/24 >2){
                                const dateObj = new Date(element.post.LastEditDate);
                                const outputDate = `${dateObj.toLocaleString("default", { month: "long" })} ${dateObj.getDate()} ${dateObj.getFullYear()}`;
                                var pair = {...element,...{totalHours:outputDate}};
                            }
                           
                        }
                        else if(convertingHours<48 && convertingHours>=24 ){
                            var myDate = new Date(element.post.LastEditDate);
                            const dateObj = new Date(myDate);
                            const finalDate = dateObj.toLocaleTimeString();
                          //  console.log( 'finale date >>'+finalDate);
                            var pair = {...element,...{totalHours:'Yesterday At '+finalDate}};
                           
                        }
                        else{
                             var pair = {...element,...{totalHours:convertingHours+' Hrs Ago'}};
                        }
                        this.orgData.push(pair);
                    }

                  /////////////comment Last modified date /////////////// 
             //  console.log('Created Date',element.comments.CreatedDate);
               element.comments.forEach(ele => {
                  //  console.log('Created Date',ele.CreatedDate);
                    
                    
                    var lastModiedDatefronmData = new Date(ele.CreatedDate);
                    var timeoflastModiedDatefronmData = lastModiedDatefronmData.getTime();
                    console.log('myDate>>>>>',timeoflastModiedDatefronmData);

                    var systemDate = new Date();
                    var timeofsystemDate = systemDate.getTime();
                    console.log('current time',systemDate);

                    var resultDate = timeofsystemDate-timeoflastModiedDatefronmData;
                   console.log('r>>>',resultDate);

                    var convertingHours =Math.round(resultDate/(1000*60*60));
                    console.log('last time>>',convertingHours);



                    if(convertingHours){
                        console.log('inside convertingHours' ,convertingHours);
                        if (convertingHours >= 48) {
                            if (convertingHours / 24 > 2) {
                                const dateObj = new Date(ele.CreatedDate);
                                const outputDate = `${dateObj.toLocaleString("default", { month: "long" })} ${dateObj.getDate()} ${dateObj.getFullYear()}`;
                                ele.totalHourscomment = outputDate;
                        
                                // Get a list of all the elements in the template that display the totalHourscomment value
                                const totalHourscommentEls = this.template.querySelectorAll('.totalHourscomment');
                        
                                // Loop through the list of elements and update the text content of each element
                                totalHourscommentEls.forEach((totalHourscommentEl) => {
                                    totalHourscommentEl.textContent = outputDate;
                                });
                        
                                console.log('inside the first if>>', ele.totalHourscomment);
                            }
                        }
                        
                        
                        else if(convertingHours<48 && convertingHours>=24 ){
                            var myDate = new Date(ele.CreatedDate);
                            const dateObj = new Date(myDate);
                            const finalDate = dateObj.toLocaleTimeString();
                            console.log( 'finale date >>'+finalDate);
                            //var pair = {...ele,...{totalHourscomment:'Yesterday At '+finalDate}};
                            ele.totalHourscomment = finalDate;
                           
                        }
                        else{
                             var pair = {...ele,...{totalHourscomment:convertingHours+' Hrs Ago'}};
                             ele.totalHourscomment = convertingHours+' Hrs Ago';
                        }
                    //     this.orgData.push(pair);
                     //  console.log(' this.orgData.comments:::::::::::::::::::', JSON.stringify(this.orgData));
                    }
                    

               });
                    
            });
                   
                
              //  console.log('orgData>>>'+JSON.stringify(this.orgData[0]));
          
                this.chatterPosts = this.orgData.slice(0, this.numItemsToShow);
               // console.log('this.chatterPosts>>'+JSON.stringify( this.chatterPosts));
               // console.log('size>>'+this.chatterPosts.length);
            })
            .catch(error => {
                console.error(error);
            });
    }
    handleViewMore() {
        this.numItemsToShow += 5;
         this.chatterPosts = this.orgData.slice(0, this.numItemsToShow);
       //  console.log(this.chatterPosts)
        //this.loadChatterPosts();
    }
//    handleLikeButtonSizeClick(event) {
//         const buttonNumber = event.target.dataset.buttonNumber;

//         this[`likeStateSize${buttonNumber}`] =
//             !this[`likeStateSize${buttonNumber}`];
//     }

// renderedCallback() {
//     const button1 = this.template.querySelector('.my-button-1');
//     if (button1) {
//         button1.addEventListener('click', this.handleButton1Click.bind(this));
//     }

//     const button2 = this.template.querySelector('.my-button-2');
//     if (button2) {
//         button2.addEventListener('click', this.handleButton2Click.bind(this));
//     }
// }

// handleButton1Click(event) {
//     const buttonNumber = event.target.dataset.buttonNumber;
//     if (buttonNumber === "01") {
//         this.likeStateSize01 = !this.likeStateSize01;
//         console.log('Button 1 clicked');
//     }
// }

// handleButton2Click(event) {
//     const buttonNumber = event.target.dataset.buttonNumber;
//     if (buttonNumber === "02") {
//         this.likeStateSize02 = !this.likeStateSize02;
//         console.log('Button 2 clicked');
//     }
// }
handleLikeButtonSizeClick(event) {
    const buttonNumber = event.target.dataset.buttonNumber;
    const likeStateKey = `likeStateSize${buttonNumber}`;
  
    // Set all like states to false except for the current one
    Object.keys(this.likeState).forEach(key => {
      if (key !== likeStateKey) {
        this.likeState[key] = false;
      }
    });
  
    // Toggle the current like state
    this.likeState[likeStateKey] = !this.likeState[likeStateKey];
  }
   
}