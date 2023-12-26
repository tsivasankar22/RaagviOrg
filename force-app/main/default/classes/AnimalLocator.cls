public class AnimalLocator {
    public static string getAnimalNameById(integer x){
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' +x);
        req.setMethod('GET');
        Map<string, object> animal = new Map<string, object>();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200){
            Map<string, object> result = (Map<string, object>)JSON.deserializeUntyped(res.getBody());
            animal = (Map<string, object>) result.get('animal');
        }
        return (string)animal.get('name');        
    }
}