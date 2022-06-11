@isTest
public class TestIndiaMartIntegrationDemo 
{
    @isTest public static  void testCallout()
    {
        Test.setMock(HttpCalloutMock.class,new IndiaMartMockCallout());
        IndiaMartWrapper iObj=new IndiaMartWrapper();
        IndiaMartWrapper.parse('{"RN":"1","QUERY_ID":"1254","QTYPE":"ANC"}');
        Contact cnt=new Contact();
        cnt.LastName='test123';
        Insert cnt;
        Lead lObj=new Lead();
        lObj.LastName='demo';
        lObj.Company='Nano';
        lObj.Indiamart_ID__c='763001274111';
        Insert lObj;
        test.startTest();
        //IndiaMartIntegrationDemo.extract_LeadData('8329380527','07-04-202101:00:01','07-04-202108:00:01');
        IndiaMartIntegrationDemo sh1 = new IndiaMartIntegrationDemo();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch,sh1);
        
        IndiaMartIntegrationDemo sh2 = new IndiaMartIntegrationDemo();      
        String sch2 = '0 0 23 * * ?';
        system.schedule('Test check2', sch2,sh2);
        test.stopTest();
        
    }
}