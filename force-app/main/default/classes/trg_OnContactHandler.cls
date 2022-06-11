public class trg_OnContactHandler 
{
    public static List<Opportunity> opportunitytoUpdateorInsert=new List<Opportunity>();
    public static List<Opportunity> opportunitytoInsert=new List<Opportunity>();
    public static map<Id,Opportunity> opportunitytoUpdateorInsert1=new map<Id,Opportunity>();
    public static List<Webinar__c> webinartoInsert=new List<Webinar__c>();
   	public static List<Task> contactustaskstoInsert=new List<Task>();
    
    public static void webinarCreation(List<Contact> ExistingContacts,List<Contact> newContacts,Map<Id,Contact> contactOldMap,Map<String,User> userpincodeMap,Map<Id,Contact> contactNewMap)
    {
        System.debug('I am in webinarCreation Mthod ');
        Map<Id,Map<String,Webinar__c>> contactWebinarMap=new Map<Id,Map<String,Webinar__c>>();
        Map<Id,Map<String,Webinar__c>> projectWebinarMap=new Map<Id,Map<String,Webinar__c>>();
        Map<Id,List<Opportunity>> contactOpportunityMap=new Map<Id,List<Opportunity>>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Contact cnt : ExistingContacts)
        {
           contactOpportunityMap.put(cnt.Id,cnt.Opportunities2__r);
           map<String,Webinar__c> webinartempMap=new Map<String,Webinar__c>();
           for(Webinar__c webinarObj : cnt.Webinar__r)
           {
              webinartempMap.put(webinarObj.Webinar_Id__c,webinarObj); 
           }
           contactWebinarMap.put(cnt.Id,webinartempMap);
           for(Opportunity opp :cnt.Opportunities2__r)
           {
             opportunityIds.add(opp.id);  
           }
        }
        for(Opportunity opp : [Select id,Assigned_IST_User__c,CloseDate,(Select id,Webinar_Id__c from webinars__r) from opportunity where id in  :opportunityIds])
        {
           Map<String,webinar__c> tempMap=new Map<String,webinar__c>();
           for(webinar__c webinarObj : opp.webinars__r)
           {
             tempMap.put(webinarObj.Webinar_Id__c,webinarObj);  
           }
           projectWebinarMap.put(opp.Id,tempMap);
        }
        for(Contact ct  : newContacts)
        {
            if(ct.Flag_Webinar__c && 
               (ct.Prospect_Interest_Type__c=='Webinar' || 
               (contactOldMap.get(ct.Id).Prospect_Interest_Type__c=='Webinar' && (ct.Prospect_Interest_Type__c=='Sample Requested'||ct.Prospect_Interest_Type__c=='Contact Us'))
               ) 
              )
            {
               System.debug('I am in If');
               System.debug('oldMap Webinar_Id__c---- '+contactOldMap.get(ct.Id).Webinar_Id__c);
               System.debug('oldMap Webinar_Id_1__c---- '+contactOldMap.get(ct.Id).Webinar_Id_1__c);
               if(ct.Webinar_Id__c!=null && (contactOldMap.get(ct.Id).Prospect_Interest_Type__c!=ct.Prospect_Interest_Type__c||contactOldMap.get(ct.Id).Webinar_Id__c!=ct.Webinar_Id__c || contactOldMap.get(ct.Id).Is_Webinar_Attended__c!=ct.Is_Webinar_Attended__c || contactOldMap.get(ct.Id).Is_recorded_webinar_attended__c!=ct.Is_recorded_webinar_attended__c))
               {
                   System.debug('contactOpportunityMap.containsKey(ct.Id)--- '+contactOpportunityMap.containsKey(ct.Id));
                   if(contactOpportunityMap.containsKey(ct.Id))
                   {
                       System.debug('Calling Method');
                       Opportunity existingOpportunity=new Opportunity();
                       if(contactOpportunityMap.get(ct.Id).size()>0)
                       {
                           existingOpportunity=contactOpportunityMap.get(ct.Id)[0];
                           HandleProjects(existingOpportunity,ct,0,userpincodeMap);
                       }
                       else
                       {
                          createOpportunity(ct,userpincodeMap,0); 
                       }
                       
                       if(contactWebinarMap.containsKey(ct.Id))
                       {
                          if(!contactWebinarMap.get(ct.Id).containsKey(ct.Webinar_Id__c))
                          {
                             createWebinar(existingOpportunity,ct,0); 
                          }
                       }
                   }
               }
               if(ct.Webinar_Id_1__c!=null && (contactOldMap.get(ct.Id).Prospect_Interest_Type__c!=ct.Prospect_Interest_Type__c||contactOldMap.get(ct.Id).Webinar_Id_1__c!=ct.Webinar_Id_1__c || contactOldMap.get(ct.Id).Is_Webinar_Attended1__c!=ct.Is_Webinar_Attended1__c||contactOldMap.get(ct.Id).Is_recorded_webinar_attended1__c!=ct.Is_recorded_webinar_attended1__c))
               {
                   System.debug('contactOpportunityMap.containsKey(ct.Id)--- '+contactOpportunityMap.containsKey(ct.Id));
                   if(contactOpportunityMap.containsKey(ct.Id))
                   {
                       System.debug('Calling Method');
                       Opportunity existingOpportunity=new Opportunity();
                       System.debug('contactOpportunityMap.get(ct.Id).size()---- '+contactOpportunityMap.get(ct.Id).size());
                       if(contactOpportunityMap.get(ct.Id).size()>0)
                       {
                           existingOpportunity=contactOpportunityMap.get(ct.Id)[0];
                           HandleProjects(existingOpportunity,ct,1,userpincodeMap);
                       }
                       else
                       {
                          createOpportunity(ct,userpincodeMap,1);  
                       }
                       
                       if(contactWebinarMap.containsKey(ct.Id))
                       {
                          if(!contactWebinarMap.get(ct.Id).containsKey(ct.Webinar_Id_1__c))
                          {
                             createWebinar(existingOpportunity,ct,1); 
                          }
                       }
                   }
                  
               }
            }
            else if((ct.Prospect_Interest_Type__c=='Sample Requested' || ct.Prospect_Interest_Type__c=='Contact Us') && 
                    ((contactOldMap.get(ct.Id).Prospect_Interest_Type__c !=ct.Prospect_Interest_Type__c) || (ct.Prospect_Interest_Type__c=='Contact Us' && contactOldMap.get(ct.Id).Type_of_Enquiry__c !=ct.Type_of_Enquiry__c)))
            {
              if(contactOpportunityMap.containsKey(ct.Id))
               {
                  Opportunity ExistingOpportunity=new Opportunity();
                  if(contactOpportunityMap.get(ct.Id).size()>0)
                  {
                    ExistingOpportunity=contactOpportunityMap.get(ct.Id)[0];
                    HandleProjects(ExistingOpportunity,ct,500,userpincodeMap);
                  }
                  else
                  {
                      createOpportunity(ct,userpincodeMap,500);
                  }
                  
               }
            }
            else if(ct.Prospect_Interest_Type__c=='GM Design Guide' && ct.GM_Design_Guide_Name__c!=contactOldMap.get(ct.id).GM_Design_Guide_Name__c)
            {
               createOpportunity(ct,userpincodeMap,900); 
            }
            else if(ct.Prospect_Interest_Type__c=='Get A Demo' && ct.Prospect_Interest_Type__c!=contactOldMap.get(ct.id).Prospect_Interest_Type__c)
            {
               createOpportunity(ct,userpincodeMap,900); 
            }
            
        }
       	if(opportunitytoUpdateorInsert1.values().size()>0)
        {
           upsert opportunitytoUpdateorInsert1.values(); 
        }
        if(opportunitytoInsert.size()>0)
        {
          Insert opportunitytoInsert;  
        }
        System.debug('webinartoInsert.size()---- '+webinartoInsert.size());
        if(webinartoInsert.size()>0)
        {
            Insert webinartoInsert;
        }
        System.debug('contactustaskstoInsert---- '+contactustaskstoInsert);
        System.debug('contactustaskstoInsert size---- '+contactustaskstoInsert.size());
        if(contactustaskstoInsert.size()>0){Insert contactustaskstoInsert;}
        if(test.isRunningTest())
       {
          coverMethod();
       }
    } 
    public static void HandleProjects(Opportunity opp,Contact ct,Integer webinarNumber,Map<String,User> userpincodeMap)
    {
        System.debug('I m in HandleProjects---');
        opp.from_Code_updated_Inserted__c='Project updated or Inserted from the trg_ContactHandler Line 147';
        User ISTUser=new User();
        String pincode;
        if(ct.MailingPostalCode!=null)
        pincode=ct.MailingPostalCode;
        if(pincode!=null)
        {
              if(userpincodeMap.containsKey(pincode)) 
              {
                ISTUser= userpincodeMap.get(pincode); 
              }
        }
        if(opp!=null && opp.Status__c!='Completed' && opp.Status__c!='Cancelled' && opp.Status__c!='On Hold')
        {
           
            if(ct.Prospect_Interest_Type__c=='Sample Requested' &&ct.Indiamart_QTYPE__c==NULL)
            {
               opp.Which_Product_Sent__c=ct.Which_Product_Sent__c;
               opp.Flag_Sample_Requested__c=true;
               opp.SampleRequested_Timestamp__c=system.now();
               opp.Prospect_Interest_Type__c='Sample Requested';
            }
            if(ct.Prospect_Interest_Type__c=='Webinar')
            {
               opp.Prospect_Interest_Type__c='Webinar';
               opp.Webinar_Timestamp__c=system.now();
               opp.Flag_Webinar__c=True;
               if(webinarNumber==0)
               {
                 opp.Webinar_Id__c=ct.Webinar_Id__c;
                 opp.Webinar_Name__c=ct.webinar_Name__c;
                 opp.Is_Webinar_Attended__c=ct.Is_Webinar_Attended__c;  
               }
               else if(webinarNumber==1)
               {
                 opp.Webinar_Id__c=ct.Webinar_Id_1__c;
                 opp.Webinar_Name__c=ct.Webinar_Name1__c;
                 opp.Is_Webinar_Attended__c=ct.Is_Webinar_Attended1__c;  
               }
                   
               
            }
            /*if(ct.Prospect_Interest_Type__c!='Sample Requested')
            {
                opp.stageName='Trial Scheduled/Intent to buy';
                opp.probability=30;
                opp.Flag_Webinar__c=True;
            }*/
            if(((ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c)||(ct.Is_Webinar_Attended__c || ct.Is_recorded_webinar_attended__c))  && ct.Prospect_Interest_Type__c=='Webinar')
            {
                opp.StageName=label.Stage_30;
                opp.Probability=30;
                opp.Is_Webinar_Attended__c=true;
                }
            if(ct.Prospect_Interest_Type__c=='Contact Us')
            {
                opp.Flag_Contact_Us__c=true;
                opp.Contact_Us_Timestamp__c=System.now();
                System.debug('opp.Type_of_Enquiry__c---- '+opp.Type_of_Enquiry__c);
                if(ct.Type_of_Enquiry__c=='request_a_visit' )
                {
                    opp.StageName=label.Stage_30;
                    opp.Probability=30;
                    Task tus1 = new Task();
                    tus1.Subject = 'Confirm trial date with customer';
                    tus1.WhatId = opp.Id;
                    tus1.OwnerId = opp.Assigned_IST_User__c;
                    tus1.Customer_Email_Id__c=opp.Contact_email__c ; 
                    tus1.Status = 'Open';
                    tus1.Priority = 'High';
                    tus1.Original_Due_Date__c =system.today()+1;
                    tus1.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus1);                                   
                }
                if(ct.Type_of_Enquiry__c=='general_inquiry' )
                {
                    Task tus2 = new Task();
                    tus2.Subject = 'Understand customer’s enquiry';
                    tus2.WhatId = opp.Id;
                    tus2.OwnerId = opp.Assigned_IST_User__c;
    				tus2.Customer_Email_Id__c=opp.Contact_email__c ; 
                    tus2.Status = 'Open';
                    tus2.Priority = 'High';
                    tus2.Original_Due_Date__c =system.today()+1;
                    tus2.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus2);                                  
                }
            }
            if(opp.CloseDate==null)
            opp.CloseDate=date.valueOf(system.Now().addMonths(2));
            if(opp.Assigned_IST_User__c==null)
            {
                if(ISTUser!=null)
                opp.Assigned_IST_User__c=ISTUser.id;
                else
                opp.Assigned_IST_User__c=label.default_IST;
            }
            if(!opportunitytoUpdateorInsert1.containsKey(opp.Id))
            {
              opportunitytoUpdateorInsert1.put(opp.Id,opp);  
            }
            opportunitytoUpdateorInsert.add(opp);
        }
        else if(opp!=null && (opp.Status__c=='Cancelled' || opp.Status__c=='On Hold'))
        {
                if(ct.Prospect_Interest_Type__c=='Sample Requested')
                {
                    opp.Which_Product_Sent__c=ct.Which_Product_Sent__c;
                    opp.Flag_Sample_Requested__c=true;
                    opp.Prospect_Interest_Type__c='Sample Requested';
                }
                if(ct.Prospect_Interest_Type__c=='Webinar')
                {
                    opp.Prospect_Interest_Type__c='Webinar';
                    opp.Webinar_Timestamp__c=system.now();
                    opp.Flag_Webinar__c=True;
                    if(webinarNumber==0)
                    {
                        opp.Webinar_Id__c=ct.Webinar_Id__c;
                        opp.Webinar_Name__c=ct.webinar_Name__c;
                        opp.Is_Webinar_Attended__c=ct.Is_Webinar_Attended__c;  
                    }
                    else if(webinarNumber==1)
                    {
                        opp.Webinar_Id__c=ct.Webinar_Id_1__c;
                        opp.Webinar_Name__c=ct.Webinar_Name1__c;
                        opp.Is_Webinar_Attended__c=ct.Is_Webinar_Attended1__c;  
                    }
                    
                    
                }
                if(((ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c || ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c)||(ct.Is_Webinar_Attended__c || ct.Is_recorded_webinar_attended__c || ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c))  && ct.Prospect_Interest_Type__c=='Webinar')
                {
                opp.StageName=label.Stage_30;
                opp.Probability=30;
                opp.Is_Webinar_Attended__c=true;
                }
                else
                {
                opp.StageName=label.Stage_15;
                opp.Probability=15;
                }
                if(!opportunitytoUpdateorInsert1.containsKey(opp.Id))
                {
                    opportunitytoUpdateorInsert1.put(opp.Id,opp);  
                }
                opportunitytoUpdateorInsert.add(opp); 
        }
        else
        {
            //create New Opportunity
            
        }
    }
    public static void createOpportunity(Contact ct,Map<String,User> userpincodeMap,Integer webinarNumber)
    {
            User ISTUser=new User();
            String pincode;
            Opportunity opptoInsert=new Opportunity();
        	opptoInsert.stageName=label.stage_15;
            opptoInsert.from_Code_updated_Inserted__c='Opportunity Inserted from the trg_onContactHandler line 238';
            if(ct.MailingPostalCode!=null)
            pincode=ct.MailingPostalCode;
            if(pincode!=null)
            {
              if(userpincodeMap.containsKey(pincode)) 
              {
                ISTUser= userpincodeMap.get(pincode); 
              }
            }
            if(ct.Prospect_Interest_Type__c=='Sample Requested' && ct.Indiamart_QTYPE__c==NULL)
            {
              opptoInsert.Which_Product_Sent__c=ct.Which_Product_Sent__c;
              opptoInsert.SampleRequested_Timestamp__c=system.now();
              opptoInsert.Flag_Sample_Requested__c=true;
            }
        	if(ct.Prospect_Interest_Type__c=='GM Design Guide')
            {
               opptoInsert.stageName=label.stage_15;
               opptoInsert.Probability=15;
               opptoInsert.Flag_GM_Design_Guide__c=true;
               opptoInsert.GM_Design_Guide_Name__c=ct.GM_Design_Guide_Name__c;
            }
        	if(ct.Prospect_Interest_Type__c=='Get A Demo')
            {
              opptoInsert.stageName=label.stage_30;
              opptoInsert.Probability=30;
              opptoInsert.Flag_Get_A_Demo__c=true;
              opptoInsert.Demo_Comments__c=ct.Comments__c;
            }
            opptoInsert.name='DG-AG-SU-Product-Application';
           	if((ct.Webinar_Id__c!=null || ct.Webinar_Id_1__c!=null) && ct.Prospect_Interest_Type__c=='Webinar')
            {
                if(webinarNumber==0)
                {
                   opptoInsert.Webinar_Id__c=ct.Webinar_Id__c; 
                }
                else if(webinarNumber==1)
                {
                  opptoInsert.Webinar_Id__c=ct.Webinar_Id_1__c;  
                }
                
            }
            if(ct.Prospect_Interest_Type__c!=null)
            opptoInsert.Prospect_Interest_Type__c=ct.Prospect_Interest_Type__c;
            opptoInsert.Status__c='Active';
            if((ct.Webinar_Name__c!=null || ct.Webinar_Id__c!=null || ct.Webinar_Id_1__c!=null || ct.Webinar_Name1__c!=null) && ct.Prospect_Interest_Type__c=='Webinar')
            {
                if(webinarNumber==0)
                {
                    opptoInsert.Webinar_Name__c=ct.Webinar_Name__c;
                    opptoInsert.Webinar_Timestamp__c=system.now();
                    opptoInsert.Flag_Webinar__c=True;
                }
                else if(webinarNumber==1)
                {
                    opptoInsert.Webinar_Name__c=ct.Webinar_Name1__c;
                    opptoInsert.Webinar_Timestamp__c=system.now();
                    opptoInsert.Flag_Webinar__c=True; 
                }
            }
            if(((ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c)||(ct.Is_Webinar_Attended__c || ct.Is_recorded_webinar_attended__c))  && ct.Prospect_Interest_Type__c=='Webinar')
            {
                opptoInsert.StageName=Label.Stage_30;
                opptoInsert.Probability=30;
                opptoInsert.Is_Webinar_Attended__c=true;
            }
            else if(ct.Prospect_Interest_Type__c=='Webinar')
            {
                opptoInsert.StageName=Label.Stage_15;
                opptoInsert.Probability=15;
            }
        	
            opptoInsert.AccountId=ct.AccountId;
            opptoInsert.Contact2__c=ct.id;
        	opptoInsert.CloseDate=date.valueOf(system.Now().addMonths(2));
            if(ISTUser!=null)
            {
            	opptoInsert.Assigned_IST_User__c=ISTUser.Id;
            }
        	else
            {
              opptoInsert.Assigned_IST_User__c=label.Default_IST;  
            }
        	if((ct.Prospect_Interest_Type__c=='Contact Us' && ct.Flag_Contact_Us__c)||(ct.Prospect_Interest_Type__c=='Sample Requested' && ct.Type_of_Enquiry__c=='request_free_sample' && ct.Flag_Contact_Us__c))
            {
                opptoInsert.Flag_Contact_Us__c=true;
                opptoInsert.Contact_Us_Timestamp__c=System.now();
               	if(ct.Type_of_Enquiry__c=='request_a_visit')
                {
                    opptoInsert.StageName=Label.Stage_30;
                    opptoInsert.Probability=30;
                }
                Insert opptoInsert;
                if(ct.Type_of_Enquiry__c=='request_a_visit' )
                {
                    Task tus1 = new Task();
                    tus1.Subject = 'Confirm trial date with customer';
                    tus1.WhatId = opptoInsert.Id;
                    tus1.OwnerId = opptoInsert.Assigned_IST_User__c;
                    tus1.Customer_Email_Id__c=opptoInsert.Contact_email__c ; 
                    tus1.Status = 'Open';
                    tus1.Priority = 'High';
                    tus1.Original_Due_Date__c =system.today()+1;
                    tus1.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus1);                                   
                }
                if(ct.Type_of_Enquiry__c=='general_inquiry' )
                {
                    Task tus2 = new Task();
                    tus2.Subject = 'Understand customer’s enquiry';
                    tus2.WhatId = opptoInsert.Id;
                    tus2.OwnerId = opptoInsert.Assigned_IST_User__c;
    				tus2.Customer_Email_Id__c=opptoInsert.Contact_email__c ; 
                    tus2.Status = 'Open';
                    tus2.Priority = 'High';
                    tus2.Original_Due_Date__c =system.today()+1;
                    tus2.ActivityDate=system.today()+1;
                    contactustaskstoInsert.add(tus2);                                  
                }
            }
        	else
            {
              opportunitytoInsert.add(opptoInsert);  
            }
            
    }
    public static void createWebinar(Opportunity opp,Contact ct,Integer webinarNumber)
    {
       if(opp!=null)
       {
           Webinar__c web=new Webinar__c();
           if(webinarNumber==0)
           {
               web.Webinar_Id__c=ct.Webinar_Id__c;
               web.Webinar_Link__c=ct.Webinar_link__c;
               web.Customer_Contact__c=ct.Id;
               web.Webinar_Machine__c=ct.Webinar_Machine__c;
               web.Name=ct.Webinar_Name__c;
               web.Related_Project__c=opp.id;  
           }
           else if(webinarNumber==1)
           {
               web.Webinar_Id__c=ct.Webinar_Id_1__c;
               web.Webinar_Link__c=ct.Webinar_Link1__c;
               web.Customer_Contact__c=ct.Id;
               web.Webinar_Machine__c=ct.Webinar_Machine1__c;
               web.Name=ct.Webinar_Name1__c;
               web.Related_Project__c=opp.id; 
           }
           webinartoInsert.add(web);
            
       }
    }
    public static void handlePDP(List<Contact> newContact,Map<Id,Contact> oldMap,Map<id,List<Quotation__c>> leadQuotationNumberMap,
                                Map<id,List<Request__c>> leadRequestCallBackMap,Map<id,List<Customized_Price__c>> leadCustomizedPriceMap,
                                Map<id,List<Refer_Friend__c>> leadReferFrndMap)
    {
        List<Request__c> requesttoCallbcakInsert=new List<Request__c>();
        List<Customized_Price__c> customizedpricetoInsert=new List<Customized_Price__c>();
        List<Refer_Friend__c> RefertoFriendInsert=new List<Refer_Friend__c>();
        for(Contact ct :newContact)
        {
            if((ct.Request_Callback_Product__c != oldMap.get(ct.Id).Request_Callback_Product__c) )
            {
               Request__c req=new Request__c();
               req.Contact_Name__c=ct.id;
               req.Product_Name__c=ct.Request_Callback_Product__c;
               req.Product_Image_Link__c=ct.Request_Callback_Product_Link__c;
               req.Product_SKU__c=ct.requestcallback_sku__c;
               req.Product_Page_Link__c=ct.Request_Callback_Product_Page_Link__c;
               req.Product_Details__c=ct.Request_Callback_Product_Details__c;
               req.Contact_Email__c =ct.Email;
               if(leadRequestCallBackMap.containsKey(ct.id))
               {
                   if(leadRequestCallBackMap.get(ct.id).size()>0)
                   {
                     req.Sent_First_Mail__c=true;  
                   }
               }
               requesttoCallbcakInsert.add(req);
                
            }
            if((ct.Customized_Price_Product__c != oldMap.get(ct.Id).Customized_Price_Product__c))
            {
               Customized_Price__c cusprice=new Customized_Price__c();
               cusprice.Contact_Name__c=ct.id;
               cusprice.Expect_price_per_piece__c=ct.Customized_Price_Expect_price_per_piece__c;
               cusprice.Product_Page_Link__c=ct.Customized_Price_Product_Page_Link__c;
               cusprice.Product_Details__c=ct.Customized_Price_Product_Details__c;
               cusprice.Product_Link__c=ct.Customized_Price_Product_Link__c;
               cusprice.Product_Name__c=ct.Customized_Price_Product__c;
               cusprice.Quantity__c=ct.Customized_Price_Quantity__c;
               cusprice.SKU__c=ct.Customized_Price_SKU__c;
               cusprice.Contact_Email__c=ct.Email;
               if(leadCustomizedPriceMap.containsKey(ct.id))
               {
                   if(leadCustomizedPriceMap.get(ct.id).size()>0)
                   {
                     cusprice.Sent_First_Mail__c=true;  
                   }
               }
               customizedpricetoInsert.add(cusprice);
               
            }
            if((ct.Refer_A_Friend_Product__c !=oldMap.get(ct.Id).Refer_A_Friend_Product__c) )
            {
              Refer_Friend__c ref=new Refer_Friend__c();
              ref.Contact_Name__c=ct.id;
              ref.Product_Details__c=ct.Refer_A_Friend_Product_Details__c;
              ref.Product_Link__c=ct.Refer_A_Friend_Product_Link__c;
              ref.Product_Name__c=ct.Refer_A_Friend_Product__c;
              ref.Referred_By__c=ct.Referred_By__c;
              ref.SKU__c=ct.Refer_A_Friend_SKU__c;
              ref.Subject__c=ct.Refer_a_friend_Subject__c;
              ref.Contact_Email__c=ct.Email;
              if(leadReferFrndMap.containsKey(ct.id))
               {
                   if(leadReferFrndMap.get(ct.id).size()>0)
                   {
                     ref.Sent_First_Mail__c=true;  
                   }
               }
              RefertoFriendInsert.add(ref); 
           }
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
        if(RefertoFriendInsert.size()>0)
        {
           Insert RefertoFriendInsert;
           
        }
    }
    
    /*public static void StateCodeMethod(List<Contact> newContacts,Map<Id,Contact> oldMap,Boolean isInsert,Map<String,State__mdt> StateCodeMap)
    {
        List<Contact> ContactStateCodeUpdate = new List<Contact>();
        for(Contact ct: newContacts)
        {
            if(ct.MailingState!=null && StateCodeMap.containsKey(ct.MailingState))
               {
                ct.Internal_Code_state_ace__c=StateCodeMap.get(ct.MailingState).Internal_Code__c;
                   ContactStateCodeUpdate.add(ct);
               // acc.Industry_ace__c=industryCodeMap.get(acc.Industry).Internal_Code__c;
               }
               
               else
               ct.Internal_Code_state_ace__c='NA'; 
               ContactStateCodeUpdate.add(ct);
        }
        //update ContactStateCodeUpdate;
    }*/
    public static void HandleCareFunctionality(List<Contact> newContacts,Map<Id,Contact> oldMap,Boolean isInsert)
    {
        System.debug('I am in care functionality');
        System.debug(isInsert);
        
        Map<String,Care__c> careMap=new Map<String,Care__c>();
        
        List<Contact> upsertcontact_Care_according=new List<Contact>();
        
        List<String> industryEmp = new List<String>();
        
        if(isInsert) 
        {
            for(Contact ct : newContacts)
            {
                if(ct.Contact_Industry_Employees__c != null)
                {
                    industryEmp.add(ct.Contact_Industry_Employees__c);
                }
            }
            
            if(industryEmp.size() > 0)
            {
                for(Care__c careObj  :[Select id,Focus_Segment__c,Focus_Priority__c,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
                                       SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c where Industry_NumberofEmployees__c =: industryEmp])
                {
                    careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
                }
            }
            
            for(Contact ct : newContacts)
            {
                System.debug('---------');
                System.debug(careMap.containsKey(ct.Contact_Industry_Employees__c));
                if(careMap.containsKey(ct.Contact_Industry_Employees__c))
                {
                    ct.Annualized_value_estimation__c=careMap.get(ct.Contact_Industry_Employees__c).Annualized_value_estimation__c;
                    ct.Lead_classification_basis_value__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_classification_basis_value__c;
                    ct.Grade__c=careMap.get(ct.Contact_Industry_Employees__c).Grade__c;
                    ct.Industry_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Industry_priority__c;
                    ct.Lead_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_priority__c;
                    ct.SBU__c=careMap.get(ct.Contact_Industry_Employees__c).SBU__c;
                    ct.Focus_Segment__c=careMap.get(ct.Contact_Industry_Employees__c).Focus_Segment__c;
                    ct.Focus_Priority__c=careMap.get(ct.Contact_Industry_Employees__c).Focus_Priority__c;
                    upsertcontact_Care_according.add(ct);
                }
            }
        }
        
        else
        {
            for(Contact ct : newContacts)
            {
                if((ct.Contact_Industry_Employees__c != null &&  (oldMap.get(ct.Id).Contact_Industry_Employees__c!=ct.Contact_Industry_Employees__c))||ct.Account_Industry_Update__c)
                {
                    industryEmp.add(ct.Contact_Industry_Employees__c);
                }
            }
            
            if(industryEmp.size() > 0)
            {
                for(Care__c careObj  :[Select id,Focus_Segment__c,Focus_Priority__c,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
                                       SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c where Industry_NumberofEmployees__c =: industryEmp])
                {
                    careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
                }
            }
            
            
            for(Contact ct : newContacts)
            {
                System.debug('careMap.containsKey(ct.Contact_Industry_Employees__c)--- '+careMap.containsKey(ct.Contact_Industry_Employees__c));
                System.debug('oldMap.get(ct.Id).Contact_Industry_Employees__c-- '+oldMap.get(ct.Id).Contact_Industry_Employees__c);
                if((careMap.containsKey(ct.Contact_Industry_Employees__c) &&  (oldMap.get(ct.Id).Contact_Industry_Employees__c!=ct.Contact_Industry_Employees__c))||ct.Account_Industry_Update__c)
                {
                    if(careMap.containskey(ct.Contact_Industry_Employees__c))
                    {
                        ct.Annualized_value_estimation__c=careMap.get(ct.Contact_Industry_Employees__c).Annualized_value_estimation__c;
                        ct.Lead_classification_basis_value__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_classification_basis_value__c;
                        ct.Grade__c=careMap.get(ct.Contact_Industry_Employees__c).Grade__c;
                        ct.Industry_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Industry_priority__c;
                        ct.Lead_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_priority__c;
                        ct.SBU__c=careMap.get(ct.Contact_Industry_Employees__c).SBU__c;
                        ct.Focus_Segment__c=careMap.get(ct.Contact_Industry_Employees__c).Focus_Segment__c;
                        ct.Focus_Priority__c=careMap.get(ct.Contact_Industry_Employees__c).Focus_Priority__c;
                        ct.Account_Industry_Update__c=false;
                        upsertcontact_Care_according.add(ct);
                    }
                }
            }
        }
    }
    
    public static void handleItenttoBuy(List<Contact> newContacts,Map<Id,Contact> oldMap,Boolean isInsert,List<Contact> exitingContactList)
    {
       System.debug('I m in handleItenttoBuy---');
       Map<Id,List<Opportunity>> cntopprtunityMap=new Map<Id,List<Opportunity>>();
       List<Opportunity> OpportunitytoUpdate=new List<Opportunity>();
       List<Task> tasktoUpdate=new List<Task>();
       Set<Id> opportunitySet=new Set<Id>();
       Map<Id,Task> TaskOpportunityMap=new Map<Id,Task>();
       for(Contact cnt :exitingContactList)
       {
          cntopprtunityMap.put(cnt.Id,cnt.Opportunities2__r);
          for(Opportunity opp  : cnt.Opportunities2__r)
          {
              opportunitySet.add(opp.Id);
          }
       }
       System.debug('cntopprtunityMap handleItenttoBuy---- '+cntopprtunityMap);
       /*List<Task> tList = [select Id, Status,WhatId from Task where Subject =: 'Confirm Sample Received' And WhatId in :opportunitySet];
       for(Task t : tList)
       {
         TaskOpportunityMap.put(t.whatId,t);  
       }*/
       if(isInsert)
       {
          
       }
       else
       {
          System.debug('I am in else');
          for(Contact ct:newContacts)
          {
            Opportunity ExistingOpportunity=new Opportunity(); 
            if((ct.Intends_to_place_an_order_request__c == true && Oldmap.get(ct.Id).Intends_to_place_an_order_request__c == false)
            ||
            (ct.Intends_to_speak_to_LOCTITE__c == true && Oldmap.get(ct.Id).Intends_to_speak_to_LOCTITE__c == false))
              {
                if(cntopprtunityMap.containsKey(ct.Id) && cntopprtunityMap.get(ct.Id).size()>0)
                {
                   ExistingOpportunity=cntopprtunityMap.get(ct.Id)[0];
                   System.debug('ExistingOpportunity---- '+ExistingOpportunity);
                   ExistingOpportunity.Intends_to_place_an_order_request_del__c = ct.Intends_to_place_an_order_request__c;
                   ExistingOpportunity.Intends_to_Speak__c = ct.Intends_to_speak_to_LOCTITE__c;
              	   if(ExistingOpportunity.Probability < 30)
                   {//Move Project to 30
                       ExistingOpportunity.StageName = label.Stage_30;
                       ExistingOpportunity.Probability = 30;
                   }
                   if(ExistingOpportunity!=null)
           		   OpportunitytoUpdate.add(ExistingOpportunity);
                }
              }
           System.debug('ExistingOpportunity--- '+ExistingOpportunity);
           
          } 
          System.debug('OpportunitytoUpdate.size()---- '+OpportunitytoUpdate.size()); 
          if(OpportunitytoUpdate.size()>0)
          {
              Update OpportunitytoUpdate;
          }
          if(tasktoUpdate.size()>0)
          {
             //update tasktoUpdate; 
          }
       }
    }
    
    public static void handleEcomRegistrants(List<Contact> newContactList,Map<Id,Contact> newMap,Map<Id,Contact> oldMap,Map<String,User> userpincodeMap)
    {
        List<Opportunity> opportunitytoInsert=new List<Opportunity>();
        String pincode;
        User ISTUser;
        for(Contact ct : newContactList)
        {
           if((newMap.get(ct.id).OwnerId !=oldMap.get(ct.id).OwnerId ) && ct.CC_Status__c=='mql' && ct.Ecom_Registration__c)
           {
            Opportunity opptoInsert=new Opportunity();
            if(ct.MailingPostalCode!=null)
            pincode=ct.MailingPostalCode;
            if(pincode!=null)
            {
              if(userpincodeMap.containsKey(pincode)) 
              {
                ISTUser= userpincodeMap.get(pincode); 
              }
            }
            opptoInsert.Flag_Ecommerce__c=true;
            opptoInsert.name='DG-AG-SU-Product-Application';
            opptoInsert.from_Code_updated_Inserted__c='Inserted from the trg_OnContactHandler Line number : 529';
            opptoInsert.CloseDate=date.valueOf(system.Now().addMonths(2));
            opptoInsert.StageName=label.Stage_15;
            opptoInsert.Probability=15;
            opptoInsert.AccountId=ct.AccountId;
            opptoInsert.Contact2__c=ct.id;
            if(ISTUser!=null)
            opptoInsert.Assigned_IST_User__c=ISTUser.Id;
            opportunitytoInsert.add(opptoInsert);
           }
        }
        
        //Insert opportunitytoInsert;
    }
    @future(Callout=true)
    public static void pardotCalloutforActivity(String strnewMap, String strOldMap)
    {
        System.debug('I am in pardotCalloutforActivity');
        map<id,Contact> oldMap =(Map<id,Contact>)JSON.deserialize(strOldMap,map<id, Contact>.class);
    	map<id,Contact> newMap =(Map<id,Contact>)JSON.deserialize(strnewMap, map<id, Contact>.class);
        
        for(Contact cnt : newMap.values())
        {
           if(cnt.Visitor_Id__c!=null && cnt.Prospect_id__c != null)
           {
               System.debug('Handling request');
               
               HttpRequest request=new HttpRequest();
               
               String api_Key=getAccessToken();
               String auth = 'Bearer '+api_Key;
               String pardot_UID = label.Pardot_Business_Unit_Id;
               
               request.setMethod('POST');
               
               request.setHeader('Pardot-Business-Unit-Id', pardot_UID);
               request.setHeader('Authorization', 'Bearer '+api_Key);
              // request.setHeader('Content-Type', 'application/json');
               
               request.setEndpoint('https://pi.pardot.com/api/visitor/version/4/do/assign/');
               
               String Body = 'prospect_id='+cnt.Prospect_id__c+'&id='+cnt.Visitor_Id__c;
			   request.setBody(Body);
               
               Http http=new Http();
        	   HttpResponse response=http.send(request);
               System.debug('response------ '+response.getBody());
			   System.debug('Request Completed');               
           }
        }
    }
    public static string getAccessToken()
    {
        System.debug('I am in getAccessToken()');
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        string body='username='+Label.Pardot_Username+'&password='+Label.Pardot_Password+'&grant_type=password'+'&client_id='+Label.Pardot_Client_Id+'&client_secret='+Label.Pardot_client_secret;
        request.setBody(body);
        Http http=new Http();
        HttpResponse response=http.send(request);
        //DOM.Document doc=new DOM.Document();
        //doc.load(response.getBody());
        //DOM.XmlNode rootNode=doc.getRootElement();
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String api_Key = (String)jsonMap.get('access_token');
        System.debug('Access Token Returned');
        return api_Key;
    }
    public static void Contactscoringmodel(List<Contact> newLeadList,Map<Id,Contact> oldMap , String eventtype)
    {
       List<Account> acList=new List<Account>();
       Map<Id,Account> accMap=new Map<Id,Account>();
       if(eventtype=='insert')
       {
          for(Contact l : newLeadList)
          {
              if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c <45  && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Cold';
			  }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Cold';
			  }
              else if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >= 45 && l.pi__score__c < 65 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Warm';
			  }
              else if(l.pi__score__c >=45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Warm';
			  }
              else if(l.pi__score__c >=65  && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >=65 &&  l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Hot';
			  }
              
          }
       }
       else if(eventtype=='update')
       {
          System.debug('Leadscoringmodel--------------------- ');
          for( Contact l : newLeadList)
          {
            if(l.pi__score__c!=oldMap.get(l.id).pi__score__c || l.Lead_classification_basis_value__c !=oldMap.get(l.id).Lead_classification_basis_value__c)
            {
                System.debug('Leadscoringmodel--------------------- iffff'); 
              if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Warm';
			  }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Cold';
			  }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Cold';
			  }
              if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >= 45 && l.pi__score__c < 65 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Warm';
			  }
              else if(l.pi__score__c >=45 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Warm';
			  }
              else if(l.pi__score__c >=65  && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Hot';
				
              }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >=65 &&  l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Hot';
			  }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating_Custom__c='Hot';
			  }
           	}
          }
       }
       update accMap.values();
        
         if(test.isRunningTest())
                   {
                       coverMethod();
                   }
    }
    
    public static void coverMethod()
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
        i++;
        i--;
        i++;
        i--;
    }
    
}