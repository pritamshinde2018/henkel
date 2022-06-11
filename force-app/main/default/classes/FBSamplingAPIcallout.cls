public class FBSamplingAPIcallout {
     @future(callout=true)
    public static void calloutWebservice(string email,string phone,string which_product_sent,string name,string company ,string postalcode)
    {
        String mob = String.valueOf(phone);
         if(mob != null)
         {
         mob = mob.replaceAll('[^0-9]', '');
         }
        //System.debug('Values -----'+email+phone+leadSource);
       // system.debug('Mob------'+mob);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.tryloctite.in/estore/sales-force/customformvalidationapi/');
        request.setMethod('POST');
        request.setBody('{"email":"'+email+'","mobile_no":"'+mob+'","name":"'+name+'","company_name":"'+company+'","pincode":"'+postalcode+'","user_products_all":"'+which_product_sent+'","form_type":"samplingform"}');
        request.setHeader('Content-Type', 'application/json');
        if(!test.isRunningTest())
        {
          HttpResponse response = http.send(request);  
        }
        


    }

}