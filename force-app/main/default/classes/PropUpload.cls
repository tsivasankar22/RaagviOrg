public class PropUpload  
{  
    public Id recId  
    {    get;set;    }  
      
    public PropUpload(ApexPages.StandardController ctlr)  
    {  
       recId = ctlr.getRecord().Id;       
    }  
      
    public string fileName   
    {    get;set;    }  
      
    public Blob fileBody   
    {    get;set;    }  
    
    public  PageReference UploadFile()  
    {  
         PageReference pr;  
        if(fileBody != null && fileName != null)  
        {  
          Attachment myAttachment  = new Attachment();  
          myAttachment.Body = fileBody;  
          myAttachment.Name = fileName;  
          myAttachment.ParentId = recId;  
          insert myAttachment;  
                                            
        }  
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
              return null; 
                
                
    }          
}