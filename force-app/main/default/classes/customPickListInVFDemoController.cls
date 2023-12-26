public class customPickListInVFDemoController {

    public String selectedCountry1{get;set;}
    
    public String selectedCountry2{get;set;}
    
        public customPickListInVFDemoController(){
    
        }
    
        
    
        public List<SelectOption> getCountriesOptions() {
    
            List<SelectOption> countryOptions = new List<SelectOption>();
    
            countryOptions.add(new SelectOption('','-None-'));
    
            countryOptions.add(new SelectOption('INDIA','India'));
    
            countryOptions.add(new SelectOption('USA','USA'));
    
            countryOptions.add(new SelectOption('United Kingdom','UK'));
    
            countryOptions.add(new SelectOption('Germany','Germany'));
    
            countryOptions.add(new SelectOption('Ireland','Ireland'));
    
     
    
            return countryOptions;
    
        }
    
        public PageReference save(){
    
            return null;
    
        }
    
    }