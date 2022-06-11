/*
 * test Class name : calloutClasstest
*/
public class LinkedlnWebinarCallout {
    @future(callout=true)
    public static void calloutWebservice(string email,string phone,string LeadSource,string name,string company ,string postalcode,string Industry,string Number_of_Employees)
    {
        String mob = String.valueOf(phone);
         if(mob != null)
         {
         mob = mob.replaceAll('[^0-9]', '');
         }
        System.debug('Values -----'+email+phone+leadSource);
        system.debug('Mob------'+mob);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://beta.tryloctite.in/webinar/ondemand-api-threadlockers/?email='+email+'&mobile='+mob+'&source='+LeadSource+'&name='+name+'&company='+company+'&industry='+Industry+'&number_of_employees='+Number_of_Employees+'&pincode='+postalcode);
        //request.setEndpoint('http://13.127.110.224/webinar/ondemand-api-threadlockers?email='+email+'&mobile='+mob+'&source='+LeadSource);
        //add production link 
        //request.setEndpoint('https://www.tryloctite.in/webinar/ondemand-api-threadlockers?email='+email+'&mobile='+mob+'&source='+LeadSource);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        if(!test.isRunningTest())
        {
          HttpResponse response = http.send(request);  
        }
        
        //system.debug('response print'+response.getbody());
       // return res;

    }
}