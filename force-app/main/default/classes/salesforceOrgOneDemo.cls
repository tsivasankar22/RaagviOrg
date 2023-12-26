@RestResource(urlMapping='/Cases/')
global class salesforceOrgOneDemo 
{
	
    @HttpPost
    global static Id createCase()
    {
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        String jsonString = restReq.requestBody.toString();
        
        System.debug('jsonString=====>'+jsonString);
        
        responseWrapper resWrap =(responseWrapper)JSON.deserialize(jsonString, responseWrapper.Class);
        System.debug('resWrap======>'+resWrap);
        
        Case caseObj = new Case();
        caseObj.ExternalId__c = resWrap.ExteralId;
        caseObj.Subject = resWrap.caseSubject;
        caseObj.Origin	= resWrap.caseOrigin;
        caseObj.Status	= resWrap.caseOrigin;
        caseObj.Priority = resWrap.casePriority;
        
        insert caseObj;
        return caseObj.Id;
    }
    
    @HttpPut
    global static Id upsertCase()
    {
        
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        String jsonString = restReq.requestBody.toString();
        
        System.debug('jsonString=====>'+jsonString);
        
        responseWrapper resWrap =(responseWrapper)JSON.deserialize(jsonString, responseWrapper.Class);
        System.debug('resWrap======>'+resWrap);
        Case oldCase = [SELECT ExternalId__c, Id from Case Where ExternalId__c =:resWrap.ExteralId];
        System.debug('Old Case Id>>>'+oldCase);
        Case caseObj = new Case();
       if(oldCase.Id !=null )
       {
            caseObj.Id = oldCase.Id;
       }
        caseObj.Subject = resWrap.caseSubject;
        caseObj.Origin	= resWrap.caseOrigin;
        caseObj.Status	= resWrap.caseOrigin;
        caseObj.Priority = resWrap.casePriority;
        System.debug('caseObj>>'+caseObj);
        upsert caseObj;
        return caseObj.Id;
    }
    
     @HttpDelete
    global static String delCase()
    {
        
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        String jsonString = restReq.requestBody.toString();
        
        System.debug('jsonString=====>'+jsonString);
        
        responseWrapper resWrap =(responseWrapper)JSON.deserialize(jsonString, responseWrapper.Class);
        System.debug('resWrap======>'+resWrap);
        Case oldCase = [SELECT ExternalId__c, Id from Case Where ExternalId__c =:resWrap.ExteralId];
        System.debug('Old Case Id>>>'+oldCase);
        
       if(oldCase.Id !=null )
       {
           delete oldCase;
       }
        return 'Delete_SuccesFully';
    } 
    public class responseWrapper
    {
        public String caseId;
        Public String caseSubject;
        public String caseStatus;
        public String caseOrigin;
        public String casePriority;
        public Double ExteralId;
    }
}