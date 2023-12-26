public with sharing class CaseController {
    @AuraEnabled
    public static Id createCaseRecord(Id recordId) {
        try {
            // Create a new Case record
            Case newCase = new Case(
                Subject = 'New Case Subject', // Replace with your desired values
                Description = 'New Case Description',
                // Add more fields as needed
                AccountId = recordId // Assuming you're creating the Case related to the record with the provided Id
            );
            // Insert the Case record
            insert newCase;
            // Return the Id of the newly created Case record
            return newCase.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Case: ' + e.getMessage());
     }
}