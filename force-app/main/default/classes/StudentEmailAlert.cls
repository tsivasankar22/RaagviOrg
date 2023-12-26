public class StudentEmailAlert {
    // class
    public static void SendEmailNotification(List<Student__c> stuList)
        //Method Name for student object
    {
        
        List<Messaging.Email> student1=new List<Messaging.Email>();
        //student 1 is the reference , creating a list
        Messaging.SingleEmailMessage emailMsg= new Messaging.SingleEmailMessage();
        //messaging.SingleEnail Message is a method ,creating a new mwethod for sending a mail purpose
        for(Student__c stu :stuList){
            //condition for student object
                String userEmail=UserInfo.getUserEmail();
            //User mail who is logied 
                String[] toAddress=new String[]{userEmail};
                emailMsg.setToAddresses(toAddress);
            //mail is send to which address like that
                String subEmail='A record is created '+stu.Name;
            //in the mail display what we can show the content
                emailMsg.setSubject(subEmail);
                String disName= ' RaagviTech ';
            //this is the display name for the mail
                emailMsg.setSenderDisplayName(disName);
            //content body of mail
            String content = 'Hi'+' ' + stu.Name + ',<br/><br/>'+' Welcome to student portal'+',<br/><br/>' +
                    ' am recieved your application '+',<br/><br/>'+'thanks for choosing student portal'+',<br/><br/>'
                    +'My Team Will be get back to you soon '+',<br/><br/>' +'Thank You '+',<br/><br/>';
                emailMsg.setHtmlBody(content);
            //storing all the things
                student1.add(emailMsg);

        }  
             Messaging.sendEmail(student1);
    }
}