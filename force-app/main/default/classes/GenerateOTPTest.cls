@isTest
private class GenerateOTPTest {
     @testSetup static void setup() {
        User user = new User();
        user.Username ='ntrOrg@test.com';
        user.LastName = 'LastTestName';
        user.Email = 'testemail@test.com';
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = 'en_US';
         user.OTPs__c='si89';
         user.PathNum__c=2;
       // user.ContactId=con.Id;
        insert user;
     }
   @isTest
    static void verifyOTPTest(){
       User u1 = [SELECT id from User WHERE username = 'ntrOrg@test.com' LIMIT 1];
     System.runas(u1) {
         String st='si89';
            GenerateOTP.verifyOtp(st);
     }
    }
    @isTest
    static void ValiodverifyOTPTest(){
       User u1 = [SELECT id from User WHERE username = 'ntrOrg@test.com' LIMIT 1];
     System.runas(u1) {
         String st='si892';
            GenerateOTP.verifyOtp(st);
     }   
    }
 /*@isTest
    static void getUserTest(){
       User u1 = [SELECT id ,PathNum__c from User WHERE username = 'ntrOrg@test.com' LIMIT 1];
     System.runas(u1) {
         String st='2';
            GenerateOTP.getUser(st);
     }   
    }    */
    
}