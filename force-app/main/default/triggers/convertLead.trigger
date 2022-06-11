trigger convertLead on Lead (after insert,after update)
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsLeadTriggerActivated__c)
    {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
    //MAP<ID,GroupMember> membersMap = new MAP<ID,GroupMember>();
    List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
    Map<Id,String> LeadToPostal = new Map<Id,String>();
    Map<Id,Lead> LeadMapOpp=new Map<ID,Lead>();
    MAP<ID,Offer__c> leadOfferMap = new MAP<Id,Offer__c>();
    Set<Id> contIdSet = new Set<Id>();
    Set<Id> accIdSet = new Set<Id>();
    List<User> ISTuserList = [SELECT id,Pin_codes__c,Email FROM User WHERE Profile.id =: Label.IST_Profile];
    //string pin;
    string pincodestr; 
    //List<OpportunityTeamMember> tmList = new List<OpportunityTeamMember>();
    Integer score = Integer.ValueOf(Label.Score_Value_to_convert_Lead);
    for(Lead L:trigger.new)
    {
        LeadMapOpp.put(L.id, L); 
    }
    for(Lead l: trigger.new)
    {
        if((l.Type_of_Enquiry__c=='request_a_visit' || l.Type_of_Enquiry__c=='general_inquiry' || l.Type_of_Enquiry__c=='customer_service_related')||
           (l.Street != null && l.pi__score__c > 75 && l.Prospect_Interest_Type__c == 'Sample Requested' &&( l.CC_Status__c == 'mql'|| l.CC_Status__c == NULL ) )|| 
           (l.Prospect_Interest_Type__c == 'Offer' && Trigger.isInsert)||
           ((l.Prospect_Interest_Type__c == 'Webinar' && l.Industry!=NULL && (l.Is_Webinar_Attended__c == true || l.Is_Webinar_Attended1__c == true || l.Is_Webinar_Attended2__c == true || l.Is_Webinar_Attended3__c == true ||  l.Is_Webinar_Attended4__c == true || l.Is_recorded_webinar_attended__c == true || l.Is_recorded_webinar_attended1__c == true || l.Is_recorded_webinar_attended2__c == true || l.Is_recorded_webinar_attended3__c == true || l.Is_recorded_webinar_attended4__c == true))&&(l.Webinar_Id__c!=null||l.Webinar_Id_1__c!=null||l.Webinar_Id_2__c!=null||l.Webinar_Id_3__c!=null||l.Webinar_Id_4__c!=null)))        {
            LeadToPostal.put(l.id,l.PostalCode);
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(l.id);                
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            if(l.Prospect_Interest_Type__c == 'Webinar' ||(l.Prospect_Interest_Type__c=='Sample Requested' && l.Flag_Webinar__c==true))
            {  
                Leadconvert.setDoNotCreateOpportunity(true);
            }
            
            if(l.Prospect_Interest_Type__c == 'Offer')
            {
                Leadconvert.setDoNotCreateOpportunity(true);
                Offer__c offer = new Offer__c();
                offer.Comment__c = l.pi__comments__c;
                offer.Company_Name__c = l.Company;
                offer.Company_Size__c =l.Company_size__c;
                offer.Designation__c = l.title;
                offer.Email__c = l.Email;
                offer.First_Name__c = l.FirstName;
                offer.Last_Name__c = l.LastName;
                offer.GST__c = l.GST__c;
                offer.GST_Amount__c = l.GST_Amount__c;
                offer.Industry__c = l.Industry;
                offer.Net_Payable_Amount__c = l.Net_Payable_Amount__c;
                offer.Offer_Product__c = l.Offer_Product__c;
                offer.OTP__c = l.OTP__c;
                offer.Pincode_Status__c = l.Pincode_Status__c;
                offer.Role_In_Organisation__c = l.Role_in_organisation__c;
                offer.Quantity__c = l.Quantity__c;
                offer.Total_Amount__c = l.Total_Amount__c;
                offer.MRP_inclusive_of_all_taxes__c = l.MRP_inclusive_of_all_taxes__c;
                offer.Total_price_after_50_discount__c = l.Total_price_after_50_discount__c;
                offer.Phone__c = l.Phone;
                offer.Order_Requested_Date__c = system.today();
                offer.Stauts__c = 'Active';
                if(!leadOfferMap.containsKey(l.id))
                {
                    leadOfferMap.put(l.Id,offer);
                }
            }
            if(l.IsConverted != true)
                MassLeadconvert.add(Leadconvert);
        }
    }
    //added by Ramji for linkedin lead sent to henkel website
    for(Lead l: trigger.new)
    {
        if((trigger.isInsert)&&(l.IsConverted != true)&&(l.Prospect_Interest_Type__c!='Webinar') && (l.LeadSource=='Linkedin' || l.LeadSource=='Facebook') && l.Which_Product_Sent__c == NULL)// need to change as per given field
        {
            LinkedlnWebinarCallout.calloutWebservice(l.email,l.phone,l.LeadSource,l.lastname,l.company,l.postalcode,l.Industry,l.Number_of_Employees_Custom__c);
        }    
    }
    List<Database.LeadConvertResult> lcr = new List<Database.LeadConvertResult>();
    if (!MassLeadconvert.isEmpty()) 
    {
        lcr = Database.convertLead(MassLeadconvert);
    }
    
    Id customerContRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customers').getRecordTypeId();
    List<Contact> conList = new List<Contact>();
    Set<Id> oppIdSet = new Set<Id>();
    for(Database.LeadConvertResult result : lcr)
    {
        Id contId = result.getContactId();
        Contact cont = new Contact(id=contId);
        contIdSet.add(contId);
        oppIdSet.add(result.getOpportunityId());
    }
    Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customers').getRecordTypeId();
    //Contact cont = [SELECT id FROM Contact Limit 1];
    MAP<ID,ID> oppContactMap = new MAP<ID,ID>(); // <ContactID:OpportunityID>
    MAP<ID,String> oppPincodeMap = new MAP<ID,String>();
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT id,Prospect_Interest_Type__c,Distributor__c,Contact2__c FROM Opportunity WHERE id IN :oppIdSet]); 
    List<Contact> contList = [SELECT id,Name,MailingPostalCode,Account.Name FROM Contact WHERE RecordType.Name = 'Distributors' AND ID NOT IN :contIdSet];
    System.debug('contList->>'+contList.size()+contList);
    List<User> userList = [SELECT id,Pin_codes__c,street,state,country,city,Email,Contact.Account.Name,Contact.name,Phone,postalcode FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
    Map<String,String> pinCodeDistributorMap = new Map<String,String>();
    Map<String,user> pinCodeUserMap = new Map<String,user>();
    for(User u  : userList)
    {
        if(u.Pin_codes__c!=null)
            pinCodeUserMap.put(u.Pin_codes__c,u); 
    }
    // System.debug('pinCodeUserMap '+pinCodeUserMap);
    for(Contact cont1 : contList)
    {
        if(!pinCodeDistributorMap.containsKey(cont1.MailingPostalCode))
        {
            pinCodeDistributorMap.put(cont1.MailingPostalCode,cont1.Account.Name);
        }
    }   
    system.debug('pinCodeUserMap++ : '+pinCodeUserMap);
    Map<Id,Id> leadToAccountIdMap = new Map<Id,Id>();
    List<Account> accListToUpdate = new List<Account>();
    MAP<ID,Account> accMapTOUpdate = new MAP<ID,Account>();
    Map<Id,Id> leadToContactIdMap = new Map<Id,Id>();
    MAP<ID,Contact> ContactMapTOUpdate = new MAP<ID,Contact>();
    List<Contact> contListToUpdate = new List<Contact>();
    //map<Id,Lead> leadMap=new map<Id,Lead>([Select id,name,IM_Status__c from Lead]);
    for(Database.LeadConvertResult result : lcr)
    {
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String pin = LeadToPostal.get(result.getLeadId());
        /*added bt ramji for IST***************/
        
        /********************/
        ID oppId = result.getOpportunityId() != null ? result.getOpportunityId() : null ;
        leadToAccountIdMap.put(result.getLeadId(),result.getAccountId());
        leadToContactIdMap.put(result.getLeadId(),result.getContactId());
        if(oppId != null && oppMap.containsKey(oppId))
        {
            Lead lObj=[Select id,IM_Status__c,Pincode_Status__c,Indiamart_QTYPE__c from Lead where id=:result.getLeadId()];
            oppMap.get(oppID).Name = 'DG-AG-SU-Product-Application';
            oppMap.get(oppID).Contact2__c = result.getContactId();    
            oppMap.get(oppID).Status__c = 'Active';
            
            if(oppMap.get(oppID).Prospect_Interest_Type__c == 'Sample Requested' && lObj.Indiamart_QTYPE__c == NULL )
            {
                
                oppMap.get(oppID).SampleRequested_Timestamp__c = System.now();
                oppmap.get(oppID).Flag_Sample_Requested__c=true;  
            }
            if(LeadMapOpp.get(result.getLeadId()).Type_of_Enquiry__c=='request_a_visit')
            {
                oppMap.get(oppID).StageName='Trial Scheduled/Intent to buy';
                oppMap.get(oppID).Probability=30;
            }
            if(LeadMapOpp.get(result.getLeadId()).Type_of_Enquiry__c!=null )
            {
                oppMap.get(oppID).Flag_Contact_Us__c=true;
            }
            for(user u:ISTuserList)
            {
                
                if(u.Pin_codes__c != null){
                    pincodeStr = u.Pin_codes__c;
                   // System.debug('pincodeStr--->>>'+u.id+' '+pincodeStr);
                   /* Opportunity oop2 = [Select id,Source_Indiamart__c from Opportunity where id=:oppId limit 1];
                                            system.debug('In if loop-----------------------------'+oop2.Source_Indiamart__c);

                    if(lObj.Source_Indiamart__c == 'PNS')
                    {
                        oppmap.get(oppID).Assigned_IST_User__c=label.IST_User_ID;
                        break;
                    }*/
                    if(!String.isBlank(pincodeStr) && pincodeStr.contains(pin))
                    {
                        oppmap.get(oppID).Assigned_IST_User__c=u.id;
                        break;
                    }
                    else
                    {
                        oppmap.get(oppID).Assigned_IST_User__c=label.Default_IST;
                    }
                }
                
            }
            if(lObj!=null)
            {
                if(lObj.IM_Status__c=='Intent to buy')
                {
                    oppMap.get(oppID).StageName='Trial Scheduled/Intent to buy';
                }  
            }
            if(!test.isRunningTest())
            {
                for(String s :pinCodeUserMap.keySet())
                {
                    if(pin!=null)
                    {
                        if(s!=null && s.contains (pin))     
                        {
                            
                            oppMap.get(oppID).Distributor_On_Project__c = pinCodeUserMap.get(s).Contact.Account.Name;
                            oppMap.get(oppID).OwnerFullName__c= pinCodeUserMap.get(s).Contact.Name;
                            oppMap.get(oppID).OwnerPhone__c= pinCodeUserMap.get(s).Phone;
                            oppMap.get(oppID).OwnerEmail__c= pinCodeUserMap.get(s).Email;
                            //System.debug('i AM IN IF oppMap.get(oppID).Pincode_Status__c '+oppMap.get(oppID).Pincode_Status__c);
                            if(String.isBlank(lobj.Pincode_Status__c))
                            {
                                oppMap.get(oppID).Pincode_Status__c = '1';   
                            }
                            //User uu = [select Id from User where ContactId =: pinCodeUserMap.get(s).Contact.Id];
                            if(lObj!=null)
                            {
                                if(lObj.IM_Status__c=='Intent to buy' || lObj.IM_Status__c=='More information on products')
                                {
                                    oppMap.get(oppID).OwnerId__c=pinCodeUserMap.get(s).id;
                                    oppMap.get(oppID).OwnerId= pinCodeUserMap.get(s).id;
                                }
                                
                            }
                            String str='';
                            str=str+ pinCodeUserMap.get(s).Street+',';
                            str=str+pinCodeUserMap.get(s).City+',';
                            str=str+pinCodeUserMap.get(s).State+',';
                            str=str+pinCodeUserMap.get(s).PostalCode+',';
                            str=str+pinCodeUserMap.get(s).Country;
                            oppMap.get(oppID).Owner_Address__c=str;
                        }
                        else
                        {
                            //System.debug('i AM IN IF oppMap.get(oppID).Pincode_Status__c '+oppMap.get(oppID).Pincode_Status__c);
                            if(String.isBlank(lobj.Pincode_Status__c))
                            {
                                oppMap.get(oppID).Pincode_Status__c = '2'; 
                            }
                        }
                    }     
                }  
            }
            
            
            
            /*OpportunityTeamMember tm= new OpportunityTeamMember();
if(!test.isRunningTest())
{
tm.UserId = membersMap.values()[0].UserOrGroupId;
tm.OpportunityId = oppID;
tm.TeamMemberRole = 'Sales Manager';
//tm.OpportunityAccessLevel = 'Read/Write';
tmList.add(tm);
}*/
        }
        if(leadOfferMap.containsKey(result.getLeadId()))
        {
            leadOfferMap.get(result.getLeadId()).Customer_Contact__c = result.getContactId();
            leadOfferMap.get(result.getLeadId()).Customer__c = result.getAccountId();
            if(pinCodeDistributorMap.containsKey(pin))
            {
                leadOfferMap.get(result.getLeadId()).Distributor__c = pinCodeDistributorMap.get(pin);
            }
            for(User u: userList)
            {
                String pincodeStr1 = u.Pin_codes__c;
                if(pin!=null)
                    if(pincodeStr1 != null && pincodeStr1 != '' && pincodeStr1.contains(pin))
                {
                    leadOfferMap.get(result.getLeadId()).OwnerId = u.id;
                    String accId = leadToAccountIdMap.get(result.getLeadId());
                    Account acc = new Account(id = accId);
                    acc.OwnerId = u.id;
                    acc.RecordTypeId = customerRecordTypeId;
                    if(!accMapTOUpdate.containskey(accId))
                    {
                        accMapToUpdate.put(accID,Acc);
                    }
                    String contId = leadToContactIdMap.get(result.getLeadId());
                    Contact cont2 = new Contact(id=contId);
                    cont2.OwnerId = u.id;
                    cont2.RecordTypeId = customerContRecordTypeId;
                    if(!ContactMapTOUpdate.containskey(contId))
                    {
                        ContactMapTOUpdate.put(contId,cont2);
                    }
                }
            } 
        }
        else
        {
            String accId = leadToAccountIdMap.get(result.getLeadId());
            Account acc = new Account(id = accId);
            acc.RecordTypeId = customerRecordTypeId;
            if(!accMapTOUpdate.containskey(accId))
            {
                accMapToUpdate.put(accID,Acc);
            }
            String contId = leadToContactIdMap.get(result.getLeadId());
            Contact cont2 = new Contact(id=contId);
            cont2.RecordTypeId = customerContRecordTypeId;
            if(!ContactMapTOUpdate.containskey(contId))
            {
                ContactMapTOUpdate.put(contId,cont2);
            }
        }
    }  
    
    upsert leadOfferMap.values();
    update oppMap.values();
    accListToUpdate = accMapTOUpdate.values();
    /*if(!tmList.isEmpty() ||tmList != null )
{
insert tmList;
}*/
    if(!accListToUpdate.isEmpty() || accListToUpdate != null)
    {
        update accListToUpdate;    
    }
    contListToUpdate = ContactMapTOUpdate.values();
    if(!contListToUpdate.isEmpty() || contListToUpdate != null)
    {
        update contListToUpdate;    
    }
    system.debug(leadOfferMap);
    
        
    }
}