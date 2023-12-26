public class UpdateLastViewedDate {
    
    public static void updateLastViewedDate(Id recordId) {
        Residential_Loan_Application__c loanApplication = [
            SELECT Id,Last_View_Date__c
            FROM Residential_Loan_Application__c
            WHERE Id = :recordId
        ];

        if (loanApplication.Last_View_Date__c < System.now().addSeconds(-10)) {
            loanApplication.Last_View_Date__c = System.now();
            update loanApplication;
        }
    }

}
