@isTest
public class ResidentialDealsTest
{   
    @testSetup
    public static void setupmethod(){
       
        Residential_Loan_Application__c deal1=new Residential_Loan_Application__c(Name='00000013',Broker__c='siva',Borrower__c='Shankar',Loan_Amount__c=100,Loan_Status__c='Application',Rate__c=20);
        Residential_Loan_Application__c deal2=new Residential_Loan_Application__c(Name='0000012',Broker__c='Veera',Borrower__c='Jonnalagadda',Loan_Amount__c=1377,Loan_Status__c='Commitment',Rate__c=220);
        Residential_Loan_Application__c deal3=new Residential_Loan_Application__c(Name='0000014',Broker__c='Darshan',Borrower__c='Baadri',Loan_Amount__c=89765,Loan_Status__c='Cancelled',Rate__c=2);
       
        list<Residential_Loan_Application__c> dealsList = new list<Residential_Loan_Application__c>();
        dealsList.add(deal1);
        dealsList.add(deal2);
        dealsList.add(deal3);
   
        insert dealsList;
    }
    @IsTest
    public static void testResidential()
    {
         List<Residential_Loan_Application__c> rla6 = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where  Name = '00000013'];
             ResidentialDeals.sortDealsItem(rla6[0].Broker__c,'');
        System.assertEquals('siva', rla6[0].Broker__c);
        
        List<Residential_Loan_Application__c> rla7 = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where Name = '0000012'];
             ResidentialDeals.sortDealsItem(rla7[0].Broker__c,rla7[0].Loan_Status__c);
        System.assertEquals('Veera', rla7[0].Broker__c);
        
        List<Residential_Loan_Application__c> rla8 = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where Name = '0000014'];
             ResidentialDeals.sortDealsItem(rla8[0].Broker__c,'All Deals');
        System.assertEquals('Darshan', rla8[0].Broker__c);
        
       
        
        List<Residential_Loan_Application__c> rla1 = [SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where Name = '00000013'];
             ResidentialDeals.filterDeals(rla1[0].Loan_Status__c);
        System.assertEquals('Application', rla1[0].Loan_Status__c);
        
         List<Residential_Loan_Application__c> rla2 =[SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where Name = '0000012'];
             ResidentialDeals.filterDeals(rla2[0].Loan_Status__c);  
       System.assertEquals('Commitment', rla2[0].Loan_Status__c);
        
         List<Residential_Loan_Application__c> rla3 =[SELECT Id, Name, Broker__c, Borrower__c, Loan_Amount__c,Loan_Status__c,Rate__c
                FROM Residential_Loan_Application__c Where Name = '0000014'];
             ResidentialDeals.filterDeals(rla3[0].Loan_Status__c);     
       System.assertEquals('Cancelled', rla3[0].Loan_Status__c);
        
        ResidentialDeals.filterDeals('Void');
        ResidentialDeals.filterDeals('Active');
        ResidentialDeals.filterDeals('Decline');
        ResidentialDeals.filterDeals('Paid Out');
        ResidentialDeals.filterDeals('Decline');
        ResidentialDeals.filterDeals('All Deals');
    }
 
}