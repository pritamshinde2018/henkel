global class SendSMS_Helper
{        
    public static void SendSMS(Contact contactData)
    {
         String mob = String.valueOf(contactData.Phone);
         if(mob != null)
         {
         	mob = mob.replaceAll('[^0-9]', '');
         	CallApi(mob,contactData.LastName);
         }
    }
    
    
    
    public static void SendResetPwdEmail(Contact contactData)
    {
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
         mail.setTargetObjectId(contactData.Id); 
         mail.setSenderDisplayName('Ecommerce Reset Password'); 
         mail.setUseSignature(false); 
         mail.setBccSender(false); 
         mail.setSaveAsActivity(false); 
         EmailTemplate et=[Select id from EmailTemplate where Name=:'Reset Password Ecomm']; 
         mail.setTemplateId(et.id); 
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
      
    }
 
 
    @Future(callout=true)
    public static void CallApi(String toNumber,String name)
    {
    
    
        //String message = 'Hello '+name+', warm welcome to TryLoctite. We hope you find your wished products at the best price on our website.';
        String message = 'Hello '+name+', Your temp password for LOCTITE eStore has been sent to your registered email id. For queries, reach us on 1800-233-3562.';
        String Username = 'Henkel';
        String Password = 'X2ZbNJzPX';
        String Senderid = 'LCTITE';
        message = message.replace(' ','%20');
        
        
        
        String EndURL = 'http://125.16.147.178/VoicenSMS/webresources/CreateSMSCampaignGet?ukey=&userid=henkel&password=henkel@123&filetype=2&msisdn='+toNumber+'&language=0&credittype=2&senderid=LCTITE&message='+message;
      
        //String EndURL   = 'http://api.sss.bz/smpp?username='+Username+'&password='+Password+'&from='+Senderid+'&to='+toNumber+'&text='+message;
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(EndURL);
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120000);
        
        Http http = new Http();
        if(!System.Test.IsRunningTest())
               {
              HttpResponse response = http.send(httpRequest);
              }
        
        /*try 
        {
           System.debug('Welcome Message Sent'+response.getBody());
        }
        catch(Exception e)
        {
            System.debug('Error to send message'+e);
        }*/
    
    }
    
    /*public static void SendSMS_Common(String toNumber, String msg)
    {
        sendSMSMessage(toNumber, msg);
    }*/
    
    @Future(callout=true)
    public static void sendSMSMessage(String toNumber, String msg)
    {
        String Username = 'Henkel';
        String Password = 'X2ZbNJzPX';
        String Senderid = 'LCTITE';
        msg = msg.replace(' ','%20');
        toNumber = toNumber.replaceAll('[^0-9]', '');
        
        String EndURL = 'http://125.16.147.178/VoicenSMS/webresources/CreateSMSCampaignGet?ukey=&userid=henkel&password=henkel@123&filetype=2&msisdn='+toNumber+'&language=0&credittype=2&senderid=LCTITE&message='+msg;
       /* String EndURL   = 'http://api.sss.bz/smpp?username=' + Username + '&password=' + Password
                                +'&from=' + Senderid + '&to=' + toNumber + '&text=' + msg;*/
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(EndURL);
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120000);
        
        Http http = new Http();
        if(!System.Test.IsRunningTest())
               {
        HttpResponse response = http.send(httpRequest);
        }
    }
}