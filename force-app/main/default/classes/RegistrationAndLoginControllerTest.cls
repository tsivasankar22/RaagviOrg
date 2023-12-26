@isTest
public class RegistrationAndLoginControllerTest 
{   
    @isTest(SeeAllData=true)	
    public static String doLoginTest()
    {
        try
        {
			RegistrationAndLoginController.doLogin('shubhammandloi@gmail.com.Mart', 'mandloi@22');
			return 'true';          
        }
        catch (Exception e)
        {
            return null;
        }
    }
    @isTest(SeeAllData=true)
    public static boolean isEmailExistTest()
    {      
            RegistrationAndLoginController.isEmailExist('shubhammandloi599@gmail.com.Mart');
        	return true;
    }
    @isTest(SeeAllData=true)
    public static string registerUserTest()
    {
        RegistrationAndLoginController.registerUser('shubham', 'mandloi', 'shubham@gmail.com.Mart', '8786888796', 'shubham@gmail.com', 'sum', 'Mandloi@28');
        return 'success';
    }
    @isTest(SeeAllData=true)
    public static string sendWelcomeMailTest()
    {
            User usr = [SELECT Id FROM User WHERE Id =:'0055g00000FN7QKAA1'];
            RegistrationAndLoginController.sendWelcomeMail(usr,'0055g00000FN7QKAA1');
        	return 'success';
    }
}