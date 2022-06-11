@isTest
public class TestAftershipTrackingCTAAPI {
    
    @Testsetup
    public static void dummyDate()
    {
       CTA__c ct1 = new CTA__c();
        ct1.Waybill_No__c = 'ED757654715IN';
        ct1.Reference_No__c = '1234';
        //ct1.Customer_Contact__c = '8181858585';
        ct1.Blue_Dart_Status__c = '';
        insert ct1;
    }
    
	@isTest
    public static void trackingCTAAPI()
    {
        system.debug('Dummy Data before setmock');
          Test.setMock(HttpCalloutMock.class, new CTAHttpCalloutMockImpl());
        system.debug('Dummy Data After setmock');
       AftershipTrackingCTAAPI.sendCalloutREST();
        system.debug('Dummy Data After sendCalloutREST');
    }
}