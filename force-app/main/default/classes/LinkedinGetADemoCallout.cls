public class LinkedinGetADemoCallout 
{
    @future(callout=true)
    public static void calloutWebservice(string email,string phone,string name,string company,string postalcode,string designation,string department,string industry,string no_of_employees)
    {
        String mob = String.valueOf(phone);
         if(mob != null)
         {
           mob = mob.replaceAll('[^0-9]', '');
         }
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.tryloctite.in/estore/sales-force/customformvalidationapi/');
        request.setMethod('POST');
        String str='{"email":"'+email+'","phone":"'+mob+'","full_name":"'+name+'","company_name":"'+company+'","pin_code":"'+postalcode+'","industry_types":"'+industry+'","no_of_employees":"'+no_of_employees+'","designation":"'+designation+'","department":"'+department+'","form_type":"requestdemoformsalesforce","Website_Concent":"true"}';
        system.debug('str--------------------- '+str);
        request.setBody(str);
        request.setHeader('content-type','application/json');
        if(!test.isRunningTest())
        {
          HttpResponse response = http.send(request);  
        }
        


    }

}