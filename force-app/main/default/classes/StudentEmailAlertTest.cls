@isTest
public class StudentEmailAlertTest{
    @isTest
    private static void EmailAlert(){
       
        
        Student__c stu =new Student__c();
        stu.Name='Test';
        stu.Class__c='TestClass';
        String email='sivasankara.thellamekhala@raagvitech.com';
      
       String userEmail=UserInfo.getUserEmail();
        insert stu;
        
        Student__c[] stuDetail=[SELECT Name FROM Student__c Where Id=:stu.Id];
        System.assertEquals(email,userEmail);
    }
}