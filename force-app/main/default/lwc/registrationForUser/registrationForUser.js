import { LightningElement, track } from 'lwc';
import isEmailExist from '@salesforce/apex/RegistrationAndLoginController.isEmailExist';
import registerUser from '@salesforce/apex/RegistrationAndLoginController.registerUser';

export default class RegisterComponent extends LightningElement 
{

    @track firstName = null;
    @track lastName = null;
    @track email = null;
    @track userName = null;
    @track password = null;
    @track confirmPassword = null;
    @track phone = null;
    @track Accept = false;
    @track disabledsignIn = true;
    @track errorCheck;
    @track errorMessage;
    showUserName;
    @track showTermsAndConditions;
    @track showTermsAndConditionsLoading = false;
    @track infoTooltipDisplayData = {};
    @track requiredTooltipDisplayData = {};
    @track errorTooltipDisplayData = {};
    @track emailError;
    @track passwordError;

    @track checkBoxDisable=true;


    connectedCallback()
    {

        this.showUserName = false;

        this.infoTooltipDisplayData.username = "tooltiptext usernameTooltiptext";
        this.infoTooltipDisplayData.password = "tooltiptext";
        this.infoTooltipDisplayData.phone = "tooltiptext";

        this.requiredTooltipDisplayData.firstName = 'tooltiptext tooltipHide';
        this.requiredTooltipDisplayData.lastName = 'tooltiptext tooltipHide';
        this.requiredTooltipDisplayData.phone = 'tooltiptext tooltipHide';
        this.requiredTooltipDisplayData.email = 'tooltiptext tooltipHide';  
        this.requiredTooltipDisplayData.username = 'tooltiptext tooltipHide';       
       
        this.requiredTooltipDisplayData.password = 'tooltiptext tooltipHide';
        this.requiredTooltipDisplayData.confirmPassword = 'tooltiptext tooltipHide';

        this.errorTooltipDisplayData.email = 'tooltiptext tooltipHide';
        this.errorTooltipDisplayData.password = 'tooltiptext tooltipHide';
    }

    onEmailInvalid(event)
    {
        if (!event.target.validity.valid) 
        {
            event.target.setCustomValidity('Enter a valid email address')
        }
        
    }

    onEmailInput(event)
    {

        event.target.setCustomValidity('')
    }

    onEmailClick(event)
    {

        let parent = event.target.parentElement.parentElement.parentElement;
        console.log('parent-', parent);
        parent.classList.remove('tooltipEmail');
    }

    onEmailBlur(event)
    {

        let parent = event.target.parentElement.parentElement.parentElement;
        console.log('parent-', parent);
        parent.classList.add('tooltipEmail');
    }

