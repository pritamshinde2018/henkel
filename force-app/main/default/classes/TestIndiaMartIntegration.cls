@isTest
public class TestIndiaMartIntegration 
{
    @isTest public static  void testCallout()
    {
        Test.setMock(HttpCalloutMock.class,new IndiaMartMockCallout());
        IndiaMartWrapper iObj=new IndiaMartWrapper();
        IndiaMartWrapper.parse('{"RN":"1","QUERY_ID":"1254","QTYPE":""}');
        Contact cnt=new Contact();
        cnt.LastName='test123';
        Insert cnt;
        Lead lObj=new Lead();
        lObj.LastName='demo';
        lObj.Company='Nano';
        lobj.Email = 'harshind2007@gmail.com';
        lObj.Indiamart_ID__c='763001274111';
        Insert lObj;
        
        
        test.startTest();
        IndiaMartIntegration sh1 = new IndiaMartIntegration();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch,sh1);
        
        IndiaMartIntegration sh2 = new IndiaMartIntegration();      
        String sch2 = '0 0 23 * * ?';
        system.schedule('Test check2', sch2,sh2);
        test.stopTest();
        
    }
}