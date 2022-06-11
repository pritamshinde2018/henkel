@isTest
public class TestTradeIndiaIntegration 
{
	@isTest public static  void testCallout()
    {
        Test.setMock(HttpCalloutMock.class,new TradeIndiaMockCallout());
        TradeIndiaWrapper iObj=new TradeIndiaWrapper();
        TradeIndiaWrapper.parse('{"rfi_id":"154544454","sender_name":"ABC","source":"CATALOG"}');
        Contact cnt=new Contact();
        cnt.LastName='test123';
        Insert cnt;
        Lead lObj=new Lead();
        lObj.LastName='demo';
        lObj.Company='Nano';
        lObj.Indiamart_ID__c='763001274111';
        Insert lObj;
        
        lObj.LastName='demo';
        lObj.Company='Nano1';
        lObj.Indiamart_ID__c='763001274111';
        update lObj;
        test.startTest();
        TradeIndiaIntegration sh1 = new TradeIndiaIntegration();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch,sh1);
        
        TradeIndiaIntegration sh2 = new TradeIndiaIntegration();      
        String sch2 = '0 0 23 * * ?';
        system.schedule('Test check2', sch2,sh2);
        test.stopTest();
    }
}