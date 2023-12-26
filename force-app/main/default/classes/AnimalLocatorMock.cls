@isTest
global class AnimalLocatorMock implements HTTPCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request){
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals": ["majestic badger", "fluffy bunny","scary bear", "chicken","mighty moose"]}');
        response.setStatusCode(200);
        return response;
    }
}