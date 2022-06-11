@isTest(seeAllData=true)
public class LinkedinDesignGuideCalloutTestClass {
      @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','urn:li:adForm:4166443');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
 @isTest static void testCallout2() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','urn:li:adForm:4175373');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
@isTest static void testCallout3() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','urn:li:adForm:4175393');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    @isTest static void testCallout4() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','urn:li:adForm:4166433');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    @isTest static void testCallout5() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','Download Guidance Retaining Component_10Feb2022');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    @isTest static void testCallout6() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedinDesignGuideCallout.calloutWebservice('testemail@testd.com','6874564012','teztljkfdlfjk','hdsjksdhkcompany','110001','Developer','IT','Banking','0-20','Guided Content | Retaining | March 2021');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}