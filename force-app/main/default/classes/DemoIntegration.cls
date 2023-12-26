public class DemoIntegration {
    public static void IntegrationMethod(){
        Http ht=new Http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint('Callout:Demo');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        HttpResponse responce=ht.send(req);
        System.debug('responceeee-----'+responce.getStatusCode());
        System.debug('get code-----'+responce.getBody());     
    }
}