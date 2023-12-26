trigger GroceriesSearchHandler on ContentVersion (after insert) {
    List < ContentDocumentLink > listCDLs = new List < ContentDocumentLink >();
    System.debug('content step 1================');
    for ( ContentVersion objCV : trigger.new ) {
       // if(Trigger.isInsert){
          //  GroceriesSearchHandler.documnetPreview(trigger.new);
          if ( String.isBlank( objCV.pdf_fileupload__c) ) {
            System.debug('content step 3================');
            ContentDocumentLink objCDL = new ContentDocumentLink();
            objCDL.LinkedEntityId = objCV.ContentDocumentId;
            System.debug('LinkedEntityId============' +objCDL.LinkedEntityId);
            objCDL.ContentDocumentId = objCV.ContentDocumentId;
            System.debug('uploadId==============='+objCV.ContentDocumentId);
            listCDLs.add( objCDL );
          
            System.debug('content================'+listCDLs);
            System.debug('objCDL================'+objCDL);

      //  }

        }
        
      
    }
    // if ( listCDLs.size() > 0 ) {
        
    //     upsert listCDLs;
    //     System.debug('insert================'+listCDLs);
        
    // }
   


}