    handleRegister(event)
    {
        console.log('inside handle result---');
        this.errorMessage = null;

        this.errorTooltipDisplayData.email = 'tooltiptext tooltipHide';
        this.errorTooltipDisplayData.password = 'tooltiptext tooltipHide';

        if(!this.firstName)
        {

            this.requiredTooltipDisplayData.firstName = 'tooltiptext tooltipShow';
            console.log('firstName--i');

        } 
        else 
        {

            this.requiredTooltipDisplayData.firstName = 'tooltiptext tooltipHide';
            console.log('firstName---e');
        }
        if(!this.lastName)
        {

            this.requiredTooltipDisplayData.lastName = 'tooltiptext tooltipShow';
            console.log('lastName---i');

        } 
        else 
        {  
            this.requiredTooltipDisplayData.lastName = 'tooltiptext tooltipHide';
            console.log('lastName---e');
        }
        if(!this.phone)
        {
            this.requiredTooltipDisplayData.phone = 'tooltiptext tooltipShow';
            this.infoTooltipDisplayData.phone = "tooltiptext tooltipHide";
            console.log('phone---i');

        }
         else 
        {
            
            this.requiredTooltipDisplayData.phone = 'tooltiptext tooltipHide';
            console.log('phone---e');
        }
        if(!this.email)
        {
            this.requiredTooltipDisplayData.email = 'tooltiptext tooltipShow';
            console.log('email---i');

        }
        else
        { 
            this.requiredTooltipDisplayData.email = 'tooltiptext tooltipHide';
            console.log('email---e');
        }
        if(!this.userName){

            this.requiredTooltipDisplayData.username = 'tooltiptext tooltipShow';
            this.infoTooltipDisplayData.username = "tooltiptext usernameTooltiptext tooltipHide";
            console.log('userName---i');

        } else {
            
            this.requiredTooltipDisplayData.username = 'tooltiptext tooltipHide';
            console.log('userName---e');
        }
        if(!this.password)
        {
            this.requiredTooltipDisplayData.password = 'tooltiptext tooltipShow';
            this.infoTooltipDisplayData.password = "tooltiptext tooltipHide";
            console.log('password---i');

        }
         else 
        {
            
            this.requiredTooltipDisplayData.password = 'tooltiptext tooltipHide';
            console.log('password---e');
        }
        if(!this.confirmPassword)
        {
            this.requiredTooltipDisplayData.confirmPassword = 'tooltiptext tooltipShow';
            console.log('confirmPassword---i');

        } 
        else 
        {    
            this.requiredTooltipDisplayData.confirmPassword = 'tooltiptext tooltipHide';
            console.log('confirmPassword---e');
        }
        if(this.firstName && this.lastName && this.phone && this.email && this.userName && this.password && this.confirmPassword)
        {
            this.showTermsAndConditionsLoading = true;
            if(this.password != this.confirmPassword)
            {
                this.infoTooltipDisplayData.password = "tooltiptext tooltipHide";
                this.passwordError = 'Password did not match. Please Make sure both the passwords match.';
                this.errorTooltipDisplayData.password = 'tooltiptext tooltipShow tooltipError';

                event.preventDefault();

                this.showTermsAndConditionsLoading = false;
                
                return;
            }

            let emailCheck = /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(this.email);

            console.log('emailCheck--',emailCheck);

            if( emailCheck == null || emailCheck == undefined || emailCheck == false )
            {

                this.showTermsAndConditionsLoading = false;
                console.log('inside email check');
                
                this.emailError = 'Please enter a valid email address';
                this.errorTooltipDisplayData.email = 'tooltiptext tooltipShow tooltipError';
                
                return;
            }

            let passwordCheck = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/.test(this.password);
            console.log('passwordCheck--',passwordCheck);
            
            if(passwordCheck == null || passwordCheck == undefined || passwordCheck == false)
            {

                this.showTermsAndConditionsLoading = false;
                console.log('inside Password check');
                this.infoTooltipDisplayData.password = "tooltiptext tooltipHide";
                this.passwordError = 'Password must be Minimum eight characters, at least one letter, one number and one special character.';
                this.errorTooltipDisplayData.password = 'tooltiptext tooltipShow tooltipError';
                
                return;
            }
            
            event.preventDefault();
            console.log('username--->'+this.userName );
            isEmailExist({ username: this.userName  })
            .then((result) => {

                console.log('login result---'+result, typeof result);
                
                if(result == true)
                {

                    this.emailError = 'Your username already exists somewhere on the  Salesforce Ecosystem.';
                    this.errorTooltipDisplayData.email = 'tooltiptext tooltipShow tooltipError';

                    this.showTermsAndConditionsLoading = false;

                }
                else 
                {   console.log('it stop here');
                    registerUser({ firstName: this.firstName, lastName: this.lastName, phone:this.phone, email: this.email, username: this.userName, communityNickname: this.firstName, password: this.password })
                        .then((result) => {
                                        
                            if(result)
                            {                       
                                console.log('it stop here---1');
                                window.location.href = result;
            
                            } 
                            this.showTermsAndConditionsLoading = false;
                        })
                        .catch((error) => {
                            this.error = error;
            
                            console.log('error-',JSON.stringify(error));
            
                            this.showTermsAndConditionsLoading = false;
            
                            if(error && error.body && error.body.message)
                            {
            
                                this.showTermsAndConditions = false;
                                this.errorCheck = true;
                                this.errorMessage = error.body.message;
                               
                            }           
                            
                        });
                }

                
            })
            .catch((error) => {
                this.error = error;
             
                if(error && error.body && error.body.message)
                {
                    
                    console.log('error msg-', error.body.message);
                }

                this.showTermsAndConditionsLoading = false;
                
            });
        
        }
    }
    handleTermsAndConditions(event)
    {

        this.showTermsAndConditions = true;
    }

    handleFirstNameChange(event)
    {

        this.firstName = event.target.value;
    }

    handleLastNameChange(event)
    {

        this.lastName = event.target.value;
    }
    handlePhoneNumberChange(event)
    {
        this.phone = event.target.value;
    }
    handleEmailChange(event)
    {
        if(event.target.value){

            this.email = event.target.value;
            this.userName = this.email + '.Mart';
        
        } else {

            this.email = event.target.value;
            this.userName = this.email;
        }
    }  

    handlePasswordChange(event){

        this.password = event.target.value;
    }

    handleConfirmPasswordChange(event){

        this.confirmPassword = event.target.value;

        if(this.password != this.confirmPassword)
            {
                this.infoTooltipDisplayData.password = "tooltiptext tooltipHide";
                this.passwordError = 'Password did not match. Please Make sure both the passwords match.';
                this.errorTooltipDisplayData.password = 'tooltiptext tooltipShow tooltipError';

                event.preventDefault();
                
                this.checkBoxDisable=true;
                
                this.showTermsAndConditionsLoading = false;
                
                return;
            }
            else(this.password == this.confirmPassword)
            {
                this.infoTooltipDisplayData.password = "tooltiptext tooltipShow";
                this.errorTooltipDisplayData.password = 'tooltiptext tooltipHide ';

                this.checkBoxDisable=false;
            }
    }

    closeTermsAndConditions(event){

        this.showTermsAndConditions = false;
    }
    handelCheckbox(event)
    {
        this.ischecked = event.target.checked;
        if(this.ischecked==true)
        {
            this.disabledsignIn = false;
        }
        else
        {
            this.disabledsignIn = true;
        }

    }
    handleEmailHover(event){
    }

}