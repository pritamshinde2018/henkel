@isTest(seeAllData=true)
private class FBLeadZapierAPITestClass {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        FBSamplingAPIcallout.calloutWebservice('piyusha122@testing.com','8111111234','LOCTITE Retaining Compound 638','test','compa','14526');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    

}