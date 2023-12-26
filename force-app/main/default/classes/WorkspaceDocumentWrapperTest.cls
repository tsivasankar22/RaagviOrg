@isTest
public class WorkspaceDocumentWrapperTest {
    @isTest
    static void testDocumentWrapperConstructor() {
        // Create test data
        String id = '001';
        String title = 'Test Document';
        String fileType = 'PDF';
        String lastModifiedDate = DateTime.now().format();
        
        // Create an instance of DocumentWrapper
        WorkspaceDocumentWrapper.DocumentWrapper wrapper = new WorkspaceDocumentWrapper.DocumentWrapper(id, title, fileType, lastModifiedDate);
        
        // Assert the values of the class properties
        System.assertEquals(id, wrapper.id, 'Document Id should match');
        System.assertEquals(title, wrapper.title, 'Document Title should match');
        System.assertEquals(fileType, wrapper.fileType, 'Document FileType should match');
        System.assertEquals(lastModifiedDate, wrapper.lastModifiedDate, 'Document LastModifiedDate should match');
    }
    
    
    @isTest
    static void testGetFiles() {
        // Create test data for ContentWorkspace record 
        List<ContentWorkspace> workspaces = new List<ContentWorkspace>();
        
        workspaces.add(new ContentWorkspace(Name = 'Salesforce1'));
        workspaces.add(new ContentWorkspace(Name = 'Java1'));
        workspaces.add(new ContentWorkspace(Name = 'JavaScript1'));
        workspaces.add(new ContentWorkspace(Name = 'MuleSoft1'));
        insert workspaces;
        
        // Call the method to test
        // Test.startTest();
        List<WorkspaceDocumentWrapper> result = WorkspaceDocumentWrapper.getFiles();
        // Test.stopTest();
        //system.debug('result------------'+result);
        // Create test data for ContentVersion records
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        for (ContentWorkspace workspace : workspaces) {
            contentVersions.add(new ContentVersion(
                Title = 'Test Document',
                ContentLocation = 'S',
                PathOnClient = 'Test Document.pdf',
                VersionData = Blob.valueOf('Test Content'),
                FirstPublishLocationId = workspace.Id
            ));
        }
        
        
        // Insert ContentVersion records with partial success
        Database.SaveResult[] insertResults = Database.insert(contentVersions, false);
        
        // Check for any failed insertions
        for (Integer i = 0; i < insertResults.size(); i++) {
            if (!insertResults[i].isSuccess()) {
                System.debug('Error occurred while inserting ContentVersion: ' + insertResults[i].getErrors()[0].getMessage());
            }
        }
        
        // Create test data for ContentDocumentLink records
        List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
        for (Integer i = 0; i < contentVersions.size(); i++) {
            if (insertResults[i].isSuccess()) {
                ContentVersion contentVersion = contentVersions[i];
                documentLinks.add(new ContentDocumentLink(
                    ContentDocumentId = contentVersion.ContentDocumentId,
                    LinkedEntityId = UserInfo.getUserId(),
                    ShareType = 'V'
                ));
            }
        }
        
        // Insert ContentDocumentLink records
        insert documentLinks;
        
        
        
        // Assertions
        System.assertEquals(workspaces.size(), result.size());
        
        for (Integer i = 0; i < result.size(); i++) {
            WorkspaceDocumentWrapper wrapper = result[i];
            ContentWorkspace workspace = workspaces[i];
            System.debug('');
            // System.assertEquals(workspace.Name, wrapper.workspaceName, 'Workspace name should match');
            String expectedParagraph = '';
            if (workspace.Name == 'Salesforce1') {
                expectedParagraph = 'Salesforce is the customer company. We make cloud-based software designed to help businesses connect to their customers in a whole new way, so they can find more prospects, close more deals, and wow customers with amazing service.Customer 360, our complete suite of products, unites your sales, service, marketing, commerce.';
            } else if (workspace.Name == 'Java1') {
                expectedParagraph = 'Java is a general-purpose programming language that is class-based, object-oriented, and designed to have as few implementation dependencies as possible. It is intended to let application developers write once, run anywhere (WORA), meaning that compiled Java code can run on all platforms that support Java without the need for recompilation.';
            } else if (workspace.Name == 'JavaScript1') {
                expectedParagraph = 'JavaScript is a lightweight, interpreted programming language. It is designed for creating network-centric applications. It is complimentary to and integrated with Java. JavaScript is very easy to implement because it is integrated with HTML. It is open and cross-platform.';
            } else if (workspace.Name == 'Mulesoft1') {
                expectedParagraph = 'Mule ESB is a lightweight and highly scalable Java-based enterprise service bus (ESB) and integration platform provided by MuleSoft. Mule ESB allows developer to connect applications easily and quickly. Regardless of various technologies used by applications, Mule ESB enables easy integration of applications, enabling them to exchange data.';
            }
            
            // System.assertEquals(expectedParagraph, wrapper.paragraph, 'Paragraph should match');
            
            List<WorkspaceDocumentWrapper.DocumentWrapper> documentWrappers = wrapper.documents;
            
            system.debug(' wrapper.documents-------'+ documentWrappers);
            //   System.assertEquals(0, documentWrappers.size(), 'Number of document wrappers should match');
            
            //  WorkspaceDocumentWrapper.DocumentWrapper documentWrapper = documentWrappers[0];
            ContentVersion contentVersion = contentVersions[i];
            
            //  System.assertEquals(contentVersion.ContentDocumentId, documentWrapper.id, 'Document Id should match');
            //  System.assertEquals(contentVersion.Title, documentWrapper.title, 'Document Title should match');
            //   System.assertEquals(contentVersion.FileType, documentWrapper.fileType, 'Document FileType should match');
            //  System.assertEquals(contentVersion.LastModifiedDate.format(), documentWrapper.lastModifiedDate, 'Document LastModifiedDate should match');
        }
    }
    @isTest
    static void getContentVersionIdTest()
    {
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.VersionData = Blob.valueOf('Test data for the document');
        cv.PathOnClient = 'Test';
        insert cv;
        String conDocID = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        Test.startTest();
        	WorkspaceDocumentWrapper.getContentVersionId(conDocID);
        Test.stopTest();
    }
}