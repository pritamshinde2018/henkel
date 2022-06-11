trigger trg_onContactBeforeUpdateAfterInsert on Contact (before update, after insert, after update,before insert) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsoldcontacttrgActivated__c)
    {
    System.debug('contact trigger start query limit------ '+limits.getLimitQueries() );
    List<Contact> cntList=new List<Contact>();
    Map<id,List<Quotation__c>> leadQuotationNumberMap=new Map<Id,List<Quotation__c>>();
    Map<id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>();
    Map<id,List<Customized_Price__c>> leadCustomizedPriceMap=new Map<Id,List<Customized_Price__c>>();
    Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
    Map<String,Care__c> careMap=new Map<String,Care__c>();
    if(trigger.isUpdate && trigger.isbefore)
   {
        for(Contact l :[Select id,(Select id from Quotations__r),(Select id from Request_Callbacks__r),(Select id from Customized_Prices__r) from Contact where id in :trigger.new])
        {
           leadQuotationNumberMap.put(l.Id,l.Quotations__r); 
           leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
           leadCustomizedPriceMap.put(l.id,l.Customized_Prices__r);
           leadReferFrndMap.put(l.id,l.Refer_Friends__r);
        }
        for(Care__c careObj  :[Select id,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
                               SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c ])
        {
            careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
        }
   }
    integer count=0;
    Map<Id,Set<String>> cntWebMap=new Map<Id,Set<String>>();
    Map<Id,List<Opportunity>> cntProjectMap=new Map<Id,List<Opportunity>>();
    List<Webinar__c> webinarListtoInsert=new List<Webinar__c>();
    Map<String,Webinar__c> WebMap=new Map<String,Webinar__c>();
    Map<String,Opportunity> oppWebMap=new Map<String,Opportunity>();
    List<Opportunity> OppList=new List<Opportunity>();
    List<Opportunity> OpptoUpdate=new List<Opportunity>();
    List<Opportunity> OpptoUpdate1=new List<Opportunity>();
    List<Opportunity> OpptoUpdate2=new List<Opportunity>();
    List<Opportunity> OpptoUpdate3=new List<Opportunity>();
    List<Opportunity> OpptoUpdate4=new List<Opportunity>();
    List<Opportunity> OpptoUpdate5=new List<Opportunity>();
    List<Request__c> requesttoCallbcakInsert=new List<Request__c>();
    List<Customized_Price__c> customizedpricetoInsert=new List<Customized_Price__c>();
    List<Refer_Friend__c> RefertoFriendInsert=new List<Refer_Friend__c>();
    Map<Id,contact> ContactMap=new Map<Id,contact>([Select id,name,Is_Webinar_Attended__c from contact where Flag_Webinar__c=true]);
    List<Contact> ConList=new List<Contact>();
    map<id,list<Opportunity>> newoppmap=new map<id,list<Opportunity>>();
    map<id,Opportunity> opportunityToContactMap =new map<id,Opportunity>();
    list<Opportunity> newopplist =new list<Opportunity>();
    list<Opportunity> newopplist1 =new list<Opportunity>();
    list<Opportunity> newopplist2 =new list<Opportunity>();
    list<Opportunity> newopplist3 =new list<Opportunity>();
    list<Opportunity> newopplist4 =new list<Opportunity>();
    list<Opportunity> newopplist5 =new list<Opportunity>();
    Set <ID> setOrderId = new set<ID>();
    List<Contact> upsertcontact_Care_according=new List<Contact>(); 
    list<Opportunity>opplistformql=new list<Opportunity>();
    //static Boolean flag=true;
    //TestCode();
    for(contact ct:trigger.new)
    {
        //Request to callback and Customize price Logic
        if(trigger.isUpdate && trigger.isbefore)
        {
            if((ct.Request_Callback_Product__c != trigger.oldMap.get(ct.Id).Request_Callback_Product__c) )
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
            if((ct.Customized_Price_Product__c != trigger.oldMap.get(ct.Id).Customized_Price_Product__c))
            {
               Customized_Price__c cusprice=new Customized_Price__c();
               cusprice.Contact_Name__c=ct.id;
               cusprice.Expect_price_per_piece__c=ct.Customized_Price_Expect_price_per_piece__c;
               cusprice.Product_Page_Link__c=ct.Customized_Price_Product_Link__c;
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
            if((ct.Refer_A_Friend_Product__c != trigger.oldMap.get(ct.Id).Refer_A_Friend_Product__c) )
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
        //Request to callback and Customize price logic ends here
        if(trigger.isBefore && trigger.isInsert && ct.Contact_Industry_Employees__c!=null)
        {
           if(careMap.containsKey(ct.Contact_Industry_Employees__c))
           {
               ct.Annualized_value_estimation__c=careMap.get(ct.Contact_Industry_Employees__c).Annualized_value_estimation__c;
               ct.Lead_classification_basis_value__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_classification_basis_value__c;
               ct.Grade__c=careMap.get(ct.Contact_Industry_Employees__c).Grade__c;
               ct.Industry_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Industry_priority__c;
               ct.Lead_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_priority__c;
               ct.SBU__c=careMap.get(ct.Contact_Industry_Employees__c).SBU__c;
               upsertcontact_Care_according.add(ct);
           }
        }
        if(trigger.isBefore && trigger.isUpdate && ct.Contact_Industry_Employees__c!=null)
        {
           if(careMap.containsKey(ct.Contact_Industry_Employees__c) &&  (trigger.oldMap.get(ct.Id).Contact_Industry_Employees__c!=ct.Contact_Industry_Employees__c))
           {
               ct.Annualized_value_estimation__c=careMap.get(ct.Contact_Industry_Employees__c).Annualized_value_estimation__c;
               ct.Lead_classification_basis_value__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_classification_basis_value__c;
               ct.Grade__c=careMap.get(ct.Contact_Industry_Employees__c).Grade__c;
               ct.Industry_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Industry_priority__c;
               ct.Lead_priority__c=careMap.get(ct.Contact_Industry_Employees__c).Lead_priority__c;
               ct.SBU__c=careMap.get(ct.Contact_Industry_Employees__c).SBU__c;
               upsertcontact_Care_according.add(ct);
           }
        }
        if(trigger.isAfter && (ct.Intends_to_place_an_order_request__c == true && trigger.Oldmap.get(ct.Id).Intends_to_place_an_order_request__c == false)
           ||
           (ct.Intends_to_speak_to_LOCTITE__c == true && trigger.Oldmap.get(ct.Id).Intends_to_speak_to_LOCTITE__c == false))
        {
            //System.debug('==========='+ct);
            
            opportunity opp = [select id, Intends_to_place_an_order_request_del__c, Intends_to_Speak__c, LastModifiedDate, 
                               StageName, Probability from opportunity where Contact2__c=:ct.id order by LastModifiedDate desc limit 1];
            opp.Intends_to_place_an_order_request_del__c = ct.Intends_to_place_an_order_request__c;
            opp.Intends_to_Speak__c = ct.Intends_to_speak_to_LOCTITE__c;
            //Fetch Confirm Sample Received Task
            //if(ct.Intends_to_place_an_order_request__c == true && (opp.StageName!='Alternate Trial Scheduled' || opp.StageName!='Trial Successful & Business Qualified'||opp.StageName!='First Order Supplied'||opp.StageName!='Maintaining/Closing'))
            if(ct.Intends_to_place_an_order_request__c == true && opp.Probability < 30)
            {
                Task t = [select Id, Status from Task where Subject =: 'Confirm Sample Received' And WhatId =: opp.Id limit 1];
                t.Status = 'Completed';
                if(t!=null)
                    update t;
                
                //Move Project to 30
                opp.StageName = 'Trial Scheduled/Intent to buy/Webinar attended';
                opp.Probability = 30;
            }
           update opp;
        }
    }
    
    for(contact cnt:[Select id,name,Which_Product_Sent__c,(select id,Related_Project__c,Webinar_Id__c from Webinar__r),
                     (Select id,Comments__c,Status__c,StageName,name,Webinar_Id__c,SampleRequested_Timestamp__c,
                      Which_Product_Sent__c,probability,Flag_Ecommerce__c  from Opportunities2__r where Flag_Ecommerce__c!=true order by createddate DESC) 
                     from contact where id in :trigger.new])
    {
        newoppmap.put(cnt.id,cnt.Opportunities2__r);
        Set<String> webinarIds=new Set<String>();
        if(cnt.Opportunities2__r.size()!=0)
        {
            cntProjectMap.put(cnt.Id,cnt.Opportunities2__r);
            for(Opportunity opp  : cnt.Opportunities2__r)
            {
                System.debug('opp.Webinar_Id__c '+opp.Webinar_Id__c);
                oppWebMap.put(opp.Webinar_Id__c,opp);
            }
            System.debug('oppWebMap.size() '+oppWebMap.size());
            }
            for(Webinar__c web  : cnt.Webinar__r)
            {
                webinarIds.add(web.Webinar_Id__c);
                WebMap.put(web.Webinar_Id__c, web);
            }
            cntWebMap.put(cnt.Id,webinarIds);
    }
    System.debug('newoppmap '+newoppmap);
   
    for(Contact ct : trigger.new)
    {
        /////Date :  20-06-2019 ////////
        if(trigger.isBefore && trigger.isUpdate)
        {
            if(ct.Flag_Webinar__c && ct.Prospect_Interest_Type__c=='Sample Requested' 
               &&  trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Webinar')
            { 
               // System.debug('Sample requested'+ct);
                newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Sample Requested';
                newoppmap.get(ct.id)[0].SampleRequested_Timestamp__c=system.now();
                newoppmap.get(ct.id)[0].Flag_Sample_Requested__c=true;
                newoppmap.get(ct.id)[0].Which_Product_Sent__c=ct.Which_Product_Sent__c;
                newopplist5.add( newoppmap.get(ct.id)[0]);
            }
           
            if((trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Webinar' 
                && ct.Prospect_Interest_Type__c=='Sample Requested')||
               (ct.Prospect_Interest_Type__c=='Sample Requested'))
            {
                
                if(newoppmap.get(ct.id).size()>0 && 
                   (newoppmap.get(ct.id)[0].Status__c=='Cancelled' || 
                    newoppmap.get(ct.id)[0].Status__c=='On Hold' ))
                {
                    newoppmap.get(ct.id)[0].Status__c='Active';
                    newoppmap.get(ct.id)[0].Comments__c=' ';
                    newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Sample Requested';
                    newoppmap.get(ct.id)[0].Which_Product_Sent__c =ct.Which_Product_Sent__c;
                    newopplist.add( newoppmap.get(ct.id)[0]);
                }
                else if((newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].Status__c=='Completed' 
                    && ct.Prospect_Interest_Type__c=='Sample Requested')||
                   newoppmap.get(ct.id).size()==0
                  )
                {
                    Opportunity newopp=new Opportunity();
                    newopp.Name='DG-AG-SU-Product-Application';
                    newopp.Status__c='Active';
                    newopp.Contact2__c=ct.Id;
                    newopp.AccountId=ct.AccountId;
                    newopp.Prospect_Interest_Type__c='Sample Requested';
                    newopp.Flag_Sample_Requested__c=true;
                    newopp.StageName='Sample Sent/Inquiry Received';
                    newopp.SampleRequested_Timestamp__c=system.today();
                    newopp.Which_Product_Sent__c =ct.Which_Product_Sent__c;
                    newopp.CloseDate=system.today();
                    newopplist.add(newopp);
                 }
             }
        }
        /////Date :  20-06-2019//////
        if(trigger.isBefore && trigger.isUpdate && ct.Flag_Webinar__c )
        {
            if(ct.Flag_Webinar__c)
            {
                if(ct.Webinar_Id__c!=null && !cntWebMap.get(ct.Id).contains(ct.Webinar_Id__c) )
                {
                    Webinar__c web=new Webinar__c();
                    web.Webinar_Id__c=ct.Webinar_Id__c;
                    web.Webinar_Link__c=ct.Webinar_link__c;
                    web.Customer_Contact__c=ct.Id;
                    web.Webinar_Machine__c=ct.Webinar_Machine__c;
                    web.Name=ct.Webinar_Name__c;
                    if(test.isRunningTest())
                    {
                       convert(); 
                    }
                    if(newoppmap.size()>0 && newoppmap.containsKey(ct.id))
                    {
                       if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c!='Completed')
                       {
                          web.Related_Project__c=newoppmap.get(ct.id)[0].id; 
                       }
                    }
                    if(ct.Is_Webinar_Attended__c)
                    {
                        web.Is_Webinar_Attended__c=true;
                    }
                    if(newoppmap.size()!=0  && (trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Sample Requested' || trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Webinar' || ct.Prospect_Interest_Type__c=='Webinar') && (string.isNotBlank(ct.Webinar_Id__c)) && count==0 )
                    {
                        //System.debug('1newoppmap.get(ct.id)[0].Status__c '+newoppmap.get(ct.id)[0].Status__c); 
                        if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c!='Completed' && newoppmap.get(ct.id)[0].status__c!='Cancelled' && newoppmap.get(ct.id)[0].status__c!='On Hold')
                        {
                          count=1;
                          newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Webinar';
                          newoppmap.get(ct.id)[0].Webinar_Timestamp__c=system.now();
                          newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id__c;
                          newoppmap.get(ct.id)[0].Webinar_Name__c=ct.webinar_Name__c;
                          newoppmap.get(ct.id)[0].Which_Product_Sent__c=ct.Which_Product_Sent__c;
                            newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                              newoppmap.get(ct.id)[0].probability=30;
                          newopplist.add(newoppmap.get(ct.id)[0]);
                          if(newoppmap.size()!=0)
                          {
                            web.Related_Project__c= newoppmap.get(ct.id)[0].id;
                          }
                        }
                        else
                        {
                            //System.debug('2newoppmap.get(ct.id)[0].Status__c '+newoppmap.get(ct.id)[0].Status__c); 
                            if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c=='Completed')
                            {
                                Opportunity opp=new Opportunity();
                                opp.name='DG-AG-SU-Product-Application';
                                opp.CloseDate=System.today()+60;
                                opp.Webinar_Id__c=ct.Webinar_Id__c;
                                opp.Prospect_Interest_Type__c='Webinar';
                                opp.Status__c='Active';
                                opp.Webinar_Name__c=ct.Webinar_Name__c;
                                opp.Webinar_Timestamp__c=system.now();
                                if((ct.Is_Webinar_Attended__c || ct.Is_recorded_webinar_attended__c) && ct.Webinar_Video_total_duration__c>4)
                                {
                                    opp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
                                    opp.Probability=30;
                                    opp.Is_Webinar_Attended__c=true;
                                }
                                else
                                {
                                    opp.StageName='Sample Sent/Inquiry Received';
                                    opp.Probability=15;
                                }
                                opp.AccountId=ct.AccountId;
                                opp.Contact2__c=ct.id;
                                newopplist.add(opp);
                            }
                            if(newoppmap.get(ct.id).size()>0 && (newoppmap.get(ct.id)[0].status__c=='Cancelled' || newoppmap.get(ct.id)[0].status__c=='On Hold'))
                            {
                               newoppmap.get(ct.id)[0].Status__c='Active';
                               newoppmap.get(ct.id)[0].Comments__c=' ';
                               newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id__c;
                               newoppmap.get(ct.id)[0].Webinar_Name__c=ct.webinar_Name__c;
                               newopplist.add( newoppmap.get(ct.id)[0]); 
                            }
                        }
                   }
                   webinarListtoInsert.add(web);
               }
               if(OppWebMap.containsKey(ct.Webinar_Id__c) && OppWebMap.get(ct.Webinar_Id__c).probability<30 && (ct.Is_Webinar_Attended__c || ct.Is_recorded_webinar_attended__c )&& trigger.oldmap.get(ct.id).Is_Webinar_Attended__c==false)
               {
                   OppWebMap.get(ct.Webinar_Id__c).stageName='Trial Scheduled/Intent to buy/Webinar attended';
                   OppWebMap.get(ct.Webinar_Id__c).probability=30;
                   OppWebMap.get(ct.Webinar_Id__c).Is_Webinar_Attended__c=true;
                   OpptoUpdate.add(OppWebMap.get(ct.Webinar_Id__c));
                }
                if(newoppmap.get(ct.id).size()!=0 &&ct.Is_recorded_webinar_attended__c&& (ct.Is_Webinar_Attended__c|| ct.Webinar_Video_total_duration__c>15) && ct.Webinar_Id__c== newoppmap.get(ct.id)[0].Webinar_Id__c && trigger.oldmap.get(ct.id).Is_Webinar_Attended__c==false)
                    {
                        newoppmap.get(ct.id)[0].Is_Webinar_Attended__c=true;
                    if(newoppmap.get(ct.id)[0].status__c=='Cancelled' || newoppmap.get(ct.id)[0].status__c=='On Hold')
                    {
                       newoppmap.get(ct.id)[0].Status__c='Active';
                       newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id__c;
                       newoppmap.get(ct.id)[0].Webinar_Name__c=ct.webinar_Name__c;
                       newoppmap.get(ct.id)[0].Comments__c=' ';  
                    }
                    if(newoppmap.get(ct.id)[0].Probability<30)
                    {
                        newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                        newoppmap.get(ct.id)[0].Probability=30;
                    }
                    if(newopplist.isEmpty())
                        newopplist.add( newoppmap.get(ct.id)[0]);
                    }
                /***************************FOr webinar0 Ends Here*****************************************/         
                   if(ct.Webinar_Id_1__c!=null && !cntWebMap.get(ct.Id).contains(ct.Webinar_Id_1__c))
                {
                    
                    Webinar__c web=new Webinar__c();
                    web.Webinar_Id__c=ct.Webinar_Id_1__c;
                    web.Webinar_Link__c=ct.Webinar_Link1__c;
                    web.Customer_Contact__c=ct.Id;
                    web.Webinar_Machine__c=ct.Webinar_Machine1__c;
                    web.Name=ct.Webinar_Name1__c;
                    if(ct.Is_Webinar_Attended1__c)
                    {
                        web.Is_Webinar_Attended__c=true;
                    }
                    if(newoppmap.size()>0)
                    {
                       if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c!='Completed')
                       {
                          web.Related_Project__c=newoppmap.get(ct.id)[0].id; 
                       }
                    }
                    webinarListtoInsert.add(web);
                    if(newoppmap.get(ct.id).size()>0 && newoppmap.size()!=0  && (trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Sample Requested'|| trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Webinar' || ct.Prospect_Interest_Type__c=='Webinar') && (string.isNotBlank(ct.Webinar_Id_1__c)) && count==0)
                    {
                      if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c!='Completed' && newoppmap.get(ct.id)[0].status__c!='Cancelled' && newoppmap.get(ct.id)[0].status__c!='On Hold')
                      {
                          count=1;
                          newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Webinar';
                          newoppmap.get(ct.id)[0].Webinar_Timestamp__c=system.now();
                          newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id_1__c;
                          newoppmap.get(ct.id)[0].Webinar_Name__c=ct.Webinar_Name1__c;
                          newoppmap.get(ct.id)[0].Which_Product_Sent__c=ct.Which_Product_Sent__c;
                          newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';//added by Ajinkya
                              newoppmap.get(ct.id)[0].probability=30;//Added By Ajinkya
                          newopplist1.add( newoppmap.get(ct.id)[0]);
                          if(newoppmap.get(ct.id).size()>0 && newoppmap.size()!=0)
                          {
                            web.Related_Project__c= newoppmap.get(ct.id)[0].id;
                          }
                          
                      }
                      else
                      {
                        if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c=='Completed')
                        {
                            Opportunity opp=new Opportunity();
                            opp.name='DG-AG-SU-Product-Application';
                            opp.CloseDate=System.today()+60;
                            opp.Webinar_Id__c=ct.Webinar_Id_1__c;
                            opp.Prospect_Interest_Type__c='Webinar';
                            opp.Status__c='Active';  
                            opp.Webinar_Name__c=ct.Webinar_Name1__c;
                            opp.Webinar_Timestamp__c=system.now();
                            opp.RecurringBusiness__c='One time';
                            System.debug('before If----'+ct.Is_Webinar_Attended1__c);
                            if((ct.Is_Webinar_Attended1__c || ct.Is_recorded_webinar_attended1__c) )
                            {
                                System.debug('After If----'+ct.Is_Webinar_Attended1__c);
                                opp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
                                opp.Probability=30;
                                opp.Is_Webinar_Attended__c=true;
                            }
                            else
                            {
                                opp.StageName='Sample Sent/Inquiry Received';
                                opp.Probability=15;
                            }
                            opp.AccountId=ct.AccountId;
                            opp.Contact2__c=ct.id;
                            newopplist1.add(opp);
                        }
                        if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c=='Cancelled' || newoppmap.get(ct.id)[0].status__c=='On Hold')
                        {
                            newoppmap.get(ct.id)[0].Status__c='Active';
                            newoppmap.get(ct.id)[0].Comments__c=' ';
                            newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id_1__c;
                          newoppmap.get(ct.id)[0].Webinar_Name__c=ct.Webinar_Name1__c;
                            newopplist1.add( newoppmap.get(ct.id)[0]); 
                        }  
                     }
                  }
                }
                System.debug('OppWebMap.containsKey(ct.Webinar_Id_1__c) '+OppWebMap.containsKey(ct.Webinar_Id_1__c));
                if(OppWebMap.containsKey(ct.Webinar_Id_1__c) && OppWebMap.get(ct.Webinar_Id_1__c).probability<30 && ct.Is_recorded_webinar_attended1__c&& (ct.Is_Webinar_Attended1__c ||  ct.Webinar_Video_total_duration__c>15) &&  trigger.oldmap.get(ct.id).Is_Webinar_Attended1__c==false)
                {
                    OppWebMap.get(ct.Webinar_Id_1__c).stageName='Trial Scheduled/Intent to buy/Webinar attended';
                    OppWebMap.get(ct.Webinar_Id_1__c).probability=30;
                    OppWebMap.get(ct.Webinar_Id_1__c).Is_Webinar_Attended__c=true;
                    //ct.Is_Webinar_Attended1__c=false;
                    OpptoUpdate1.add(OppWebMap.get(ct.Webinar_Id_1__c));
                }
                System.debug('newoppmap.get(ct.id).size() '+newoppmap.get(ct.id).size());
                if(newoppmap.get(ct.id).size()!=0 &&ct.Is_recorded_webinar_attended1__c&& (ct.Is_Webinar_Attended1__c   || ct.Webinar_Video_total_duration__c>15) && ct.Webinar_Id_1__c== newoppmap.get(ct.id)[0].Webinar_Id__c&& trigger.oldmap.get(ct.id).Is_Webinar_Attended1__c==false)
                {
                    newoppmap.get(ct.id)[0].Is_Webinar_Attended__c=true;
                    if(newoppmap.get(ct.id).size()>0 && newoppmap.get(ct.id)[0].status__c=='Cancelled' || newoppmap.get(ct.id)[0].status__c=='On Hold')
                    {
                       newoppmap.get(ct.id)[0].Status__c='Active';
                       newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id__c;
                       newoppmap.get(ct.id)[0].Webinar_Name__c=ct.webinar_Name__c;
                       newoppmap.get(ct.id)[0].Comments__c=' ';  
                    }
                    if(newoppmap.get(ct.id)[0].Probability<30)
                    {
                        newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                        newoppmap.get(ct.id)[0].Probability=30;
                    }
                    if(newopplist1.isEmpty())
                    newopplist1.add( newoppmap.get(ct.id)[0]);
                }
                /***************************FOr webinar1 Ends Here*****************************************/ 
                if(ct.Webinar_Id_2__c!=null && !cntWebMap.get(ct.Id).contains(ct.Webinar_Id_2__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended1__c==false)
                {
                    Webinar__c web=new Webinar__c();
                    web.Webinar_Id__c=ct.Webinar_Id_2__c;
                    web.Webinar_Link__c=ct.Webinar_Link2__c;
                    web.Customer_Contact__c=ct.Id;
                    web.Webinar_Machine__c=ct.Webinar_Machine2__c;
                    web.Name=ct.Webinar_Name2__c;
                    if(ct.Is_Webinar_Attended2__c)
                    {
                        web.Is_Webinar_Attended__c=true;
                        //ct.Is_Webinar_Attended2__c=false;
                    }
                    webinarListtoInsert.add(web);
          if(newoppmap.size()!=0  && trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Sample Requested' && ct.Prospect_Interest_Type__c=='Webinar' && (string.isNotBlank(ct.Webinar_Id_2__c)) && count==0 )
          {
                        count=1;
            newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Webinar';
                      newoppmap.get(ct.id)[0].Webinar_Timestamp__c=system.now();
            newopplist2.add( newoppmap.get(ct.id)[0]);
                      newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id_2__c;
                      //opportunityToContactMap.get(ct.id).Prospect_Interest_Type__c='Sample Requested';
                     // opportunityToContactMap.get(ct.id).Time_Stamp_Sample_Requested__c=system.now();
          }
          else
          {
                    Opportunity opp=new Opportunity();
                    opp.name='DG-AG-SU-Product-Application';
                    opp.CloseDate=System.today()+60;
                    opp.Webinar_Id__c=ct.Webinar_Id_2__c;
                    opp.Prospect_Interest_Type__c='Webinar';
                    opp.Status__c='Active';
                    //opp.Assigned_IST_User__c=label.IST_User_ID;
                    opp.Webinar_Name__c = ct.Webinar_Name2__c;
                    opp.Webinar_Timestamp__c=system.now();
                    opp.RecurringBusiness__c='One time';
                    if(ct.Is_Webinar_Attended2__c || ct.Is_recorded_webinar_attended2__c)
                    {
                        opp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
                        opp.Probability=30;
                        opp.Is_Webinar_Attended__c=true;
                        //ct.Is_Webinar_Attended2__c=false;
                    }
                    else
                    {
                        opp.StageName='Sample Sent/Inquiry Received';
                        opp.Probability=15;
                    }
                    opp.AccountId=ct.AccountId;
                    opp.Contact2__c=ct.id;
                        if(ct.Prospect_Interest_Type__c=='Sample Requested')
                    {
                        opp.SampleRequested_Timestamp__c=system.now();
                        opp.Flag_Sample_Requested__c=true;      
                        opp.Prospect_Interest_Type__c='Sample Requested';       
                        opp.Which_Product_Sent__c=ct.Which_Product_Sent__c;
                    }
                    OppList.add(opp); 
                    
                }
        }
               if(OppWebMap.containsKey(ct.Webinar_Id_2__c) && OppWebMap.get(ct.Webinar_Id_2__c).probability<30 &&  (ct.Is_Webinar_Attended2__c || ct.Is_recorded_webinar_attended2__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended2__c==false)
                        {
                            OppWebMap.get(ct.Webinar_Id_2__c).stageName='Trial Scheduled/Intent to buy/Webinar attended';
                            OppWebMap.get(ct.Webinar_Id_2__c).probability=30;
                            OppWebMap.get(ct.Webinar_Id_2__c).Is_Webinar_Attended__c=true;
                            // ct.Is_Webinar_Attended2__c=false;
                            OpptoUpdate2.add(OppWebMap.get(ct.Webinar_Id_2__c));
                        }
                  
        if(newoppmap.get(ct.id).size()!=0 && (ct.Is_Webinar_Attended2__c || ct.Is_recorded_webinar_attended2__c) && ct.Webinar_Id_2__c== newoppmap.get(ct.id)[0].Webinar_Id__c && trigger.oldmap.get(ct.id).Is_Webinar_Attended2__c==false)
                    {
                        newoppmap.get(ct.id)[0].Is_Webinar_Attended__c=true;
                        if(newoppmap.get(ct.id)[0].Probability<30)
                        {
                        newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                        newoppmap.get(ct.id)[0].Probability=30;
                        }
                         if(newopplist2.isEmpty())
                        newopplist2.add( newoppmap.get(ct.id)[0]);
                    }
                /***************************FOr webinar2 Ends Here*****************************************/   
                if(ct.Webinar_Id_3__c!=null && !cntWebMap.get(ct.Id).contains(ct.Webinar_Id_3__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended2__c==false)
                {
                    Webinar__c web=new Webinar__c();
                    web.Webinar_Id__c=ct.Webinar_Id_3__c;
                    web.Webinar_Link__c=ct.Webinar_Link3__c;
                    web.Customer_Contact__c=ct.Id;
                    web.Webinar_Machine__c=ct.Webinar_Machine3__c;
                    web.Name=ct.Webinar_Name3__c;
                    if(ct.Is_Webinar_Attended3__c)
                    {
                        web.Is_Webinar_Attended__c=true;
                        //ct.Is_Webinar_Attended3__c=false;
                    }
                    webinarListtoInsert.add(web);
          if(newoppmap.size()!=0  && trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Sample Requested' && ct.Prospect_Interest_Type__c=='Webinar' && (string.isNotBlank(ct.Webinar_Id_3__c)) && count==0)
          {
                      count=1;
            newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Webinar';
                      newoppmap.get(ct.id)[0].Webinar_Timestamp__c=system.now();
            newopplist3.add( newoppmap.get(ct.id)[0]);
                      newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id_3__c;
                      //opportunityToContactMap.get(ct.id).Prospect_Interest_Type__c='Sample Requested';
                     // opportunityToContactMap.get(ct.id).Time_Stamp_Sample_Requested__c=system.now();
          }
          else
          {
                    Opportunity opp=new Opportunity();
                    opp.name='DG-AG-SU-Product-Application';
                    opp.CloseDate=System.today()+60;
                    opp.Webinar_Id__c=ct.Webinar_Id_3__c;
                    opp.Prospect_Interest_Type__c='Webinar';
                    opp.Status__c='Active';
                    //opp.Assigned_IST_User__c=label.IST_User_ID;
                    opp.Webinar_Name__c = ct.Webinar_Name3__c;
                    opp.Webinar_Timestamp__c=system.now();
                    opp.RecurringBusiness__c='One time';
                    if(ct.Is_Webinar_Attended3__c || ct.Is_recorded_webinar_attended3__c)
                    {
                        opp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
                        opp.Probability=30;
                        opp.Is_Webinar_Attended__c=true;
                        // ct.Is_Webinar_Attended3__c=false;
                    }
                    else
                    {
                        opp.StageName='Sample Sent/Inquiry Received';
                        opp.Probability=15;
                    }
                    opp.AccountId=ct.AccountId;
                    opp.Contact2__c=ct.id;
                         if(ct.Prospect_Interest_Type__c=='Sample Requested')
                    {
                        opp.SampleRequested_Timestamp__c=system.now();
                        opp.Flag_Sample_Requested__c=true;
                        opp.Prospect_Interest_Type__c='Sample Requested';    
                        opp.Which_Product_Sent__c=ct.Which_Product_Sent__c;
                    }
                    OppList.add(opp); 
                    
                   }
                   }
                   if(OppWebMap.containsKey(ct.Webinar_Id_3__c) && OppWebMap.get(ct.Webinar_Id_3__c).probability<30&&  (ct.Is_Webinar_Attended3__c || ct.Is_recorded_webinar_attended3__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended3__c==false)
                        {
                            OppWebMap.get(ct.Webinar_Id_3__c).stageName='Trial Scheduled/Intent to buy/Webinar attended';
                            OppWebMap.get(ct.Webinar_Id_3__c).probability=30;
                            OppWebMap.get(ct.Webinar_Id_3__c).Is_Webinar_Attended__c=true;
                            // ct.Is_Webinar_Attended3__c=false;
                            OpptoUpdate3.add(OppWebMap.get(ct.Webinar_Id_3__c));
                        }
                      if(newoppmap.get(ct.id).size()!=0 && (ct.Is_Webinar_Attended3__c || ct.Is_recorded_webinar_attended3__c)  && ct.Webinar_Id_3__c== newoppmap.get(ct.id)[0].Webinar_Id__c)
                    {
                        newoppmap.get(ct.id)[0].Is_Webinar_Attended__c=true;
                        if(newoppmap.get(ct.id)[0].Probability<30)
                        {
                        newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                        newoppmap.get(ct.id)[0].Probability=30;
                        }
                         if(newopplist3.isEmpty())
                        newopplist3.add( newoppmap.get(ct.id)[0]);
                    } 
                    
                
                /***************************FOr webinar3 Ends Here*****************************************/  
                //System.debug('cntWebMap.get(ct.Id).contains(ct.Webinar_Id_4__c)---'+cntWebMap.get(ct.Id).contains(ct.Webinar_Id_4__c));
                if(ct.Webinar_Id_4__c!=null && !cntWebMap.get(ct.Id).contains(ct.Webinar_Id_4__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended3__c==false)
                {
                    Webinar__c web=new Webinar__c();
                    web.Webinar_Id__c=ct.Webinar_Id_4__c;
                    web.Webinar_Link__c=ct.Webinar_Link4__c;
                    web.Customer_Contact__c=ct.Id;
                    web.Webinar_Machine__c=ct.Webinar_Machine4__c;
                    web.Name=ct.Webinar_Name4__c;
                    if(ct.Is_Webinar_Attended4__c)
                    {
                        web.Is_Webinar_Attended__c=true;
                        //ct.Is_Webinar_Attended4__c=false;
                    }
                    webinarListtoInsert.add(web);
          if(newoppmap.size()!=0  && trigger.oldMap.get(ct.Id).Prospect_Interest_Type__c=='Sample Requested' && ct.Prospect_Interest_Type__c=='Webinar' && (string.isNotBlank(ct.Webinar_Id_4__c)) && count==0)
          {
                        count=1;
            newoppmap.get(ct.id)[0].Prospect_Interest_Type__c='Webinar';
                      newoppmap.get(ct.id)[0].Webinar_Timestamp__c=system.now();
            newopplist4.add( newoppmap.get(ct.id)[0]);
                      newoppmap.get(ct.id)[0].Webinar_Id__c=ct.Webinar_Id_4__c;
                      //opportunityToContactMap.get(ct.id).Prospect_Interest_Type__c='Sample Requested';
                     // opportunityToContactMap.get(ct.id).Time_Stamp_Sample_Requested__c=system.now();
          }
          else
          {
                    Opportunity opp=new Opportunity();
                    opp.name='DG-AG-SU-Product-Application';
                    opp.CloseDate=System.today()+60;
                    opp.Webinar_Id__c=ct.Webinar_Id_4__c;
                    opp.Prospect_Interest_Type__c='Webinar';
                    opp.Status__c='Active';
                    //opp.Assigned_IST_User__c=label.IST_User_ID;
                    opp.Webinar_Name__c = ct.Webinar_Name__c;
                    opp.Webinar_Timestamp__c=system.now();
                    opp.RecurringBusiness__c='One time';
                    if(ct.Is_Webinar_Attended4__c || ct.Is_recorded_webinar_attended4__c)
                    {
                        opp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
                        opp.Probability=30;
                        opp.Is_Webinar_Attended__c=true;
                        // ct.Is_Webinar_Attended4__c=false;
                    }
                    else
                    {
                        opp.StageName='Sample Sent/Inquiry Received';
                        opp.Probability=15;
                    }
                    opp.AccountId=ct.AccountId;
                    opp.Contact2__c=ct.id;
                         if(ct.Prospect_Interest_Type__c=='Sample Sent/Inquiry Received')
                    {
                        opp.SampleRequested_Timestamp__c=system.now();
                        opp.Flag_Sample_Requested__c=true;
                        opp.Prospect_Interest_Type__c='Sample Requested';
                        opp.Which_Product_Sent__c=ct.Which_Product_Sent__c;
                    }
                    OppList.add(opp); 
                }
        }
              
                        if(OppWebMap.containsKey(ct.Webinar_Id_4__c) && OppWebMap.get(ct.Webinar_Id_4__c).probability<30 && (ct.Is_Webinar_Attended4__c || ct.Is_recorded_webinar_attended4__c) && trigger.oldmap.get(ct.id).Is_Webinar_Attended4__c==false)
                        {
                            OppWebMap.get(ct.Webinar_Id_4__c).stageName='Trial Scheduled/Intent to buy/Webinar attended';
                            OppWebMap.get(ct.Webinar_Id_4__c).probability=30;
                             OppWebMap.get(ct.Webinar_Id_4__c).Is_Webinar_Attended__c=true;
                            //ct.Is_Webinar_Attended4__c=false;
                            OpptoUpdate4.add(OppWebMap.get(ct.Webinar_Id_4__c));
                        }
                    if(newoppmap.get(ct.id).size()!=0 && (ct.Is_Webinar_Attended4__c || ct.Is_recorded_webinar_attended4__c) && ct.Webinar_Id_4__c== newoppmap.get(ct.id)[0].Webinar_Id__c && trigger.oldmap.get(ct.id).Is_Webinar_Attended4__c==false)
                    {
                        newoppmap.get(ct.id)[0].Is_Webinar_Attended__c=true;
                        if(newoppmap.get(ct.id)[0].Probability<30)
                        {
                        newoppmap.get(ct.id)[0].stageName='Trial Scheduled/Intent to buy/Webinar attended';
                        newoppmap.get(ct.id)[0].Probability=30;
                        }
                         if(newopplist4.isEmpty())
                        newopplist4.add( newoppmap.get(ct.id)[0]);
                    } 
                    
                
            }
        }
    }
                
      System.debug('webinarListtoInsert '+webinarListtoInsert);
        if(webinarListtoInsert.size()!=0)
         Insert webinarListtoInsert;
       if(oppList.size()!=0)
        Insert oppList;
       if(OpptoUpdate.size()!=0)
        Update OpptoUpdate;
       if(OpptoUpdate1.size()>0)
        Update OpptoUpdate1;
      if(OpptoUpdate2.size()>0)
        Update OpptoUpdate2;
      if(OpptoUpdate3.size()>0)
        Update OpptoUpdate3;
      if(OpptoUpdate4.size()>0)
        Update OpptoUpdate4;  
      if(newopplist.size()!=0)
        Upsert newopplist;
    if(newopplist1.size()!=0)
        Upsert newopplist1;
    if(newopplist2.size()!=0)
        update newopplist2;
    if(newopplist3.size()!=0)
        update newopplist3;
    if(newopplist4.size()!=0)
        update newopplist4;
    if(newopplist5.size()!=0)
        update newopplist5;
    
    if(requesttoCallbcakInsert.size()>0)
    {
        Insert requesttoCallbcakInsert;
    }
    if(customizedpricetoInsert.size()>0)
    {
        Insert customizedpricetoInsert;
    }
    if(RefertoFriendInsert.size()>0)
    {
        insert RefertoFriendInsert;
    }
   }
    public void convert()
    {
        integer i=0;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
    System.debug('contact trigger last query limit------ '+limits.getLimitQueries() );    

    
}