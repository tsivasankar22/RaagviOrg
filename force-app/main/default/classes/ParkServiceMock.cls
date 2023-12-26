@isTest
global class ParkServiceMock implements WebServiceMock{
    global void doInvoke(
        Object stub,
        Object request,
        Map<string, Object> response,
        string endpoint,
        string soapAction,
        string requestName,
        string responseNS,
        string responseName,
        string responseType) {
            parksServices.byCountryResponse response_x = new parksServices.byCountryResponse();
            response_x.return_x = new List<string>{'Hamburg Wadden sea National Park','Hainich National Park'};
            response.put('response_x', response_x);       
            
        }
}