@isTest(seeAllData=false)
private class EcommerceDataIntegrationTestClass {

testMethod static void testUserTransactionTest() {

String user_id = '272';

test.startTest();
       
        Test.setMock(HttpCalloutMock.class, new getAccestokensMockUpTest());
        EcommerceDataIntegrationTest e = new EcommerceDataIntegrationTest();
        e.getEcommerceDataIntegration(user_id);
        test.stopTest();
   }
   
   
   testMethod static void testUserTransactionTest1() {
   String user_id = '272';
   
   Contact c = new Contact();
   c.email = 'anil.jha@nanostuffs.com';
   c.LastName = 'Anil';
   insert c;

       test.startTest();
       
        Test.setMock(HttpCalloutMock.class, new getAccestokensMockUpTest());
        EcommerceDataIntegrationTest e = new EcommerceDataIntegrationTest();
        e.getEcommerceDataIntegration(user_id);
       	test.stopTest();
   }
   
   
    public class getAccestokensMockUpTest implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req)
        {
          
           System.assertEquals('https://www.tryloctite.in/user-order-info?user_id=272', req.getEndpoint());
           System.assertEquals('GET', req.getMethod());
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            return res;
        }
       
    }
    
   
    
    static testMethod void testNotification() {
      EcomNotification.testCode();
     // e.testCode();
        
    }  
    
    static testMethod void testindustyBuy() {
      IndustryBuying_Helper.testCode();
     // e.testCode();
        
    } 
        
   
    
   
 }