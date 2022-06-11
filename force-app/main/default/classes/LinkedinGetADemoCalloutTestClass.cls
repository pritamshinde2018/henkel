@isTest(seeAllData=true)
public class LinkedinGetADemoCalloutTestClass {
      @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinGetADemoCallout.calloutWebservice('testemail123@gmail.com','9147412147','LinkedinGetDemo','GETDEMOIN','411037','Banking','100','Developer','IT');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    


}