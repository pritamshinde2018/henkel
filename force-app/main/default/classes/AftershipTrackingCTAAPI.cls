public class AftershipTrackingCTAAPI implements schedulable{
    
    public void execute(SchedulableContext sc){
        sendCalloutREST();
    }
    
    @future(callout=true)
    public static void sendCalloutREST(){
                
        try{
            
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        	EmailTemplate etSample = [SELECT id FROM EmailTemplate WHERE Name='Step-3 Dispatch' Limit 1];
            List<Contact> contList=new List<Contact>();
            contList = [SELECT id FROM Contact Limit 1];
            String str='2020-11-15';
            Date d;
            d=Date.valueOf(str);
            List<CTA__c> trackingNumber = [SELECT id, Waybill_No__c, Sample_Received_On_Project_Start_Date__c, Customer_Email__c, Reference_No__c, Customer_Contact__c, Pincode__c, Blue_Dart_Status__c, Courier_Company__c FROM CTA__c WHERE Waybill_No__c != null AND Courier_Company__c = 'India Post' And Blue_Dart_Status__c != 'SHIPMENT DELIVERED' AND createddate>:d Limit 60];
            List<CTA__c> ct1 = new List<CTA__C>();
            for(CTA__c ct : trackingNumber)    
			{
                boolean sendEmail = false;
            if(ct.Blue_Dart_Status__c == null || ct.Blue_Dart_Status__c == '')
            {
                sendEmail = true;
            }
           
           String endPointURL = 'https://api.aftership.com/v4/trackings/india-post/'+ct.Waybill_No__c;
                system.debug('Done');
            //String endPointURL = 'https://api.aftership.com/v4/trackings/india-post/ED757654715IN';
            System.debug('cta: '+ct.Waybill_No__c);
            String APIKEY = '3948d8d3-49f3-4a85-832f-7860ae76784c';
            Httprequest request = new HttpRequest();
            Http http = new Http();
            request.setMethod('GET');
            request.setEndpoint(endPointURL);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('aftership-api-key', APIKEY);
            HttpResponse response = http.send(request);
            System.debug('responseBody: '+response.getBody());
            string jsonstring = response.getBody();
            System.debug('jsonstring'+jsonstring);
            JsonParserAftership testpass=new JsonParserAftership();
            JsonParserAftership requestElement = (JsonParserAftership)JSON.deserialize(jsonstring,JsonParserAftership.class);
            System.debug('Response:'+requestElement);
            
            
            JsonParserAftership.data trackingnuber = requestElement.data;
         //   List<JsonParserAftership.checkpoints> checkpoint = trackingnuber.checkpoints;
           //
           
                //System.debug('trackingNumber:'+trackingnuber.tracking.tracking_number);
                
             //  opp = [Select Id,Waybill_No__c,SampleReceivedOn__c,Courier_Company__c from Opportunity where Courier_Company__c = 'India Post' And Waybill_No__c =:trackingnuber.tracking.tracking_number];
                
                
                 //System.debug('trackingMessage:'+trackingnuber.tracking.subtag_message);
                
                if(trackingnuber.tracking.subtag_message!=null && trackingnuber.tracking.subtag_message == 'Delivered')
                {
                     ct.Blue_Dart_Status__c = 'SHIPMENT DELIVERED';
                    ct.Sample_Received_On_Project_Start_Date__c = System.today();
                }
               else
                {
                    if(trackingnuber.tracking.subtag_message!=null)
                    ct.Blue_Dart_Status__c = trackingnuber.tracking.subtag_message;
                }
                 ct1.add(ct);
              System.debug('CTAdata:'+ct1);          
           if(sendEmail == true){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{ct.Customer_Email__c};
                String[] toccAddress = new String[]{'akshay.phatak@nanostuffs.com','ajinkya.wankhede@nanostuffs.com','Monika.kothari@nanostuffs.com'};
                mail.setToAddresses(toAddress);
                mail.setCcAddresses(toccAddress);
                if(contList.size()!=0)
                mail.setTargetObjectId(contList[0].id);
                mail.setWhatId(ct.id);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setSaveAsActivity(false);
                mail.setTemplateId(etSample.id);
                emailList.add(mail);
               if(!Test.isRunningTest()){
            //Messaging.sendEmail(emailList);
        }  
            }
            }
            if(!Test.isRunningTest())
            update ct1; 
                
            
        }
        catch(Exception e){
            
            System.debug('Error::'+e.getMessage());
            System.debug('Line number : '+e.getLineNumber());
            
        }
    
        
}
}