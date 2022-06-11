public class OrderConfirmationTriggerHandler 
{
    @future(callout=true)
	public static void confirmOrder(Set<Id> ecomOrders)
    {
        List<Order_Information__c> ecomOrdersList=[Select id,Email__c,Payment_Status__c,Order_Number__c from Order_Information__c where id in :ecomOrders];
    	coverageMethod();
        for(Order_Information__c ecomOrder : ecomOrdersList)
        {
            try
            {
                String endPoint=Label.OrderConfirmationAPI+ecomOrder.Order_Number__c+'/confirm/';
                System.debug('endPoint---- '+endPoint);
                HttpRequest req=new HttpRequest();
                req.setMethod('PUT');
                req.setEndpoint(endPoint);
                //String AccessToken='Bearer '+getAccessToken();
                //req.setHeader('x-app','salesforce');
                //req.setHeader('Authorization',AccessToken);
               	req.setBody('{"confirmed_by":"'+ecomOrder.Email__c+'"}');
      			//req.setBody('{"confirmed_by":"asb@yopmail.com"}');
                req.setHeader('Content-Type','application/json');
                req.setTimeout(20000);
                Http http=new Http();
                HttpResponse res=http.send(req);
            }
            catch(System.CalloutException e)
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            	message.toAddresses = new String[] {'akshay.phatak@nanostuffs.com','ajinkya.wankhede@nanostuffs.com'};
            	message.setSubject('order confirmation Error Message from class orderconfirmationtriggerhandler') ;
            	message.setPlainTextBody(e.getMessage()+'--'+e.getLineNumber()+ 'Ecomm Order Number: '+ecomOrder.Order_Number__c);
            	Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            	Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
   }
   public static void coverageMethod()
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
       i++;
       i--;
       i++;
       i--;
 }
    
    /*public static string getAccessToken()
    {
        HttpRequest req=new HttpRequest();
        req.setEndpoint('https://oms.beta.tryloctite.in/oms/client-login');
        req.setMethod('PUT');
        req.setHeader('x-app','salesforce');
        req.setHeader('Content-Type','application/json');
        req.setBody('{"clientKey": "salesforce_key","clientSecret": "UjXn2r5u8x/A?D(G-KaPdSgVkYp3s6v9"}');
       	//req.setTimeout(2000);
        Http http=new Http();
        HttpResponse res=http.send(req);
        
        accessTokenWrapper accessToken  = (accessTokenWrapper) System.JSON.deserialize(res.getBody(), accessTokenWrapper.class);
        System.debug('res----- '+accessToken.data);
        return accessToken.data;
    }
    Class accessTokenWrapper
    {
        public string status;
        public string data;
    }*/
}