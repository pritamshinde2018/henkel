global class PopulateBlueDartInfo implements Schedulable,Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public void execute(SchedulableContext SC){
        Database.executebatch(new PopulateBlueDartInfo(),5);
    }
    
    public Database.QueryLocator Start(Database.BatchableContext BC){
        String query = 'SELECT id,Waybill_No__c,AccountId,Contact_Email__c,Reference_No__c,contact2__c,contact2__r.MailingPostalCode,Contact_PinCode__c,Blue_Dart_Status__c,Pincode_Status__c FROM Opportunity WHERE Waybill_No__c != null AND Waybill_No__c != \'\' AND Blue_Dart_Status__c != \'SHIPMENT DELIVERED\' AND Courier_Company__c != \'India Post\'';
        return Database.getQueryLocator(query);
    } 
    public void execute(Database.BatchableContext BC, List<Opportunity> scope){  
       // System.debug('scope-->>>'+scope.size()+scope);
        List<Opportunity> projectListWithWayBill = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate etSample = [SELECT id FROM EmailTemplate WHERE Name='Step-3 Dispatch' Limit 1];
        EmailTemplate etOffer = [SELECT id FROM EmailTemplate WHERE Name='Case1-Step7-Dispatch' Limit 1];
        EmailTemplate etdist = [SELECT id FROM EmailTemplate WHERE Name='Case1-Step4 Sample Confirmation Email-Distributor' Limit 1];
        Contact cont = [SELECT id FROM Contact Limit 1];
        List<User> userList = [SELECT id,Pin_codes__c,Email,Email__c FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
        List<Account> accListToUpdate = new List<Account>();
        Map<id,Contact> conMapToUpdate = new Map<id,Contact>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity opp : scope){
            contIdSet.add(opp.contact2__c);
            accIdSet.add(opp.AccountId);
        } 
        
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT id,OwnerId FROM Account WHERE id IN :accIdSet]);
        Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT id,OwnerId FROM Contact WHERE id IN :contIdSet]);
        
        for(Opportunity opp : scope){
            boolean sendEmail = false;
            if(opp.Blue_Dart_Status__c == null || opp.Blue_Dart_Status__c == ''){
                sendEmail = true;
            }
            
            //String url = 'http://api.bluedart.com/servlet/RoutingServlet?handler=tnt&action=custawbquery&loginid= DEL00636&awb=awb&numbers='+opp.Waybill_No__c+'&format=HTML&lickey=710eedf40e7b7609f0f16750095e0ca0&verno=1.3&scan=0';
            String url='http://api.bluedart.com/servlet/RoutingServlet?handler=tnt&action=custawbquery&loginid= DEL00636&awb=awb&numbers='+opp.Waybill_No__c+'&format=HTML&lickey=710eedf40e7b7609f0f16750095e0ca0&verno=1.3&scan=0';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setHeader('contentType','application/json');
            req.setMethod('POST');
            req.setTimeout(20000);
            Http h = new Http(); 
            String str1='';
            if(!Test.isRunningTest()){
                HttpResponse resp = h.send(req);
                str1 = resp.getBody();
                //System.debug('str1888 '+str1);
                //System.debug('resp.getBody() '+resp.getBody());
            }
            if(Test.isRunningTest()){
                str1  = '<table border=0 cellspacing=1 cellpadding=0><tr><td colspan=3 valign="TOP" bgcolor="#F0F0F0"><font face="Verdana,Arial" size=1 color="black">Waybill No :<b>40021792694</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ref No : <b>0067F00000T0ZOz</b></font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Service</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">Domestic Priority</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Prod code</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">D</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Pickup Date</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">04 September 2019</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Picup Time</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">2044</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Origin</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">GURGAON</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Origin AreaCode</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">GGN</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Destination</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">CONTAI</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Destination AreaCode</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">CAI</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Product Type</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">Documents</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Customer Name</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">TLG INDIA PVT. LTD</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Sender Name</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">SOLUTION</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">To Attention</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">ASIS DAS</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Consignee</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">BUSINESSMAN</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Consignee Address1</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">ASHISH DAS HOUSE NO-22 SCHOOL</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Consignee Address2</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">BAZAAR KONTAI POST OFFICE KONT</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Consignee Address3</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">AI POLICE STATAION KONTAI</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Consignee Pincode</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">721401</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Weight</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">0.5</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Expected Delivery Date</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">07 September 2019</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Status</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">SHIPMENT DELIVERED</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Status Type</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">DL</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Status Date</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">09 September 2019</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Status Time</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">18:32</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Received By</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">ASIS DAS</font></td></tr><tr><td width=200 align="RIGHT" valign="TOP"><font face="Verdana,Arial" size=1 color="black">Instructions</font></td><td width=10></td><td width=430><font face="Verdana,Arial" size=1 color="black">DOCUMENTS</font></td></tr><tr><td colspan=3><br></td></tr></table>';
            }
            System.debug(str1.contains('Ref No :'));
            if(str1.contains('Ref No : ')){
                Integer st = str1.indexOf('Ref No : ');
                System.debug('str1.indexOf(Ref No :) '+str1.indexOf('Ref No :'));
                st = str1.indexOf('<b>', st) + 4;
                Integer nd = str1.indexOf('<',st);
                String refNo = str1.substring(st, nd);
                if(!String.isBlank(refNo))
                    opp.Reference_No__c = refNo;
            }
            System.debug(str1.contains('Pickup Date'));
            if(str1.contains('Pickup Date')){
                Integer st1 = str1.indexOf('Pickup Date');
                System.debug('st1 Pickup Date '+st1);
                st1 = str1.indexOf('color="black"', st1) + 14;
                system.debug('st1 color="black" '+st1);
                Integer nd1 = str1.indexOf('<',st1);
                String pickupDate = str1.substring(st1, nd1);
                System.debug(pickupDate);
                if(!String.isBlank(pickupDate))
                    opp.Pick_up_date__c = pickupDate;
            }
            System.debug('STR1---'+str1);
            Integer st2 = str1.indexOf('Origin');
            st2 = str1.indexOf('color="black"',st2) +14;
            Integer nd2 = str1.indexOf('<',st2);
            System.debug('nd2----'+nd2);
            System.debug('from :'+str1.substring(st2, nd2));
            System.debug('st2 '+st2);
            String fromAdd = str1.substring(st2, nd2);
            
            if(!String.isBlank(fromAdd))
                opp.From_Address__c = fromAdd;
            
            Integer st3 = str1.indexOf('Destination');
            st3 = str1.indexOf('color="black"', st3) + 14;
            Integer nd3 = str1.indexOf('<',st3);
            String toAddr= str1.substring(st3, nd3);
            System.debug('refNo:'+toAddr);
            if(!String.isBlank(toAddr))
                opp.To_Address__c = toAddr;
            
            Integer st4 = str1.indexOf('Status'); /*!=-1 ? str1.indexOf('>Status :') : str1.indexOf('>Status</font>');*/          
            st4 = str1.indexOf('color="black"', st4) +14;
            Integer nd4 = str1.indexOf('<',st4);
            String status = str1.substring(st4, nd4);
            if(status.contains('In Transit :'))
            {
                st4 = str1.indexOf('>In Transit :');
                st4 = str1.indexOf('size=2', st4) + 7; 
                nd4 = str1.indexOf('<',st4);
                status = str1.substring(st4, nd4);
            }
            status = status.replace('&nbsp;','');
            status = status.replace('>','');
            status = status.replace('-','');
            status = status.trim();
            if(!String.isBlank(status))
                opp.Blue_Dart_Status__c = status;
            if(status == 'SHIPMENT DELIVERED'){
                opp.SampleReceivedOn__c = System.today();
            }
            
            Integer st5 = str1.indexOf('Status Date');
            st5 = str1.indexOf('color="black"', st5) + 14;
            Integer nd5 = str1.indexOf('<',st5);
            String deliveryDate = str1.substring(st5, nd5);
            System.debug('deliveryDate:'+deliveryDate);
            if(!String.isBlank(deliveryDate))
                opp.Date_of_Delivery__c = deliveryDate;
            
            Integer st6 = str1.indexOf('Status Time');
            st6 = str1.indexOf('color="black"', st6) + 14;
            Integer nd6 = str1.indexOf('<',st6);
            String deliveryTime= str1.substring(st6, nd6);
            System.debug('deliveryTime:'+deliveryTime);
            if(!String.isBlank(deliveryTime))
                opp.Time_of_Delivery__c = deliveryTime;
            
            Integer st7 = str1.indexOf('Recipient :');
            st7 = str1.indexOf('size=2', st7) + 8;
            Integer nd7 = str1.indexOf('<',st7);
            String recepient = str1.substring(st7, nd7);
            System.debug('recepient:'+recepient);
            if(!String.isBlank(recepient))
                opp.Recipient__c = recepient;
            
            projectListWithWayBill.add(opp);    
            if(sendEmail == true){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{opp.Contact_Email__c};
                String[] toccAddress = new String[]{'areeb.usman@henkel.com','aditya.kumar@digitas.com'};
                mail.setToAddresses(toAddress);
                mail.setCcAddresses(toccAddress);
                mail.setTargetObjectId(cont.id);
                mail.setWhatId(opp.id);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setSaveAsActivity(false);
                //mail.setOrgWideEmailAddressId('0D27F000000PD8P'); // prod
                if(opp.Prospect_Interest_Type__c == 'Offer'){
                    mail.setTemplateId(etOffer.id);
                }else{
                    mail.setTemplateId(etSample.id);
                }
                System.debug('mail details------:'+mail);
                emailList.add(mail);
                
                
                //assign to distributor
                
                String pincode = opp.Contact_PinCode__c;//opp.contact2__r.MailingPostalCode;
                if(Test.isRunningTest() && String.isBlank(pincode)){
                    pincode = '110001';
                }
                for(User u : userList){
               // System.debug('u----:'+u);
                    String pincodeStr;
                    if(u.Pin_codes__c != null){
                        pincodeStr = u.Pin_codes__c;
                        //System.debug('pincodeStr--->>>'+u.id+' '+pincodeStr);
                         Boolean checkpincodeStr;
                        if(pincodeStr!=null)
                        {
                            checkpincodeStr=String.isBlank(pincodeStr); 
                        }
                        Boolean checkpincode=false;
                        if(pincode!=null)
                        {
                           checkpincode=pincodeStr.contains(pincode);
                        }
                        if((!checkpincodeStr && checkpincode) && opp.Pincode_Status__c != null && opp.Pincode_Status__c != '2'){
                            opp.OwnerId = u.id;
                            Account acc = accountMap.get(opp.AccountId);
                            acc.OwnerId = u.id;
                            accListToUpdate.add(acc);
                            Contact con = contactMap.get(opp.Contact2__c);
                            con.OwnerId = u.id;
                            conMapToUpdate.put(con.id,con);
                            //send email to distributor once assigned
                            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                            System.debug('u.email----:'+u.Email);
                            String[] toAddress1 = new String[]{u.Email};
                            String[] toccAddress1 = new String[]{'vinay.ravindranath@henkel.com'};
                            mail1.setToAddresses(toAddress1);
                            //mail1.setCcAddresses(toccAddress1);
                            mail1.setTargetObjectId(cont.id);
                            mail1.setWhatId(opp.id);
                            mail1.setTreatTargetObjectAsRecipient(false);
                            mail1.setSaveAsActivity(false);
                            //mail.setOrgWideEmailAddressId('0D27F000000PD8P');
                            mail1.setTemplateId(etdist.id);
                            //System.debug('mail1 details-----:'+mail1);
                            emailList.add(mail1);
                        }
                    }
                }
            }
        }
       // System.debug('projectListWithWayBill--->>>'+projectListWithWayBill);
        update projectListWithWayBill;
        update accListToUpdate;
        update conMapToUpdate.values();
        if(!Test.isRunningTest()){
            Messaging.sendEmail(emailList);
        }
    }
    
    public void finish(Database.BatchableContext info){
        
    }
}