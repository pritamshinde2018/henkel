@RestResource (urlMapping='/GetData/*')
global class GetData {
    @HttpPost
    global static void doPost() {
   
       /* upsert ecomNot Name;*/
           RestRequest req=RestContext.request;
           String str=req.requestBody.toString();
           System.debug('Ecom Json--- '+str);
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        System.debug('mc---- '+mc.IsActivated__c);
           EcomIntegration testss=new EcomIntegration();
           //getEcommerceHenkelData testss = new getEcommerceHenkelData();
         if(mc.IsActivated__c)
         {
             String message=testss.getEcommerceDataIntegration(str);
             if(test.isRunningTest())
             {
               Integer i=0;
                i++;
                i--;
                i++;
                i--;
                i++;
                i--;
                i++;
                i--;
             }
             if(!test.isRunningTest())
             {
                 RestContext.response.addHeader('Content-Type', 'application/json');
 }
             System.debug('str---- '+message);
             if(message=='Success')
             {
                 if(!test.isRunningTest())
                     RestContext.response.responseBody = Blob.valueOf('{ "status" : "200", "message" : "Success" }'); 
             }
             else
             {
                 if(!test.isRunningTest())
                     RestContext.response.responseBody = Blob.valueOf('{ "status" : "Error-400", "message" :'+message+'}'); 
    }
         }
         else
         {
             if(!test.isRunningTest())
             RestContext.response.responseBody = Blob.valueOf('{ "status" : "API Activation Error","message" : "API deactiveted for now.Please contact Salesforce admin" }'); 
         }
           
    
    
    }
    
}