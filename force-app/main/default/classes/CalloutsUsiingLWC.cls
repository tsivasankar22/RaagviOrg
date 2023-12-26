public with sharing class CalloutsUsiingLWC {

    // Method to retrieve data from an external API
    @AuraEnabled
    public static Map<String, Object> retriveNews(){
        // Creating an HTTP request instance
        HttpRequest httpRequest = new HttpRequest();

        // Setting the API endpoint for data  retrieval
        httpRequest.setEndpoint('https://newsapi.org/v2/everything?q=tesla&from=2023-10-30&sortBy=publishedAt&apiKey=7560d713db53448db919bfc10c7d29fa');
        httpRequest.setMethod('GET');

        // Initializing variables to store the JSON response
        Map<String, Object> newsJsonData = new Map<String, Object>();
        String strResponse = null;

        try{
            // Making the HTTP request
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);

            // Checking if the request was successful (HTTP status code 200)
            if(httpResponse.getStatusCode() == 200){
                // Storing the JSON response
                strResponse = httpResponse.getBody();
            } else {
                // Throwing a custom exception for unsuccessful requests
                throw new CalloutException(httpResponse.getBody());
            }

        } catch(Exception ex){
            // Propagating any caught exceptions
            throw ex;
        }

        // Parsing the JSON response if it is not blank
        if(!String.isBlank(strResponse)){
            newsJsonData = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
        }

        // Returning the news data if available, otherwise, returning null
        if(!newsJsonData.isEmpty()){
            return newsJsonData;
        } else {
            return null;
        }
    }
}
