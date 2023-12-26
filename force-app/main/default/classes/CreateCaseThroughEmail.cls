global class CreateCaseThroughEmail implements Messaging.InboundEmailHandler {
        global String Id;
        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            try
            {
                Id caseId = Cases.getCaseIdFromEmailHeaders(email.headers);
                if (caseId == null){
                map<String,Id> mapCase=new map<String,Id>();
                for(Group queue :[SELECT Id, Name, Type FROM Group WHERE Type = 'Queue'])
                {
                    mapCase.put(queue.Name, queue.Id);
                     System.debug('queue-->'+ queue);
                }
                
                // CaseQueues__c var= CaseQueues__c.getInstance('Queue1');               
                // string variable =var.Name;
                // //List<String> firstemail = var.CaseForEmail__c.split(',');
                // string firstemail=var.CaseForEmail__c.split(',').get(0);
                // string thirdemail=var.CaseForEmail__c.split(',').get(1);
                // system.debug('var-->'+var);
                // system.debug('variable-->'+variable);
                // system.debug('firstemail-->'+firstemail);
                // // system.debug('thirdemail-->'+thirdemail);
                // CaseQueues__c var1= CaseQueues__c.getInstance('Queue2');               
                // string variable1 =var1.Name;
                // List<String> secondemail = var1.CaseForEmail__c.split(',');
                // system.debug('var1-->'+var1);


                //  system.debug('variable1-->'+variable1);
                // system.debug('secondemail-->'+secondemail);
                
                String fromAdd=email.fromAddress;
                Case c1 =new Case();
                c1.Origin ='Email';
                c1.Status ='New';
                c1.Priority='High';
                c1.Subject = email.subject;
                c1.Description=email.plainTextBody;
                c1.email__c=email.fromAddress;
                c1.SuppliedEmail=email.fromAddress;
                
                
                // if(firstemail == email.toAddresses[0] || thirdemail == email.toAddresses[0] ) 
                // {
                //     c1.OwnerId = mapCase.get(variable);
                //     System.debug('Queue1--->'+c1.OwnerId);
                // }
                // if ( secondemail == email.toAddresses) 
                // {
                //     c1.OwnerId = mapCase.get(variable1);
                //     System.debug('Queue2--->'+c1.OwnerId);
                // }
                
                system.debug(' c1.OwnerId-->'+ c1.OwnerId);
                List<Contact> conList=[SELECT Id, Name, Email 
                                       FROM Contact 
                                       WHERE Email=:email.fromAddress
                                      ];
                System.debug('size'+conList.size());
                
                List<Case> caseList=[select ContactId, email__c from Case];
                for(Contact con :conList )
                    if(conList.size()>=2){
                     //   c1.Multiple_Contacts__c=true;
                        c1.ContactId=null;
                        system.debug('step   1  countList.add(con.Email)------------>'+conList);
                    }
                else if(conList.size()<=1){
                  //  c1.Multiple_Contacts__c=false;
                    c1.ContactId=con.Id;
                    system.debug('step   2  countList.add(con.Email)------------>'+conList);
                }
                system.debug(' email.fromAddress'+ email.fromAddress);
                //  system.debug(' cas.email__c'+ cas.email__c);
                //system.debug(' cas.email__c'+ cas.email__c);
                //
              
                
                   insert c1;  
          
                
               // CaseEmailStoreMethod(email,c1.Id);
                system.debug('finesh Queroy');
                    CaseId= c1.id;
                    
                    system.debug('CaseId==========='+CaseId);
            }
               Id = CaseId;
                System.debug('Id =========> '+Id);
                CaseEmailStoreMethod(email);
            }
            
            catch(Exception e)
            {
                result.success=false;
            }
            return result;
        }
        
        global void CaseEmailStoreMethod(Messaging.InboundEmail email)
        {
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            try
            {
                 String toAddresses;
                if (email.toAddresses != null) {
                    toAddresses = String.join(email.toAddresses, '; ');
                   system.debug('Email send ----0-->'+toAddresses); 
                EmailMessage emailMsgObj = new EmailMessage();
                emailMsgObj.HtmlBody =  email.htmlBody;
                emailMsgObj.TextBody = email.plainTextBody;
                emailMsgObj.FromAddress = email.fromAddress; 
                emailMsgObj.ToAddress =email.toAddresses[0];
                emailMsgObj.FromName = email.fromName;
                emailMsgObj.Subject = email.subject;
                emailMsgObj.Incoming = true;
                emailMsgObj.Status = '0';
                emailMsgObj.MessageDate = system.now();
                emailMsgObj.ParentId =Id ;
                insert emailMsgObj;
                result.success = true;
                System.debug('DEBUG LEVEL : '+email.binaryAttachments);
                
                List<Attachment> attachments = new List<Attachment>();
                if(email.textAttachments != NULL && email.textAttachments.size() > 0){
                    for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                        attachments.add(new Attachment(
                            Name = tAttachment.fileName,
                            Body = Blob.valueOf(tAttachment.body),
                            ParentId =Id
                        ));
                    }
                }
                if(email.binaryAttachments != NULL && email.binaryAttachments.size() > 0){
                    for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                        attachments.add(new Attachment(
                            Name = bAttachment.fileName,
                            Body = bAttachment.body,
                            ParentId =Id
                        ));
                    }
                }
                insert attachments; 
            }
            } 
            catch(Exception e)
            {
                result.success=false;
            }
            system.debug('finesh Queroy');
        }   
    }