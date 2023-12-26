trigger ConventVersionTrigger on ContentVersion (after insert) {
    List < ContentDocumentLink > listCDLs = new List < ContentDocumentLink >();
    
    for ( ContentVersion objCV : trigger.new ) {
        System.debug('content step 1================');
        if ( String.isBlank( objCV.pdf_fileupload__c ) ) {
            System.debug('content step 2================');
            ContentDocumentLink objCDL = new ContentDocumentLink();
            objCDL.LinkedEntityId = objCV.pdf_fileupload__c;
            objCDL.ContentDocumentId = objCV.ContentDocumentId;
            listCDLs.add( objCDL );

           System.debug('listCDLs ================'+listCDLs);
           // System.debug('ContentDocumentId ================'+ContentDocumentId);
        }
}
// if ( listCDLs.size() > 0 ) {
        
//     insert listCDLs;
    
// }
}