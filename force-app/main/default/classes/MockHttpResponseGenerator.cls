@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://13.127.110.224/webinar/ondemand-api-threadlockers?email=abcd@gmail.com&mobile=9766924768&source=Linkedin', req.getEndpoint());
        System.debug('req--- '+req);
        //System.assertEquals('https://www.tryloctite.in/webinar/ondemand-api-threadlockers?email=piyusha122@testing.com&mobile=8111111234&source=Linkedin&name=test&company=compa&industry=test&number_of_employees=0-20&pincode=14526', req.getEndpoint());
        //https://www.tryloctite.in/webinar/ondemand-api-threadlockers?email=piyusha122@testing.com&mobile=8111111234&source=Linkedin
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}