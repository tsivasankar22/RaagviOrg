public class RegistrationAndLoginController
{
    @AuraEnabled
    public static String doLogin(String username, String password)
    {
        try 
        {
            System.debug('UserName---'+ username);
            System.debug('Password debug top'+password);
            System.debug('<------->');
            String startUrl = 'https://rtsandbox-dev-ed.my.site.com/s/home';
            ApexPages.PageReference pageRef = Site.login(username, password, startUrl);
            System.debug('-->'+pageRef);
            System.debug('-->'+password);
            if(pageRef != null) return pageRef.getUrl();
            throw new CalloutException();
            
        } 
        catch (Exception e) 
        {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static boolean isEmailExist(String username){
        try {
            
            List<User> userList = new List<User>();
            userList = [Select Id, Name From User Where Username = :username];
            System.debug('userList-->'+userList);
           //throw new CalloutException();
                
            return !userList.isEmpty();


        } catch (Exception e) {
            System.debug('Catch userList-->');
            throw new AuraHandledException(e.getMessage());
            

            //return null;
        }
    }

    @AuraEnabled
    public static string registerUser(String firstName, String lastName, String username, string phone, String email, String communityNickname, String password){
        try {
                System.debug('Password Debug 1'+password);
                System.debug('firstName 1'+firstName);
                System.debug('lastName 1'+lastName);
                System.debug('username 1'+username);
                System.debug('email 1'+email);
                System.debug('phone 1'+phone);
            Set<String> communityNicknameSet = new Set<String>();

            for(User usr : [Select Id, CommunityNickname From User Where CommunityNickname != null]){

                communityNicknameSet.add(usr.CommunityNickname);
            }

            String uniqueCommunityNickName;

            if(communityNicknameSet.isEmpty()){

                if(communityNickname.length() > 4){
                    
                    uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                
                } else {

                    uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                }
            
            } else {

                for(Integer i=1; i <= 9999 ; i++){

                    if(communityNickname.length() > 4){
                        
                        uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    
                    } else {

                        uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    }

                    if(!communityNicknameSet.contains(uniqueCommunityNickName)){

                        break;
                    }
                }
            }
            // Contact con = [SELECT LastName, AccountId, Email, Id, Name FROM Contact WHERE Id = '0035i00000EG4lxAAD'];
            User u = new User();
            u.firstName = firstName;
            u.lastName = lastName;
            u.Username = username;
            u.Email = email;
            u.CommunityNickname = uniqueCommunityNickName ;
            u.Phone = phone;
            // u.ContactId = con.Id;
            // u.Alias = 'User10';
            // u.ProfileID ='00e5i000000hWX2AAM';
            // u.TimeZoneSidKey = 'America/New_York';
            // u.LocaleSidKey = 'en_US';
            // u.EmailEncodingKey = 'UTF-8';
            // u.LanguageLocaleKey = 'en_US'; 
             
            String accountId;

            // Account portalAccount = new Account();
            // portalAccount.Name = firstName + ' ' + lastName;
            // insert portalAccount;

            // portalAccount.IsPartner = true;
            // update portalAccount;

            //accountId = portalAccount.Id;

            accountId = '0015g00000uYKgxAAG';
            
           // System.debug('Account 1--->'+portalAccount);
            System.debug('Account 2--->'+accountId);
            System.debug('user 1--->'+u);
            System.debug('password --101-->'+password);

            String userId = Site.createPortalUser(u, accountId, password);

            System.debug('user 2-->'+userId);

            if (userId != null) {
                
                
                System.debug('user --3-->'+userId);
                System.debug('accountId --10-->'+accountId);
                System.debug('password --100-->'+password);


                
                if (password != null && password.length() > 1) {

                    String mainUrl = 'https://rtsandbox-dev-ed.my.site.com/s/home';

                    ApexPages.PageReference pageRef = Site.login(username, password, mainUrl);
                    if(pageRef != null) return pageRef.getUrl();
                    System.debug('Password debug 2'+password);
                }
                else {
                    ApexPages.PageReference page = System.Page.SiteRegisterConfirm;
                    page.setRedirect(true);

                    System.debug('page redirect 2-->');

                    return page.getUrl();
                }
            }

            //throw new CalloutException();       //this for return

            return null; 


        } catch (Exception e) {
            system.debug('e.getMessage+   '+e.getMessage());
            
            if(!Test.isRunningTest()) throw new AuraHandledException(e.getMessage());

            return null;
            
        }
    }
    @AuraEnabled
    public static string sendWelcomeMail(User usr, String userId){
        try {
                System.debug('Email----->confirm---->');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List<EmailTemplate> welcomeTemplate = new List<EmailTemplate>([Select Id from EmailTemplate where name = 'Welcome to community']);
                     
            mail.setSenderDisplayName(System.Label.Community_Email_Sender);
            mail.setTargetObjectId(userId);
            mail.setTemplateId(welcomeTemplate[0].Id);
            mail.setSaveAsActivity(false);

            Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail} );

            return 'success';

        } catch (Exception e) {            
            throw new AuraHandledException(e.getMessage());
        }
    }
}