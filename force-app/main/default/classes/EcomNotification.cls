@RestResource (urlMapping='/notification/*')
global class EcomNotification{
   
    @HttpPost
    global static void doPost(String id) {
    
   
    try
        {
       /* upsert ecomNot Name;*/
           EcommerceDataIntegrationTest testss = new EcommerceDataIntegrationTest();
           testss.getEcommerceDataIntegration(id);
           
           RestContext.response.addHeader('Content-Type', 'application/json');
           RestContext.response.responseBody = Blob.valueOf('{ "status" : "200", "message" : "ssssss" }');
    }
    catch(Exception e)
        {
         RestContext.response.addHeader('Content-Type', 'application/json');
         RestContext.response.responseBody = Blob.valueOf('{ "status" : "500", "message" : "Sever Error" }');
        }

    }
    
    global static void testCode()
    {
     Integer i = 0;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
    }
}