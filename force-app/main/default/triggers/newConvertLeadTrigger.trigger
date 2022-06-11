/**
 * Last Updated on : 28/10/2020
 * Whats updated : GM /EM code added
*/
trigger newConvertLeadTrigger on Lead (after insert,after update)
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsnewLeadtrgActivated__c && agentAssignment.agenassignmentFlag)
    {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        Map<id,List<Quotation__c>> leadQuotationNumberMap=new Map<Id,List<Quotation__c>>();
        Map<id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>();
        Map<id,List<Customized_Price__c>> leadCustomizedPriceMap=new Map<Id,List<Customized_Price__c>>();
        Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
        for(Lead l :[Select id,Email,(Select id from Quotations__r),(Select id from Refer_Friends__r),(Select id from Request_Callbacks__r),(Select id from Customized_Prices__r) from lead where id in :trigger.new])
        {
           leadQuotationNumberMap.put(l.Id,l.Quotations__r); 
           leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
           leadCustomizedPriceMap.put(l.id,l.Customized_Prices__r);
           leadReferFrndMap.put(l.id,l.Refer_Friends__r);
        }
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
    List<Request__c> requesttoCallbcakInsert=new List<Request__c>();
    List<Customized_Price__c> customizedpricetoInsert=new List<Customized_Price__c>();
    List<Refer_Friend__c> RefertoFriendInsert=new List<Refer_Friend__c>();
    for(Lead L:trigger.new)
    {
        //Request to call and Customize price back logic starts here Refer to Friend
        if(trigger.isInsert)
        {
           System.debug('l.Prospect_Interest_Type__c--- '+l.Prospect_Interest_Type__c);
           if(l.Prospect_Interest_Type__c=='Request a callback' && l.Request_Callback_Product__c!=null)
           {
               Request__c req=new Request__c();
               req.Lead_Name__c=l.id;
               req.Product_Name__c=l.Request_Callback_Product__c;
               req.Product_Image_Link__c=l.Request_Callback_Product_Link__c;
               req.Product_SKU__c=l.requestcallback_sku__c;
               req.Product_Page_Link__c=l.Request_Callback_Product_Page_Link__c;
               req.Product_Details__c=l.Request_Callback_Product_Details__c;
               req.Lead_Email__c=l.Email;
               //req.CC_Status__c='mql';
               if(leadRequestCallBackMap.containsKey(l.id))
               {
                   if(leadRequestCallBackMap.get(l.id).size()>0)
                   {
                     req.Sent_First_Mail__c=true;  
                   }
               }
               requesttoCallbcakInsert.add(req);
           }
           if(l.Prospect_Interest_Type__c=='Customized Price' && l.Customized_Price_Product__c!=null)
           {
               Customized_Price__c cusprice=new Customized_Price__c();
               cusprice.Lead_Name__c=l.id;
               cusprice.Expect_price_per_piece__c=l.Customized_Price_Expect_price_per_piece__c;
               cusprice.Product_Page_Link__c=l.Customized_Price_Product_Link__c;
               cusprice.Product_Details__c=l.Customized_Price_Product_Details__c;
               cusprice.Product_Link__c=l.Customized_Price_Product_Link__c;
               cusprice.Product_Name__c=l.Customized_Price_Product__c;
               cusprice.Quantity__c=l.Customized_Price_Quantity__c;
               cusprice.SKU__c=l.Customized_Price_SKU__c;
               cusprice.lead_email__c=l.Email;
               //cusprice.CC_Status__c='mql';
               if(leadCustomizedPriceMap.containsKey(l.id))
               {
                   if(leadCustomizedPriceMap.get(l.id).size()>0)
                   {
                     cusprice.Sent_First_Mail__c=true;  
                   }
               }
               customizedpricetoInsert.add(cusprice);
           }
           if(l.Prospect_Interest_Type__c=='Refer to Friend' && l.Refer_A_Friend_Product__c!=null)
           {
              Refer_Friend__c ref=new Refer_Friend__c();
              ref.Lead_Name__c=l.id;
              ref.Product_Details__c=l.Refer_A_Friend_Product_Details__c;
              ref.Product_Link__c=l.Refer_A_Friend_Product_Link__c;
              ref.Product_Name__c=l.Refer_A_Friend_Product__c;
              ref.Referred_By__c=l.Referred_By__c;
              ref.SKU__c=l.Refer_A_Friend_SKU__c;
              ref.Subject__c=l.Refer_a_friend_Subject__c;
              ref.Lead_Email__c=l.Email;
              //ref.CC_Status__c='mql';
              if(leadReferFrndMap.containsKey(l.id))
               {
                   if(leadReferFrndMap.get(l.id).size()>0)
                   {
                     ref.Sent_First_Mail__c=true;  
                   }
               }
              RefertoFriendInsert.add(ref); 
           }
        }
        
        if(trigger.isUpdate)
        {
            /*********************************************/
            if((l.Request_Callback_Product__c != trigger.oldMap.get(l.Id).Request_Callback_Product__c) && !l.isconverted)
            {
               Request__c req=new Request__c();
               req.Lead_Name__c=l.id;
               req.Product_Name__c=l.Request_Callback_Product__c;
               req.Product_Image_Link__c=l.Request_Callback_Product_Link__c;
               req.Product_SKU__c=l.requestcallback_sku__c;
               req.Product_Page_Link__c=l.Request_Callback_Product_Page_Link__c;
               req.Product_Details__c=l.Request_Callback_Product_Details__c;
               req.Lead_Email__c=l.Email;
               //req.CC_Status__c='mql';
               if(leadRequestCallBackMap.containsKey(l.id))
               {
                   if(leadRequestCallBackMap.get(l.id).size()>0)
                   {
                     req.Sent_First_Mail__c=true;  
                   }
               }
               requesttoCallbcakInsert.add(req);
            }
            if((l.Customized_Price_Product__c != trigger.oldMap.get(l.Id).Customized_Price_Product__c) && !l.isconverted)
            {
                Customized_Price__c cusprice=new Customized_Price__c();
               cusprice.Lead_Name__c=l.id;
               cusprice.Expect_price_per_piece__c=l.Customized_Price_Expect_price_per_piece__c;
               cusprice.Product_Page_Link__c=l.Customized_Price_Product_Link__c;
               cusprice.Product_Details__c=l.Customized_Price_Product_Details__c;
               cusprice.Product_Link__c=l.Customized_Price_Product_Link__c;
               cusprice.Product_Name__c=l.Customized_Price_Product__c;
               cusprice.Quantity__c=l.Customized_Price_Quantity__c;
               cusprice.SKU__c=l.Customized_Price_SKU__c;
                cusprice.Lead_Email__c=l.Email;
                //cusprice.CC_Status__c='mql';
                if(leadCustomizedPriceMap.containsKey(l.id))
               {
                   if(leadCustomizedPriceMap.get(l.id).size()>0)
                   {
                     cusprice.Sent_First_Mail__c=true;  
                   }
               }
                customizedpricetoInsert.add(cusprice);
            }
            if((l.Refer_A_Friend_Product__c != trigger.oldMap.get(l.Id).Refer_A_Friend_Product__c) && !l.isconverted)
            {
                Refer_Friend__c ref=new Refer_Friend__c();
                ref.Lead_Name__c=l.id;
                ref.Product_Details__c=l.Refer_A_Friend_Product_Details__c;
                ref.Product_Link__c=l.Refer_A_Friend_Product_Link__c;
                ref.Product_Name__c=l.Refer_A_Friend_Product__c;
                ref.Referred_By__c=l.Referred_By__c;
                ref.SKU__c=l.Refer_A_Friend_SKU__c;
                ref.Subject__c=l.Refer_a_friend_Subject__c;
                ref.Lead_Email__c=l.Email;
                //ref.CC_Status__c='mql';
                if(leadReferFrndMap.containsKey(l.id))
                {
                    if(leadReferFrndMap.get(l.id).size()>0)
                    {
                        ref.Sent_First_Mail__c=true;  
                    }
                }
                RefertoFriendInsert.add(ref); 
            }
        }
        //Request to call back and Customize price logic ends here
        
        LeadMapOpp.put(L.id, L); 
    }
    for(Lead l: trigger.new)
    {
        if((l.Type_of_Enquiry__c=='request_a_visit' || l.Type_of_Enquiry__c=='general_inquiry' || l.Type_of_Enquiry__c=='customer_service_related')||//Contact US
           (l.Street != null && /*l.pi__score__c > 75 &&*/ l.Prospect_Interest_Type__c == 'Sample Requested' &&( l.CC_Status__c == 'mql'|| l.CC_Status__c == NULL ) )|| //Sample Requested
           (l.Prospect_Interest_Type__c == 'Offer' && Trigger.isInsert)||//Offer 
           (l.Prospect_Interest_Type__c == 'Services' && l.Flag_Services__c == true)||//Services
           ((l.Prospect_Interest_Type__c == 'Webinar' && l.Industry!=NULL && l.flag_webinar__c==True)||
            (l.Prospect_Interest_Type__c == 'Webinar' && l.Industry!=NULL && 
             (l.Is_Webinar_Attended__c == true || l.Is_Webinar_Attended1__c == true 
              || l.Is_Webinar_Attended2__c == true || l.Is_Webinar_Attended3__c == true 
              ||  l.Is_Webinar_Attended4__c == true || l.Is_recorded_webinar_attended__c == true 
              || l.Is_recorded_webinar_attended1__c == true || l.Is_recorded_webinar_attended2__c == true 
              || l.Is_recorded_webinar_attended3__c == true || l.Is_recorded_webinar_attended4__c == true))&&
            (l.Webinar_Id__c!=null||l.Webinar_Id_1__c!=null||l.Webinar_Id_2__c!=null||
             l.Webinar_Id_3__c!=null||l.Webinar_Id_4__c!=null)) || //Webinar 
           (l.GM_Form_Type__c!=null || l.Flag_GM_Design_Guide__c || l.Flag_Get_A_Demo__c)
          )       
          {
            LeadToPostal.put(l.id,l.PostalCode);
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(l.id);                
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            /*if(l.Prospect_Interest_Type__c == 'Webinar' ||(l.Prospect_Interest_Type__c=='Sample Requested' && l.Flag_Webinar__c==true))
            {  
                Leadconvert.setDoNotCreateOpportunity(true);
            }*/
            
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
    //added by Ajinkya for FBZapier lead sent to henkel website
    for(Lead l: trigger.new)
    {
        if((trigger.isInsert)&&(l.IsConverted != true)&&(l.LeadSource=='Facebook_Zapier' || l.LeadSource=='Linkedin') && l.Which_Product_Sent__c != NULL)// need to change as per given field
        {
            
            FBSamplingAPIcallout.calloutWebservice(l.email,l.phone,l.Which_Product_Sent__c,l.lastname,l.company,l.postalcode);
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
    List<Quotation__c> quotationstoUpdate=new List<Quotation__c>();
    List<Request__c> requesttoUpdate=new List<Request__c>();
    List<Customized_Price__c> customizetoUpdate=new List<Customized_Price__c>();
    List<Refer_Friend__c> refertoUpdate=new List<Refer_Friend__c>();
    for(Database.LeadConvertResult result : lcr)
    {
        Id contId = result.getContactId();
        Contact cont = new Contact(id=contId);
        contIdSet.add(contId);
        oppIdSet.add(result.getOpportunityId());
        if(leadQuotationNumberMap.containsKey(result.getLeadId()))
        {
            Integer quotationNumber=leadQuotationNumberMap.get(result.getLeadId()).size();
            if(quotationNumber>0)
            {
                for(Quotation__c q : leadQuotationNumberMap.get(result.getLeadId()))
                {
                    q.Customer_Contact__c=contId;
                    quotationstoUpdate.add(q);
                }
            }
        }
        if(leadRequestCallBackMap.containsKey(result.getLeadId()))
        {
            Integer requesttoCallBack=leadRequestCallBackMap.get(result.getLeadId()).size();
            if(requesttoCallBack>0)
            {
               for(Request__c req : leadRequestCallBackMap.get(result.getLeadId()))
               {
                   req.Contact_Name__c=contId;
                   requesttoUpdate.add(req);
               }
            }
        }
        if(leadCustomizedPriceMap.containsKey(result.getLeadId()))
        {
           Integer Customizepricecnt =leadCustomizedPriceMap.get(result.getLeadId()).size();
            if(Customizepricecnt>0)
            {
               for(Customized_Price__c req : leadCustomizedPriceMap.get(result.getLeadId()))
               {
                   req.Contact_Name__c=contId;
                   customizetoUpdate.add(req);
               }
            } 
        }
        if(leadReferFrndMap.containsKey(result.getLeadId()))
        {
           Integer refertoFrndcnt =leadReferFrndMap.get(result.getLeadId()).size();
            if(refertoFrndcnt>0)
            {
               for(Refer_Friend__c req : leadReferFrndMap.get(result.getLeadId()))
               {
                   req.Contact_Name__c=contId;
                   refertoUpdate.add(req);
               }
            }  
        }
    }
    Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customers').getRecordTypeId();
    //Contact cont = [SELECT id FROM Contact Limit 1];
    MAP<ID,ID> oppContactMap = new MAP<ID,ID>(); // <ContactID:OpportunityID>
    MAP<ID,String> oppPincodeMap = new MAP<ID,String>();
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT id,Lead_classification_basis_value__c,
                                                          Webinar_Video_total_duration__c,Contact_email__c,
                                                          Assigned_IST_User__c,stageName,Prospect_Interest_Type__c,
                                                          Distributor__c,Webinar_Id__c,Contact2__c,Webinar_Name__c,
                                                          Webinar_Timestamp__c,Flag_Webinar__c
                                                          FROM Opportunity 
                                                          WHERE id IN :oppIdSet]); 
    List<Contact> contList = [SELECT id,Name,MailingPostalCode,Webinar_Video_total_duration__c,Account.Name FROM Contact WHERE RecordType.Name = 'Distributors' AND ID NOT IN :contIdSet];
    List<User> userList = [SELECT id,Pin_codes__c,street,state,country,Distributor__c,city,Email,Contact.Account.Name,Contact.name,Phone,postalcode FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
    Map<String,String> pinCodeDistributorMap = new Map<String,String>();
    Map<String,user> pinCodeUserMap = new Map<String,user>();
    Map<Id,Contact> contactMap=new Map<Id,Contact>([Select id,Lead_classification_basis_value__c,Webinar_Video_total_duration__c from contact where id in :contIdSet]);
    for(User u  : userList)
    {
        if(u.Pin_codes__c!=null)
            pinCodeUserMap.put(u.Pin_codes__c,u); 
    }
  
    for(Contact cont1 : contList)
    {
        if(!pinCodeDistributorMap.containsKey(cont1.MailingPostalCode))
        {
            pinCodeDistributorMap.put(cont1.MailingPostalCode,cont1.Account.Name);
        }
    }   

    Map<Id,Id> leadToAccountIdMap = new Map<Id,Id>();
    List<Account> accListToUpdate = new List<Account>();
    MAP<ID,Account> accMapTOUpdate = new MAP<ID,Account>();
    Map<Id,Id> leadToContactIdMap = new Map<Id,Id>();
    MAP<ID,Contact> ContactMapTOUpdate = new MAP<ID,Contact>();
    List<Contact> contListToUpdate = new List<Contact>();
    List<task> contactustaskstoInsert=new List<task>();
    List<task> WebinartaskstoInsert=new List<task>();
    User IstUser; 
    //map<Id,Lead> leadMap=new map<Id,Lead>([Select id,name,IM_Status__c from Lead]);
    List<Webinar__c> webinarList=new List<Webinar__c>();
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
            Lead lObj=[Select id,IM_Status__c,Prospect_Interest_Type__c,GM_Form_Type__c,GM_Design_Guide_Name__c,GM_Design_Guide_PDF_Link__c,Flag_Get_A_Demo__c,Flag_GM_Design_Guide__c,Webinar_Id_1__c,Is_recorded_webinar_attended1__c,Is_Live_Webinar_Attended__c,Flag_Live_Webinar__c,Webinar_Machine1__c,Is_Webinar_Attended1__c,Webinar_Id__c,Webinar_Id_2__c,Webinar_Id_3__c,Webinar_Id_4__c,
                       Pincode_Status__c,Indiamart_QTYPE__c from Lead where id=:result.getLeadId()];
            oppMap.get(oppID).Name = 'DG-AG-SU-Product-Application';
            oppMap.get(oppID).Contact2__c = result.getContactId();    
            oppMap.get(oppID).Status__c = 'Active';
            oppMap.get(oppID).from_Code_updated_Inserted__c='Update from newConvertLeadTrigger Line 350';
            if(oppMap.get(oppID).Prospect_Interest_Type__c == 'Sample Requested' && lObj.Indiamart_QTYPE__c == NULL )
            {
                oppMap.get(oppID).SampleRequested_Timestamp__c = System.now();
                oppmap.get(oppID).Flag_Sample_Requested__c=true;  
            }
            if(lObj.Prospect_Interest_Type__c == 'GM Design Guide' || lObj.Flag_GM_Design_Guide__c)
            {
                oppMap.get(oppID).stageName=label.stage_15;
                oppMap.get(oppID).Probability=15;
            }
            if(lObj.Prospect_Interest_Type__c == 'Get A Demo' || lObj.Flag_Get_A_Demo__c)
            {
                oppMap.get(oppID).stageName=label.stage_30;
                oppMap.get(oppID).Probability=30;
            }
            for(user u:ISTuserList)
            {
                if(u.Pin_codes__c != null)
                {
                    pincodeStr = u.Pin_codes__c;
                   
                    if(!String.isBlank(pincodeStr) && pincodeStr.contains(pin) )
                    {

                        oppmap.get(oppID).Assigned_IST_User__c=u.id;
                        IstUser=u;
                        break;
                    }
                    else
                    {
                        oppmap.get(oppID).Assigned_IST_User__c=label.Default_IST;
                    }
                }
                
            }
            if(oppMap.get(oppID).Prospect_Interest_Type__c == 'Webinar')
            {
              oppMap.get(oppID).Flag_Webinar__c=true;
              oppMap.get(oppID).Webinar_Timestamp__c=system.now();
              Task t4 = new Task();
                if(contactMap.containsKey(result.getContactId()))
                t4.Subject = 'Understand customer requirements - Webinar -'+contactMap.get(result.getContactId()).Lead_classification_basis_value__c+'-'+contactMap.get(result.getContactId()).Webinar_Video_total_duration__c;
                else
                t4.Subject = 'Understand customer requirements - Webinar';
                t4.WhatId = result.getOpportunityId();
                if(IstUser!=null)
                t4.OwnerId = IstUser.id;
                //t2.ActivityDate = opp.SampleReceivedOn__c + 1;
                t4.Customer_Email_Id__c=oppMap.get(oppID).Contact_email__c; 
                t4.Status = 'Open';
                t4.Priority = 'High';
                t4.Original_Due_Date__c =system.today()+1;
                // t4.Customer_Email_Id__c=oppmap.get(opp.id);
                t4.ActivityDate=system.today()+1;
                // System.debug(' Task--0---'+t4);
                WebinartaskstoInsert.add(t4);
              if(lobj.Webinar_Id_1__c!=null || lObj.Flag_Live_Webinar__c)
              {
                  oppMap.get(oppID).Webinar_Name__c=lobj.Webinar_Machine1__c;
                  oppMap.get(oppID).Webinar_Id__c=lobj.Webinar_Id_1__c;
                  Webinar__c webinar=new Webinar__c();
                  webinar.name=lobj.Webinar_Machine1__c;
                  webinar.Webinar_Id__c=lobj.Webinar_Id_1__c;
                  webinar.Customer_Contact__c=result.getContactId();
                  webinar.Related_Project__c=result.getOpportunityId();
                  webinarList.add(webinar);
                  if(lObj.Is_Webinar_Attended1__c || lObj.Is_recorded_webinar_attended1__c )
                  {
                     oppMap.get(oppID).stageName=label.Stage_30;
                     oppMap.get(oppID).Probability=30;
                     oppMap.get(oppID).Is_Webinar_Attended__c=true;
                     
                  }
                  if(lObj.Is_Live_Webinar_Attended__c)
                  {
                     oppMap.get(oppID).stageName=label.Stage_30;
                     oppMap.get(oppID).Probability=30;
                    // oppMap.get(oppID).Is_Webinar_Attended__c=true;
                     
                  }
                  
              }
              
              
            }
            
            if(LeadMapOpp.get(result.getLeadId()).Type_of_Enquiry__c=='request_a_visit')
            {
                oppMap.get(oppID).StageName=label.Stage_30;
                oppMap.get(oppID).Probability=30;
                Task tus1 = new Task();
                    tus1.Subject = 'Confirm trial date with customer';
                    tus1.WhatId = oppMap.get(oppID).Id;
                    if(IstUser!=null)
                    tus1.OwnerId = IstUser.id;
                    tus1.Customer_Email_Id__c=oppMap.get(oppID).Contact_email__c ; 
                    tus1.Status = 'Open';
                    tus1.Priority = 'High';
                    tus1.Original_Due_Date__c =system.today()+1;
                    tus1.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus1);                                   
                
            }
            if(LeadMapOpp.get(result.getLeadId()).Type_of_Enquiry__c=='general_inquiry')
            {
                    Task tus2 = new Task();
                    tus2.Subject = 'Understand customer’s enquiry';
                    tus2.WhatId = oppMap.get(oppID).Id;
                    if(IstUser!=null)
                    tus2.OwnerId = IstUser.id;
                    tus2.Customer_Email_Id__c=oppMap.get(oppID).Contact_email__c ; 
                    tus2.Status = 'Open';
                    tus2.Priority = 'High';
                    tus2.Original_Due_Date__c =system.today()+1;
                    tus2.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus2);
            }
            if(LeadMapOpp.get(result.getLeadId()).Type_of_Enquiry__c!=null )
            {
                oppMap.get(oppID).Flag_Contact_Us__c=true;
                oppMap.get(oppID).Contact_Us_Timestamp__c=System.now();
            }
            if(lObj!=null)
            {
                if(lObj.IM_Status__c=='Intent to buy')
                {
                    oppMap.get(oppID).StageName=label.Stage_30;
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
                           // oppMap.get(oppID).Distributor_ace__c = pinCodeUserMap.get(s).Distributor__c;
                            oppMap.get(oppID).OwnerFullName__c= pinCodeUserMap.get(s).Contact.Name;
                            oppMap.get(oppID).OwnerPhone__c= pinCodeUserMap.get(s).Phone;
                            oppMap.get(oppID).OwnerEmail__c= pinCodeUserMap.get(s).Email;
                            
                            if(String.isBlank(lobj.Pincode_Status__c))
                            {
                                oppMap.get(oppID).Pincode_Status__c = '1';   
                            }
                            
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
                            
                            if(String.isBlank(lobj.Pincode_Status__c))
                            {
                                oppMap.get(oppID).Pincode_Status__c = '2'; 
                            }
                        }
                    }     
                }  
            }
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
    if(quotationstoUpdate.size()>0)
    {
       update quotationstoUpdate; 
    }
    if(requesttoCallbcakInsert.size()>0)
    {
        Insert requesttoCallbcakInsert;
        List<Request__c> updateRequest=new List<Request__c>();
        for(Request__c req : [Select id,CC_Status__c from Request__c where id in :requesttoCallbcakInsert])
        {
           req.CC_Status__c='mql';
           updateRequest.add(req);
        }
        update updateRequest; 
    }
    if(customizedpricetoInsert.size()>0)
    {
        Insert customizedpricetoInsert;
        List<Customized_Price__c> customizedPriceUpdate=new List<Customized_Price__c>();
        for(Customized_Price__c cust : [Select id,CC_Status__c from Customized_Price__c where id in:customizedpricetoInsert])
        {
           cust.CC_Status__c='mql';
           customizedPriceUpdate.add(cust);
        }
        update customizedPriceUpdate;
    }
    if(customizetoUpdate.size()>0)
    {
        update customizetoUpdate;
        List<Customized_Price__c> customizedPriceUpdate=new List<Customized_Price__c>();
        for(Customized_Price__c cust : [Select id,CC_Status__c from Customized_Price__c where id in:customizetoUpdate])
        {
           cust.CC_Status__c='mql';
           customizedPriceUpdate.add(cust);
        }
        update customizedPriceUpdate;
    }
    if(requesttoUpdate.size()>0)
    {
       update requesttoUpdate;
       List<Request__c> updateRequest=new List<Request__c>();
        for(Request__c req : [Select id,CC_Status__c from Request__c where id in :requesttoUpdate])
        {
           req.CC_Status__c='mql';
           updateRequest.add(req);
        }
        update updateRequest;
    }
    if(refertoUpdate.size()>0)
    {
        Update refertoUpdate;
    }
    if(RefertoFriendInsert.size()>0)
    {
        Insert RefertoFriendInsert;
    }
    if(contactustaskstoInsert.size()>0)
    {
      Insert contactustaskstoInsert;  
    }
    if(webinarList.size()>0)
    {
        Insert webinarList;
    }
    if(WebinartaskstoInsert.size()>0)
    {
        Insert WebinartaskstoInsert;
    }
    system.debug(leadOfferMap);
    }
    
    
}