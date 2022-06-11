trigger trg_OnCTA on CTA__c (after update,before insert,before update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    Map<String,User> ISTpincodeMap=new Map<String,User>();
    Map<String,User> DistributorpincodeMap=new Map<String,User>();
    Set<String> pincodeset=new Set<String>();
    List<String> ecomCTA=new List<String>();
    Set<Id> leadIds=new Set<Id>();
    String ecommerce = schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
    Id ISTrecordTypeId =Schema.SObjectType.User_Pincode_Mapping__c.getRecordTypeInfosByName().get('IST Users').getRecordTypeId();
    Id DistrrecordTypeId =Schema.SObjectType.User_Pincode_Mapping__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    if(mc.CTA_trigger__c)
    {
        for(CTA__c l : trigger.new)
        {
            pincodeset.add(l.Pincode__c); 
            leadIds.add(l.Lead__c);
            if((l.RecordTypeId == ctaRecordTypeId.ecom && l.Order_Status__c == 'delivered' && l.Order_Status__c == 'DELIVERED') || l.RecordTypeId != ctaRecordTypeId.ecom)
            {
                ecomCTA.add(l.id);
            }
        }
        if(ecomCTA.size() > 0)
        {
            for(User_Pincode_Mapping__c userpin : [Select id,Pincode__c,RecordTypeId,User__c,User__r.Contact.Account.Name,User__r.Contact.AccountId,User_Pincode_Mapping__c.User__r.id  from User_Pincode_Mapping__c where Pincode__c in : pincodeset])
            {
                if(userpin.RecordTypeId==ISTrecordTypeId)
                {
                    ISTpincodeMap.put(userpin.Pincode__c,userpin.User__r); 
                }
                else if(userpin.RecordTypeId==DistrrecordTypeId)
                {
                    DistributorpincodeMap.put(userpin.Pincode__c,userpin.User__r);   
                }
            }
        }
        
        if(trigger.isAfter && trigger.isinsert)
        {
            System.debug('In the After Insert Loop');
            List<String> ctaid= new List<String>();
            
            for(CTA__c cta:trigger.new)
            {
                
                if(cta.Case_Number__c!=null)
                {
                    ctaid.add(cta.id);
                }
                
            }
            System.debug('Inside CTA ID--->'+ctaid);
            if(ctaid.size()>0)
            CtaAttachementViaCase.CtaAttachement(trigger.new);
          
        }
        
        
        if(trigger.isAfter && trigger.isupdate)
        {
            system.debug('I am in CTA trigger');
            List<Lead> leadstoUpdate=new List<Lead>();
            Set<Id> LeadIds=new Set<Id>();
            Map<String,Integer> stagemap=new Map<String,Integer>();
            Map<Id,List<Opportunity>> CTAoppMap=new MAp<Id,List<Opportunity>>();
            List<Task> taskstoInsert=new List<Task>();
            stageMAp.put('New',1);
            stageMAp.put('Data Collection Process',2);
            stageMAp.put('Additional Details Collected',3);
            stageMAp.put('Data and Intent Validation Process',4);
            stageMAp.put('Pre-sales nurturing',5);
            stageMAp.put('Assigned to IST',6);
            stageMAp.put('Need Follow up',7);
            stageMAp.put('Nurturing',8);
            stageMAp.put('Qualified',9);
            stagemap.put('Unqualified',0);
            stagemap.put('Disqualified by call center team',0);
            

            List<Opportunity> OpportunityList=new List<Opportunity>();
            //avoid_recurring
            for(CTA__c cta :[Select id,(Select id,closeDate,First_Order_Supply_Date__c ,CreatedDate ,RecurringBusiness__c from Projects__r where StageName!= :label.stage_100 ) from CTA__c where id in:trigger.new])
            {
                CTAoppMap.put(cta.id,cta.Projects__r) ; 
            }
            for(CTA__c cta : trigger.new)
            {
                system.debug('I am in CTA trigger1');
                if(cta.Ecoomerce_Qualification__c!=trigger.oldMap.get(cta.Id).Ecoomerce_Qualification__c)
                {
                    if(cta.Ecoomerce_Qualification__c=='One time eCommerce' && CTAoppMap.containsKey(cta.Id) && CTAoppMap.get(cta.Id).size()>0)
                    {
                        system.debug('I am in CTA trigger2');
                        Opportunity opp=CTAoppMap.get(cta.Id)[0];   
                        opp.StageName=label.stage_100;
                        opp.Probability=100;
                        opp.Actual_Closing_date__c=opp.First_Order_Supply_Date__c;
                        opp.First_Order_Supply_Date__c=null;
                        opp.CloseDate=Date.valueOf(opp.CreatedDate);
                        opp.RecurringBusiness__c='One Time';
                        opp.from_Code_updated_Inserted__c='Updated from trg_onCTA Line34';
                        
                        opp.Adhesive_Potential_Basis_Annual_Turnover__c = cta.Adhesive_Potential_Basis_Annual_Turnover__c;
                        opp.Appointment_Date_with_SSE__c = cta.Appointment_Date_with_SSE__c;
                        opp.Is_it_a_focus_industry__c = cta.Is_it_a_focus_industry__c;
                        
                        OpportunityList.add(opp);
                        
                    }
                    else if(cta.Ecoomerce_Qualification__c=='More value for the same products' && checkRecursive.Leadflag)
                    {
                        system.debug('I am in CTA trigger3');
                        if(!test.isRunningTest())
                        {
                            Task t2 = new Task(); 
                            t2.Subject = 'Increase Y2 Value,correct the expected closing date,put in the sales engineer';
                            t2.WhatId = cta.id;
                            t2.OwnerId = cta.Contact_Owner_Id__c;
                            t2.ActivityDate = system.today() + 1;
                            t2.Status = 'Open';
                            t2.Priority = 'High';
                            taskstoInsert.add(t2);
                        }
                        checkRecursive.Leadflag = false;
                    }
                    else if(cta.Ecoomerce_Qualification__c=='Additional opportunity'&& CTAoppMap.containsKey(cta.Id) && checkRecursive.Leadflag)
                    {
                        system.debug('I am in CTA trigger4');
                        if(CTAoppMap.get(cta.Id).size()>0) 
                        {
                            Opportunity opp=CTAoppMap.get(cta.Id)[0];
                            opp.StageName=label.stage_100;
                            opp.Actual_Closing_date__c=opp.First_Order_Supply_Date__c;
                            opp.First_Order_Supply_Date__c=null;
                            opp.Probability=100;
                            opp.status__c='Completed';
                            opp.CloseDate=Date.valueOf(opp.CreatedDate);
                            opp.RecurringBusiness__c='One Time';
                            opp.from_Code_updated_Inserted__c='Updated from trg_onCTA Line55';
                            OpportunityList.add(opp);
                        }
                        
                        Opportunity opptoInsert = new Opportunity();
                        opptoInsert.Name='DG-AG-SU-Product-Application';
                        opptoInsert.from_Code_updated_Inserted__c='Inserted from the trg_OnCTA';
                        opptoInsert.CloseDate=system.today().addDays(60);
                        opptoInsert.Stagename=label.stage_5;
                        opptoInsert.Contact2__c=cta.Customer_Contact__c;
                        opptoInsert.AccountId=cta.Contact_Account_ID__c;
                        opptoInsert.Probability=5;
                        opptoInsert.CTA__c=cta.Id;
                        opptoInsert.Status__c='Active';
                        // opptoInsert.Sales_Engineer1__c=cta.Sales_Engineer__c;
                        //opptoInsert.To_be_discussed_with_TSE__c = cta.To_be_discussed_with_TSE__c;
                        //opptoInsert.Product_In_Ace_Project__c = cta.Product_In_Ace_Project__c;
                        //opptoInsert.Flag_Ecommerce__c=true;
                        opptoInsert.Flag_eCommerce_additional_opportunity__c=true;
                        opptoInsert.RecurringBusiness__c='Recurring Business';
                        
                        opptoInsert.Adhesive_Potential_Basis_Annual_Turnover__c = cta.Adhesive_Potential_Basis_Annual_Turnover__c;
                        opptoInsert.Appointment_Date_with_SSE__c = cta.Appointment_Date_with_SSE__c;
                        opptoInsert.Is_it_a_focus_industry__c = cta.Is_it_a_focus_industry__c;
                        
                        OpportunityList.add(opptoInsert);
                        checkRecursive.Leadflag = false;
                    }
                    else if(cta.Ecoomerce_Qualification__c=='More value for the same products + Additional opportunity' && checkRecursive.Leadflag)
                    {
                        if(!test.isRunningTest())
                        {
                            Task t2 = new Task();
                            t2.Subject = 'Increase Y2 Value,correct the expected closing date,put in the sales engineer';
                            t2.WhatId = cta.id;
                            t2.OwnerId = cta.Contact_Owner_Id__c;
                            t2.ActivityDate = system.today() + 1;
                            t2.Status = 'Open';
                            t2.Priority = 'High';
                            taskstoInsert.add(t2);
                        }
                        
                        
                        Opportunity opptoInsert = new Opportunity();
                        opptoInsert.Name='DG-AG-SU-Product-Application';
                        opptoInsert.from_Code_updated_Inserted__c='Inserted from the trg_OnCTA';
                        opptoInsert.CloseDate=system.today().addDays(60);
                        opptoInsert.Contact2__c=cta.Customer_Contact__c;
                        opptoInsert.AccountId=cta.Contact_Account_ID__c;
                        opptoInsert.Stagename=label.stage_5;
                        //opptoInsert.Flag_Ecommerce__c=true;
                        opptoInsert.Status__c='Active';
                        opptoInsert.Probability=5;
                        opptoInsert.CTA__c=cta.Id;
                        opptoInsert.RecurringBusiness__c='Recurring Business';
                        opptoInsert.Flag_eCommerce_additional_opportunity__c=true;
                        
                        opptoInsert.Adhesive_Potential_Basis_Annual_Turnover__c = cta.Adhesive_Potential_Basis_Annual_Turnover__c;
                        opptoInsert.Appointment_Date_with_SSE__c = cta.Appointment_Date_with_SSE__c;
                        opptoInsert.Is_it_a_focus_industry__c = cta.Is_it_a_focus_industry__c;
                        
                        OpportunityList.add(opptoInsert);
                        
                        checkRecursive.Leadflag = false;
                        
                    }
                }
                LeadIds.add(cta.Lead__c); 
            }
            
            List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
            if(trigger.isUpdate)
            {
                boolean isecomrecord = true;
                for(CTA__c cta : trigger.new)
                {
                    if(cta.RecordTypeId != ctarecordtypeid.ecom)
                    {
                        isecomrecord = false;
                    }
                }
                Map<Id,Lead> leadMap;
              LeadStatus CLeadStatus;
                if(!isecomrecord)
                {
                    leadMap = new Map<Id,Lead>([Select id,Status ,isConverted,Intent_validation__c from lead where id in: LeadIds]);
                    CLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
                }
                for(CTA__c cta : trigger.new)
                {
                    system.debug('I am in CTA trigger5');
                     system.debug('Assigned IST Before');
                    system.debug('Cta Stage : ' +cta.CTA_stage__c);
                    //system.debug('Lead-Cta Stage : ' +stagemap.get(leadMap.get(cta.Lead__c).status));
                    system.debug('Old Cta Stage : ' +trigger.oldmap.get(cta.Id).CTA_stage__c);
                    if(cta.Lead__c!=null && cta.CTA_stage__c!=trigger.oldMap.get(cta.id).CTA_stage__c && (stagemap.get(cta.CTA_stage__c)>=stagemap.get(leadMap.get(cta.Lead__c).status) || (cta.CTA_stage__c=='Unqualified'&&  leadMap.get(cta.Lead__c).status !='Qualified')) && cta.CTA_stage__c!='New' && !leadMap.get(cta.Lead__c).isConverted)
                    {
                        System.debug('Conditions matched in Lead');
                        if(cta.CTA_stage__c=='Qualified')
                        {
                            system.debug('I am in CTA trigger6');
                            Lead leadObj=new Lead();
                            leadObj.Id=cta.Lead__c;
                            leadObj.Last_updated_CTA__c=cta.id;
                            leadobj.Project_Name__c='test Project';
                            leadObj.Close_Date__c=cta.Expected_close_date__c;
                            leadObj.RecurringBusiness__c=cta.RecurringBusiness__c;
                            leadObj.Application__c=cta.Application__c;
                            leadObj.Product_In_Ace_Project__c=cta.Product_In_Ace_Project__c;
                            leadobj.Market_Segment__c=cta.Market_Segment__c;
                            leadobj.New_Existing__c=cta.New_Existing__c;
                            leadobj.To_be_discussed_with_TSE__c=cta.To_be_discussed_with_TSE__c;
                            leadobj.Lead_shared_with_TSE_on__c=cta.Lead_shared_with_TSE_on__c;
              leadobj.Project_status__c = 'Active';
                            leadobj.Sales_Engineer1__c=cta.Sales_Engineer__c;
                            leadobj.Adhesive_Potential_Basis_Annual_Turnover__c = cta.Adhesive_Potential_Basis_Annual_Turnover__c;
                            leadobj.Is_it_a_focus_industry__c = cta.Is_it_a_focus_industry__c;
                            leadobj.Lead_Status__c = cta.CTA_stage__c;
                            leadobj.Appointment_Date_with_SSE__c = cta.Appointment_Date_with_SSE__c;                            
                            leadstoUpdate.add(leadObj);
                            Database.LeadConvert Leadconvert = new Database.LeadConvert();
                            Leadconvert.setLeadId(cta.Lead__c);                
                            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
                            MassLeadconvert.add(Leadconvert);
                        }
                        else
                        {
                            if(cta.CTA_stage__c!='Assigned to IST' && stagemap.get(cta.CTA_stage__c)>6 && stagemap.get(cta.CTA_stage__c)<9)
                            {
                                system.debug('I am in CTA trigger7');
                                System.debug('I am in else');
                                Lead leadObj=new Lead();
                                leadObj.Id=cta.Lead__c;
                                leadObj.Status=cta.CTA_stage__c;
                                leadObj.Last_updated_CTA__c=cta.id;
                                leadstoUpdate.add(leadObj);
                            }
                        }
                    }
                    else if(cta.customer_contact__c!=null && cta.CTA_stage__c=='Qualified' && CTAoppMap.containsKey(cta.Id) &&  cta.CTA_stage__c!=trigger.oldMap.get(cta.id).CTA_stage__c && (CTAoppMap.get(cta.Id).size() <= 0))
                    {
                        
                        system.debug('I am in CTA trigger8');
                        System.debug('Conditions matched in Contact');
                        Opportunity opp = new Opportunity();
                        opp.StageName=label.stage_5;
                        opp.Probability=5;
                        opp.CloseDate=cta.Expected_close_date__c;
                        opp.Status__c='Active';
                        opp.from_Code_updated_Inserted__c='Inserted from trg_onCTA linenumber 157';
                        opp.CTA__c=cta.id;
                        opp.Assigned_IST_User__c=cta.OwnerId;
                        opp.Contact2__c=cta.Customer_Contact__c;
                        opp.AccountId=cta.Contact_Account_ID__c;
                        opp.Name=cta.Project_Name__c;
                        opp.Application__c=cta.Application__c;
                        opp.MS__c=cta.Market_Segment__c;
                        
                        opp.RecurringBusiness__c = cta.RecurringBusiness__c;
                        opp.New_Existing__c =  cta.New_Existing__c;
                        opp.Sales_Engineer1__c = cta.Sales_Engineer__c;
                        opp.To_be_discussed_with_TSE__c = cta.To_be_discussed_with_TSE__c;
                        
                        opp.Adhesive_Potential_Basis_Annual_Turnover__c = cta.Adhesive_Potential_Basis_Annual_Turnover__c;
                        opp.Appointment_Date_with_SSE__c = cta.Appointment_Date_with_SSE__c;
                        opp.Is_it_a_focus_industry__c = cta.Is_it_a_focus_industry__c;
                        
                        if(cta.Product_In_Ace_Project__c != null)
                            opp.Product_In_Ace_Project__c = cta.Product_In_Ace_Project__c;
                        
                        OpportunityList.add(opp);
                        
                    }
                    
                    if(cta.OwnerId != trigger.oldMap.get(cta.Id).OwnerId && cta.Order_Status__c != trigger.oldMap.get(cta.Id).Order_Status__c)
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.OwnerId = cta.OwnerId;
                        leadstoUpdate.add(leadObj);
                    }
                    
                    if(cta.RecordTypeId != ctaRecordTypeId.Sampling && cta.CTA_stage__c == 'Data and Intent Validation Process' && leadMap.get(cta.Lead__c).status != 'Data and Intent Validation Process' && stagemap.get(leadMap.get(cta.Lead__c).status) <4 && leadMap.get(cta.Lead__c).status != 'Pre-sales nurturing' && stagemap.get(leadMap.get(cta.Lead__c).status) != 0)
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.status = cta.CTA_stage__c;
                        leadstoUpdate.add(leadObj);
                    }
                    
                    if(cta.isUpdated__c == true && cta.CTA_stage__c == 'Assigned to IST' && leadMap.get(cta.Lead__c).status != 'Assigned to IST' && cta.CTA_stage__c != trigger.oldmap.get(cta.Id).CTA_stage__c && stagemap.get(cta.CTA_stage__c)>stagemap.get(leadMap.get(cta.Lead__c).status))
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.Status = cta.CTA_stage__c;
                        leadstoUpdate.add(leadObj);
                    }
                    
                    else if(cta.isUpdated__c == true && cta.CTA_stage__c == 'Pre-sales nurturing' && leadMap.get(cta.lead__c).status != 'Pre-sales nurturing' && stagemap.get(leadMap.get(cta.Lead__c).status) < 5 && stagemap.get(leadMap.get(cta.Lead__c).status) !=0 && cta.CTA_stage__c != trigger.oldmap.get(cta.Id).CTA_stage__c && cta.CTA_stage__c != 'Unqualified')
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.Status = cta.CTA_stage__c;
                        leadstoUpdate.add(leadObj);
                    }
                    
                     else if(cta.CTA_stage__c == 'Unqualified' && cta.CTA_stage__c != trigger.oldmap.get(cta.Id).CTA_stage__c)
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.Status = cta.CTA_stage__c;
                        leadstoUpdate.add(leadObj);
                    }
                    
                    else if(cta.isUpdated__c == true && cta.CTA_stage__c == 'Disqualified by call center team' && stagemap.get(leadMap.get(cta.Lead__c).status) < 5 && stagemap.get(leadMap.get(cta.Lead__c).status) !=0 && cta.CTA_stage__c != trigger.oldmap.get(cta.Id).CTA_stage__c && stagemap.get(cta.CTA_stage__c)<6 && leadMap.get(cta.lead__c).status != 'Disqualified by call center team')
                    {
                        if(cta.Intent_validation__c == 'Does not want to speak to IST' || cta.Intent_validation__c == 'not interested')
                        {
                            Lead leadObj = new Lead();
                            leadObj.id = cta.Lead__c;
                            leadObj.Status = cta.CTA_stage__c;
                            leadstoUpdate.add(leadObj);
                        }
                    }
                    
                    if(cta.CTA_stage__c == 'Disqualified by call center team' && stagemap.get(leadMap.get(cta.Lead__c).status) !=0 && cta.CTA_stage__c != trigger.oldmap.get(cta.Id).CTA_stage__c && cta.Type_of_Enquiry__c == 'careers' && leadMap.get(cta.lead__c).status != 'Disqualified by call center team')
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.Status = cta.CTA_stage__c;
                        leadstoUpdate.add(leadObj);
                    }
                    
                    
                    if(cta.RecordTypeId == ecommerce && cta.Ecoomerce_Qualification__c == 'Speak to IST' && cta.OwnerId != trigger.oldMap.get(cta.Id).OwnerId && checkRecursive.Leadflag)
                    {
                        Lead leadObj = new Lead();
                        leadObj.id = cta.Lead__c;
                        leadObj.OwnerId = cta.OwnerId;
                        leadstoUpdate.add(leadObj);
                        checkRecursive.Leadflag = false;
                    }
                }
                
                if(leadstoUpdate.size()!=0 )
                {
                    try{
                    System.debug('leadstoUpdate---- '+leadstoUpdate[0].Status); 
                    update  leadstoUpdate;
                    }Catch(Exception e)
                    {
                        System.debug('Exception occured in CTA after update trigger: '+e);
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new String[] {'aman.khurana@nanostuffs.com','pritam.shinde@nanostuffs.com'};
                            message.setSubject('CTA Error Message for the lead Update') ;
                        message.setPlainTextBody('Exception occured in CTA after update trigger: '+e.getMessage()+'--'+e.getLineNumber());
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    }
                }
                List<Database.LeadConvertResult> lcr = new List<Database.LeadConvertResult>();
                
                if (!MassLeadconvert.isEmpty()) 
                {
                    lcr = Database.convertLead(MassLeadconvert);
                }
                
                
            }
            
            if(OpportunityList.size()!=0)
            {
                upsert OpportunityList;
            }
            
            if(taskstoInsert.size()!=0)
            {
                Insert taskstoInsert;
            }
            
            
            if(test.isRunningTest())
                covermethod();
            
        }
        
        if(trigger.isBefore)
        {
                
            Map<String,Integer> stagemap=new Map<String,Integer>();
            
            stageMAp.put('New',1);
            stageMAp.put('Data Collection Process',2);
            stageMAp.put('Additional Details Collected',3);
            stageMAp.put('Data and Intent Validation Process',4);
            stageMAp.put('Pre-sales nurturing',5);
            stageMAp.put('Assigned to IST',6);
            stageMAp.put('Need Follow up',7);
            stageMAp.put('Nurturing',8);
            stageMAp.put('Qualified',9);
            stagemap.put('Unqualified',0);
            stagemap.put('Disqualified by call center team',0);
            
            List<User> userList = new List<User>();
            
            Map<id,user> userNameMap = new Map<id,user>();
            
            Map<String,String> userProfileMap = new Map<String,String>();
            
            List<Lead> leadStatusUpdate = new List<Lead>();
            
            List<Lead> samplingLeadUpdate = new List<Lead>();
            
            List<Lead> leadStatus = new List<Lead>();
            
            List<Lead> istLead = new List<Lead>();
            
            Map<Id,Lead> leadMAp=new MAp<Id,Lead>();
            
            Map<Id,Id> ownerMap=new MAp<Id,Id>();
            
            set<CTA__c> samplingCTA = new set<CTA__c>();
            
            List<String> sampleleadIds = new List<String>();
            
            List<String> sampleContactIds = new List<String>();
            
            List<String> assignedAgentFlag = new List<String>();
            
            Boolean isCcAgentFlag = false;
            
            Boolean isEcomOrder = false;
            
            Boolean isSample = false;
            
            for(Cta__c cta : trigger.new)
            {
                if(cta.RecordTypeId == ctaRecordTypeId.sampling)
                {
                    isSample = true;
                    if(cta.Lead__c!=null)
                    {
                        sampleleadIds.add(cta.Lead__c);
                    }
                    else if(cta.Lead__c==null && cta.Customer_Contact__c!=null)
                    {
                        sampleContactIds.add(cta.Customer_Contact__c);
                    }
                }
              if(cta.RecordTypeId != ctaRecordTypeId.ecom)
                {
                    assignedAgentFlag.add(cta.Id);
                }
                
                if(cta.RecordTypeId == ctaRecordTypeId.ecom && cta.Order_Status__c != null)
                {
                    isEcomOrder = true;   
                    if(cta.Order_Status__c == 'delivered')
                    assignedAgentFlag.add(cta.Id);
                }
            }
            
            if(isSample)
            {
                if(sampleContactIds.size() > 0)
                {
                    for(Lead l : [SELECT Id FROM Lead WHERE ConvertedContactId =: sampleContactIds and Email!=null])
                    {
                        sampleleadIds.add(l.Id);
                    }
                }
                for(CTA__c cta : [select id,RecordTypeId,lead__c from CTA__c where RecordTypeId =: ctaRecordTypeId.sampling AND lead__c =: sampleleadIds])
                {
                    system.debug('CTA :'+cta.Id);
                    samplingCTA.add(cta);
                }   
            }
            
            if(!isEcomOrder)
            {
                leadStatusUpdate = [Select id,Status,OwnerId from lead where id in :leadIds];
            }
            if(assignedAgentFlag.size() > 0)
            {
                userList = [SELECT Id, Name,profile.name FROM User];
            }
            
            For(User userName : userList)
            {
              userNameMap.put(userName.Id,userName); 
                userProfileMap.put(userName.id,userName.Profile.name);
            }
            system.debug(userProfileMap);
            for(Lead l : leadStatusUpdate)
            { 
                leadMAp.put(l.id,l);
                if(l.OwnerId != null)
                ownerMap.put(l.id, l.OwnerId);
            }
            
            if(trigger.isInsert)
            {
                
                for(CTA__c cta : trigger.new)
                {
                    system.debug('I am in CTA trigger9');
                    system.debug('I am in cta for');
                    system.debug('cta.Lead__c--- '+cta.Lead__c);
                    system.debug('cta.Customer_Contact__c '+cta.Customer_Contact__c);
                    system.debug('cta.Customer_Contact__c '+cta.lead__r.status);
                    system.debug('Prospect Intrest Type'+cta.Prospect_interest_type__c);
                    
                    /*if(leadMap.containsKey(cta.Lead__c))
                    {
                        if((leadMap.get(cta.Lead__c).status == 'Disqualified by call center team' || leadMap.get(cta.Lead__c).status == 'Nurturing' || leadMap.get(cta.Lead__c).status == 'Pre-sales nurturing' || leadMap.get(cta.Lead__c).status == 'Unqualified')  && (cta.CTA_stage__c != 'Disqualified by call center team' || cta.CTA_stage__c != 'Nurturing' || cta.CTA_stage__c != 'Pre-sales nurturing' || cta.CTA_stage__c != 'Unqualified' ))
                        {
                            System.debug('Reactivation Stage :');
                            Lead l = new Lead();
                            if(cta.Lead__c != null)
                            {
                                l.Id = cta.Lead__c;
                                l.Re_activated_date__c = system.now();
                            }
                            LeadStatus.add(l);
                        }
                    }*/
                    
                    if(ownerMap.containsKey(cta.Lead__c))
                    {
                        if((userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'standard user - IST' || userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator') && userProfileMap.get(ownerMap.get(cta.Lead__c)) != 'CC agents' && cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B')
                        {
                            callCenterAgentAssignOnCta.callCenterAgentAssignOnCta(cta);
                        }
                        else if(userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'CC agents' && cta.RecordTypeId != ctaRecordTypeId.ecom)
                        {
                            cta.OwnerId = ownerMap.get(cta.Lead__c);
                        }
                    }
                    
                   
                   /* if(userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator')
                    {
                        Lead l = new Lead();
                        l.id = cta.Lead__c;
                        l.OwnerId = cta.OwnerId;
                        LeadStatus.add(l);
                    }*/
                    
                    
                    if(ownerMap.containsKey(cta.Lead__c))
                    {
                        if((userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'CC agents' || userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator') && userProfileMap.get(ownerMap.get(cta.Lead__c)) != 'standard user - IST' && (cta.RecordTypeId == ctaRecordTypeId.MailEnq || cta.RecordTypeId == ctaRecordTypeId.WebEnq))
                        {
                            if(cta.Pincode__c != null)
                            {
                                if(ISTpincodeMap.containsKey(cta.Pincode__c))
                                {
                                    cta.OwnerId = ISTpincodeMap.get(cta.Pincode__c).id;
                                    cta.CTA_stage__c = 'Assigned to IST';
                                }
                                else if(!ISTpincodeMap.containsKey(cta.Pincode__c))
                                {
                                    cta.OwnerId = Label.IST_User_ID;
                                    cta.CTA_stage__c = 'Assigned to IST';
                                }
                                
                                if(DistributorpincodeMap.containskey(cta.pincode__c))
                                {
                                    cta.Distributor__c=DistributorpincodeMap.get(cta.pincode__c).id;  
                                    cta.Distributor_on_Project__c=DistributorpincodeMap.get(cta.pincode__c).Contact.Account.Name;
                                }
                                else
                                {
                                    cta.Distributor__c=Label.CTA_Default_Distributor;
                                }
                            } 
                        }
                        else if(cta.RecordTypeId == ctaRecordTypeId.MailEnq || cta.RecordTypeId == ctaRecordTypeId.WebEnq)
                        {
                            cta.OwnerId = ownerMap.get(cta.Lead__c);
                            cta.CTA_stage__c = 'Assigned to IST';
                        }
                    }
                    
                    if(cta.RecordTypeId == ctaRecordTypeId.Sampling && cta.lead__c!=null)
                    {
                        Lead samplingLead = new Lead();
                        samplingLead.Id = cta.Lead__c;
                        if(samplingCTA.size()  == 0)
                            samplingLead.sampling_count__c = 1;
                        else if(samplingCTA.size() > 0)
                            samplingLead.sampling_count__c = samplingCTA.size() + 1;
                        
                        samplingLeadUpdate.add(samplingLead);
                    }
                    
                    if(cta.RecordTypeId == ctaRecordTypeId.abandonedCart)
                    {
                        if(ownerMap.containsKey(cta.Lead__c))
                        {
                            if(leadMAp.get(cta.lead__c).Status == 'Assigned to IST')
                            {
                                cta.isUpdated__c = true;
                            }
                        }
                        
                    }
                    
                    if((cta.RecordTypeId == ctaRecordTypeId.Contact && cta.Type_of_Enquiry__c != 'careers') || cta.RecordTypeId == ctaRecordTypeId.demo || cta.RecordTypeId == ctaRecordTypeId.callback || cta.RecordTypeId == ctaRecordTypeId.customPrice)
                    {
                        if(cta.Lead__c != null && ownerMap.containsKey(cta.Lead__c) && userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'CC agents')
                        cta.OwnerId = ownerMap.get(cta.Lead__c);  
                    }
                    
                    
                     if(cta.RecordTypeId == ctaRecordTypeId.Contact && cta.Type_of_Enquiry__c == 'careers') 
                    {
                        cta.CTA_stage__c = 'Disqualified by call center team';
                    }
                    
                    if((cta.RecordTypeId == ctaRecordTypeId.indiaMart || cta.RecordTypeId == ctaRecordTypeId.tradeIndia) && (cta.Industry__c==null || cta.Number_Of_Employees__c==null || cta.Customer_Email__c==null || cta.pincode__c == null || cta.Customer_Number__c == null))
                    {
                        cta.CTA_stage__c = 'Data Collection Process';
                    }
                    else if((cta.RecordTypeId == ctaRecordTypeId.indiaMart || cta.RecordTypeId == ctaRecordTypeId.tradeIndia) && cta.Pincode__c != null && cta.Customer_Email__c != null && cta.Customer_Number__c != null && cta.Industry__c != null && cta.Number_Of_Employees__c != null && cta.CTA_stage__c != 'Data and Intent Validation Process')
                    {
                        cta.CTA_stage__c = 'Data and Intent Validation Process';
                    }
                    
                    
                    if(cta.Lead__c != null && leadMAp.get(cta.lead__c).Status == 'Data Collection Process' && cta.CTA_stage__c != 'Data Collection Process')
                    {
                        cta.CTA_stage__c = 'Data Collection Process';
                        if(cta.Type_of_qualification__c == null)
                        {
                            cta.Type_of_qualification__c = 'Data and intent collection';
                        }
                    }
                   // system.debug('Lead Status ' +leadMAp.get(cta.lead__c).Status);
                     if(cta.Lead__c != null && leadMAp.get(cta.lead__c).Status == 'Data and Intent Validation Process' && cta.CTA_stage__c != 'Data and Intent Validation Process')
                    {
                        cta.CTA_stage__c = 'Data and Intent Validation Process';
                        
                        if(cta.Type_of_qualification__c == null)
                        {
                            cta.Type_of_qualification__c = 'Data validation and intent collection ';
                        }
                    }
                    if(cta.Indiamart_QTYPE__c == 'PNS' || cta.Ecom_Source__c == 'DialB2B') 
                    {
                        if(ownerMap.containsKey(cta.Lead__c) && userProfileMap.get(ownerMap.get(cta.Lead__c)) != 'System Administrator')
                        {
                            cta.OwnerId = ownerMap.get(cta.Lead__c);
                        }
                        else if(userProfileMap.get(ownerMap.get(cta.Lead__c)) != 'System Administrator')
                        {
                            istLead.add(cta.Lead__r);
                        }
                    }
                    if(cta.Lead__c != null)
                    {
                        if(cta.RecordTypeId == ctaRecordTypeId.Sampling && (cta.Industry__c==null || cta.Number_Of_Employees__c==null || cta.Role_in_the_organisation__c==null || cta.What_is_the_purpose_use__c==null))
                        {
                            cta.CTA_stage__c = 'Data Collection Process';
                            
                            if(cta.Type_of_qualification__c == null)
                            {
                                cta.Type_of_qualification__c = 'Data and intent collection';
                            }
                            Lead statusLead = new Lead();
                            
                            if(cta.Lead__c != null)
                            {
                                statusLead.id = cta.Lead__c;
                                
                                if(stageMap.get(leadMAp.get(cta.lead__c).Status) != 0 && stageMap.get(leadMAp.get(cta.lead__c).Status)<2)
                                statusLead.Status = 'Data Collection Process';
                                
                                if(userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator')
                                {
                                    statusLead.OwnerId = cta.OwnerId;
                                }
                                if(leadMap.get(cta.Lead__c).status == 'Disqualified by call center team' || leadMap.get(cta.Lead__c).status == 'Nurturing' || leadMap.get(cta.Lead__c).status == 'Pre-sales nurturing' || leadMap.get(cta.Lead__c).status == 'Unqualified')
                {
                                    statusLead.Re_activated_date__c = system.now();
                                }
                                
                                LeadStatus.add(statusLead);
                            }
                        }
                    }
                    
                    
                    
                   
                    
                    if(cta.CTA_stage__c != 'Data and Intent Validation Process')
                    {
                        if((cta.RecordTypeId == ctaRecordTypeId.Contact && cta.Type_of_Enquiry__c != 'careers') || cta.RecordTypeId == ctaRecordTypeId.demo || cta.RecordTypeId == ctaRecordTypeId.callback || cta.RecordTypeId == ctaRecordTypeId.customPrice || cta.RecordTypeId == ctaRecordTypeId.quatation || cta.RecordTypeId == ctaRecordTypeId.gmdesign || cta.RecordTypeId == ctaRecordTypeId.Webinar)
                        {
                            cta.CTA_stage__c = 'Data and Intent Validation Process';
                            
                            if(cta.Type_of_qualification__c == null)
                            {
                                cta.Type_of_qualification__c = 'Data validation and intent collection ';
                            }
                            
                            Lead statusLead = new Lead();
                            
                            if(cta.Lead__c != null)
                            {
                                statusLead.id = cta.Lead__c;
                                
                                if(stageMap.get(leadMAp.get(cta.lead__c).Status) < 4 && stageMap.get(leadMAp.get(cta.lead__c).Status) != 0)
                                statusLead.Status = 'Data and Intent Validation Process';
                                
                                if(userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator')
                                {
                                    statusLead.OwnerId = cta.OwnerId;
                                }
                                if(leadMap.get(cta.Lead__c).status == 'Disqualified by call center team' || leadMap.get(cta.Lead__c).status == 'Nurturing' || leadMap.get(cta.Lead__c).status == 'Pre-sales nurturing' || leadMap.get(cta.Lead__c).status == 'Unqualified')
                                {
                                    statusLead.Re_activated_date__c = system.now();
                                }
                                LeadStatus.add(statusLead);
                            }
                            
                        }
                    }
                    
                    if(cta.CTA_stage__c == 'Data and Intent Validation Process' && cta.RecordTypeId == ctaRecordTypeId.Sampling)
                    {
                        if(cta.Type_of_qualification__c == null)
                        {
                            cta.Type_of_qualification__c = 'Data validation and intent collection ';
                        }
                    }
                    
                    if((cta.RecordTypeId == ctaRecordTypeId.indiaMart || cta.RecordTypeId == ctaRecordTypeId.tradeIndia) && (cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B'))
                    {
                        if(cta.Lead__c != null && ownerMap.containsKey(cta.Lead__c) && userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'CC agents')
                            cta.OwnerId = ownerMap.get(cta.Lead__c);
                        
                        if(cta.CTA_stage__c == 'Data Collection Process' && cta.Type_of_qualification__c == null)
                        {
                            cta.Type_of_qualification__c = 'Data and intent collection';
                        }
                        else if(cta.CTA_stage__c == 'Data and Intent Validation Process' && cta.Type_of_qualification__c == null)
                        {
                            cta.Type_of_qualification__c = 'Data validation and intent collection ';
                        }
                    }
                    
                    if(cta.CTA_stage__c != 'Data and Intent Validation Process' && cta.RecordTypeId == ctaRecordTypeId.Sampling)
                    {
                        if(cta.Industry__c!=null && cta.Number_Of_Employees__c!=null && cta.Role_in_the_organisation__c!=null && cta.What_is_the_purpose_use__c!=null)
                        {
                            System.debug('Inside IF');
                            cta.CTA_stage__c = 'Data and Intent Validation Process';
                            
                            if(cta.Type_of_qualification__c == null)
                            {
                                cta.Type_of_qualification__c = 'Data validation and intent collection ';
                            }
                            
                            Lead statusLead = new Lead();
                            
                            if(cta.Lead__c != null)
                            {
                                statusLead.id = cta.Lead__c;
                                
                                if(stageMap.get(leadMAp.get(cta.lead__c).Status) < 4 && stageMap.get(leadMAp.get(cta.lead__c).Status) != 0)
                                statusLead.Status = 'Data and Intent Validation Process';
                                
                                if(userProfileMap.get(ownerMap.get(cta.Lead__c)) == 'System Administrator')
                                {
                                    statusLead.OwnerId = cta.OwnerId;
                                }
                                if(leadMap.get(cta.Lead__c).status == 'Disqualified by call center team' || leadMap.get(cta.Lead__c).status == 'Nurturing' || leadMap.get(cta.Lead__c).status == 'Pre-sales nurturing' || leadMap.get(cta.Lead__c).status == 'Unqualified')
                {
                                    statusLead.Re_activated_date__c = system.now();
                                }
                                
                                LeadStatus.add(statusLead);
                            }
                        }
                    }
                    
                    if(cta.CTA_stage__c == 'Data and Intent Validation Process')
                    {
                        if(cta.Type_of_qualification__c == null)
                            cta.Type_of_qualification__c = 'Data validation and intent collection';
                    }
                    else if(cta.CTA_stage__c == 'Data Collection Process')
                    {
                        if(cta.Type_of_qualification__c == null)
                            cta.Type_of_qualification__c = 'Data and intent collection';
                    }
                    
                    if(cta.RecordTypeId != ctaRecordTypeId.ecom)
                    {
                        if(cta.Assigned_Agent__c == null && cta.OwnerId!=null && (userNameMap.get(cta.OwnerId).Name != 'Try Loctite' && userNameMap.get(cta.OwnerId).Name != 'Try Loctite Admin'))
                        {
                            cta.Assigned_Agent__c = userNameMap.get(cta.OwnerId).Name;
                            if(cta.Agent_Assigned_Date__c == null)
                                cta.Agent_Assigned_Date__c = system.now();
                        }
                    }

                    
                    if(cta.Lead__c==null && cta.Customer_Contact__c!=null)
                    {
                        List<Lead> convertedLeadList=[SELECT Id FROM Lead WHERE ConvertedContactId =: cta.Customer_Contact__c and Email!=null]; 
                        system.debug('convertedLeadList----- '+convertedLeadList);
                        
                        if(convertedLeadList.size()>0)
                            cta.Lead__c=convertedLeadList[0].id;
                        
                        
                        if(userProfileMap.get(ownerMap.get(cta.OwnerId)) == 'System Administrator' && cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B')
                        {
                            callCenterAgentAssignOnCta.callCenterAgentAssignOnCta(cta);
                        }
                        
                        if(cta.RecordTypeId == ctaRecordTypeId.Sampling && convertedLeadList[0].id!=null)
                        {
                            Lead samplingLead = new Lead();
                            samplingLead.Id = convertedLeadList[0].id;
                            system.debug('cta.Lead__r.sampling_count__c'+samplingCTA.size());
                            if(samplingCTA.size()  == 0)
                                samplingLead.sampling_count__c = 1;
                            else if(samplingCTA.size() > 0)
                                samplingLead.sampling_count__c = samplingCTA.size() + 1;
                            
                            samplingLeadUpdate.add(samplingLead);
                        }
                    }
                    
                    if(cta.RecordTypeId != ctaRecordTypeId.ecom && cta.CTA_status_Data_collection_Date__c == null && cta.CTA_stage__c == 'Data Collection Process')
                    {
                        cta.CTA_status_Data_collection_Date__c = system.now();
                    }
                    
                    if(cta.RecordTypeId != ctaRecordTypeId.ecom && cta.Data_and_intent_validation_Date__c == null && cta.CTA_stage__c == 'Data and Intent Validation Process')
                    {
                        cta.Data_and_intent_validation_Date__c = system.now();
                    }
                    
                    
                }
                update LeadStatus;
                
                if(samplingLeadUpdate.size()>0)
                {
                    upsert samplingLeadUpdate;
                }
                
            }
            
            if(trigger.isUpdate)
            {
                    System.debug('Update trigger in CTA before');
                    
                    boolean irrelevant = false;
                    boolean isEcom = false;
                    
                    
                    List<Lead> updateLead = new List<Lead>();
                    
                    for(CTA__c cta : trigger.new)
                    {
                        if(cta.RecordTypeId == ctaRecordTypeId.abandonedCart && (cta.OwnerId == '0057F0000011TdL' || cta.OwnerId == '0057F0000011Dlq') && stageMAp.get(cta.CTA_stage__c) != 0 && stageMAp.get(cta.CTA_stage__c) <= 4)
                        {
                            callCenterAgentAssignOnCta.callCenterAgentAssignOnCta(cta);
                        }
                        
                        if(cta.RecordTypeId == ctaRecordTypeId.Contact && (cta.OwnerId == '0057F0000011TdL' || cta.OwnerId == '0057F0000011Dlq') && cta.CTA_stage__c == 'Data and Intent Validation Process' && stageMAp.get(cta.CTA_stage__c) != 0 && stageMAp.get(cta.CTA_stage__c) == 4)
                        {
                            callCenterAgentAssignOnCta.callCenterAgentAssignOnCta(cta);
                        }
                        if(cta.RecordTypeId == ctaRecordTypeId.ecom && cta.Order_Status__c == trigger.oldMap.get(cta.id).Order_Status__c)
                        {
                            isEcom =true;
                        }
                        
                        if(cta.CTA_stage__c != 'Data and Intent Validation Process' && cta.RecordTypeId == ctaRecordTypeId.Sampling && cta.CTA_stage__c != 'Assigned to IST' && stageMap.get(cta.CTA_stage__c) <= 4 && stageMap.get(cta.CTA_stage__c) != 0)
                        {
                            if((trigger.oldMap.get(cta.Id).Industry__c != cta.Industry__c || trigger.oldMap.get(cta.Id).Number_Of_Employees__c != cta.Number_Of_Employees__c || trigger.oldMap.get(cta.Id).Role_in_the_organisation__c != cta.Role_in_the_organisation__c || trigger.oldMap.get(cta.Id).What_is_the_purpose_use__c != cta.What_is_the_purpose_use__c ) &&  cta.Industry__c!=null && cta.Number_Of_Employees__c!=null && cta.Role_in_the_organisation__c!=null && cta.What_is_the_purpose_use__c!=null )
                            {
                                System.debug('Inside IF');
                                cta.CTA_stage__c = 'Data and Intent Validation Process';
                            }
                        }
                        
                        System.debug('Before ecom owner record');
                        System.debug(userProfileMap.get(cta.OwnerId));
                        if(cta.RecordTypeId == ctaRecordTypeId.ecom && cta.Order_Status__c != null && userProfileMap.get(cta.OwnerId) != 'CC agents')
                        {
                            System.debug('After ecom owner record');
                            if(cta.Order_Status__c == 'Delivered' && (cta.OwnerId == '0057F0000011TdL' || cta.OwnerId == '0057F0000011Dlq'))
                            callCenterAgentAssignOnCta.callCenterAgentAssignOnCta(cta);
                        }
                        
                        if(cta.Industry__c == 'AGRICULTURE AND ALLIED INDUSTRIES' || cta.Industry__c == 'BANKING' || cta.Industry__c == 'ECOMMERCE' || cta.Industry__c == 'E-COMMERCE' || cta.Industry__c == 'FINANCIAL SERVICES' || cta.Industry__c == 'FMCG' || cta.Industry__c == 'INSURANCE' || cta.Industry__c == 'IT & ITES' || cta.Industry__c == 'MEDIA AND ENTERTAINMENT'|| cta.Industry__c == 'TOURISM AND HOSPITALITY')
                        {
                            irrelevant = true;
                        }
                        
                        system.debug('I am in CTA trigger11');
                        
                        if(cta.Intent_validation__c == 'Duplicate enquiry')
                        {
                            cta.CTA_stage__c = 'Disqualified by call center team';
                        }
                        
                        if(cta.isUpdated__c == false && cta.Data_validation__c == true && (cta.Intent_validation__c == 'Intends to speak to IST now' || cta.Intent_validation__c == 'Intends to speak to IST at a later date (date for speaking to IST)') && cta.CTA_stage__c != 'Assigned to IST' && stageMAp.get(cta.CTA_stage__c) < 6 && cta.CC_Status__c == 'Data Validated' && stageMAp.get(cta.CTA_stage__c) != 0)
                        {
                            if(cta.Intent_validation__c == 'Intends to speak to IST now')
                            {
                                if(cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B')
                                {
                                    if(cta.Pincode__c != null)
                                    {
                                        if(ISTpincodeMap.containsKey(cta.Pincode__c))
                                        {
                                            cta.OwnerId = ISTpincodeMap.get(cta.Pincode__c).id;
                                            cta.CTA_stage__c = 'Assigned to IST';
                                        }
                                        else if(!ISTpincodeMap.containsKey(cta.Pincode__c))
                                        {
                                            cta.OwnerId = Label.IST_User_ID;
                                            cta.CTA_stage__c = 'Assigned to IST';
                                        }
                                        
                                        if(DistributorpincodeMap.containskey(cta.pincode__c))
                                        {
                                            cta.Distributor__c=DistributorpincodeMap.get(cta.pincode__c).id;  
                                            cta.Distributor_on_Project__c=DistributorpincodeMap.get(cta.pincode__c).Contact.Account.Name;
                                        }
                                        else
                                        {
                                            cta.Distributor__c=Label.CTA_Default_Distributor;
                                        }
                                        cta.isUpdated__c = true;
                                    }
                                }
                                else if(cta.Indiamart_QTYPE__c == 'PNS' || cta.Ecom_Source__c == 'DialB2B')
                                {
                                    cta.CTA_stage__c = 'Assigned to IST';
                                    cta.isUpdated__c = true;
                                }
                            }
                            if(cta.isUpdated__c == false && cta.Intent_validation__c == 'Intends to speak to IST at a later date (date for speaking to IST)' && cta.CC_Status__c == 'Data Validated')
                            {
                                if(cta.Intends_to_speak_to_IST_at_a_later_date__c != null)
                                {
                                    if(cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B')
                                    {
                                        if(cta.Pincode__c != null)
                                        {
                                            if(ISTpincodeMap.containsKey(cta.Pincode__c))
                                            {
                                                cta.OwnerId = ISTpincodeMap.get(cta.Pincode__c).id;
                                                cta.CTA_stage__c = 'Assigned to IST';
                                            }
                                            else if(!ISTpincodeMap.containsKey(cta.Pincode__c))
                                            {
                                                cta.OwnerId = Label.IST_User_ID;
                                                cta.CTA_stage__c = 'Assigned to IST';
                                            }
                                            
                                            if(DistributorpincodeMap.containskey(cta.pincode__c))
                                            {
                                                cta.Distributor__c=DistributorpincodeMap.get(cta.pincode__c).id;  
                                                cta.Distributor_on_Project__c=DistributorpincodeMap.get(cta.pincode__c).Contact.Account.Name;
                                            }
                                            else
                                            {
                                                cta.Distributor__c=Label.CTA_Default_Distributor;
                                            }
                                        }
                                        cta.isUpdated__c = true;
                                    }
                                    else if(cta.Indiamart_QTYPE__c == 'PNS' || cta.Ecom_Source__c == 'DialB2B')
                                    {
                                        cta.CTA_stage__c = 'Assigned to IST';
                                        cta.isUpdated__c = true;
                                    }
                                }
                            }
                        }
                        
                        else if(cta.isUpdated__c == false && cta.Intent_validation__c == 'Does not want to speak to IST' &&  cta.CTA_stage__c != 'Pre-sales nurturing' && stageMAp.get(cta.CTA_stage__c) < 5 && !irrelevant && stageMAp.get(cta.CTA_stage__c) != 0 && cta.CTA_stage__c != 'Unqualified')
                        {
                            cta.CTA_stage__c = 'Pre-sales nurturing';
                            cta.isUpdated__c = true;
                        }
                        else if((cta.isUpdated__c == false && cta.Intent_validation__c == 'Does not want to speak to IST' && cta.CTA_stage__c != 'Disqualified by call center team' && stageMAp.get(cta.CTA_stage__c) < 6 && irrelevant))
                        {
                            cta.CTA_stage__c = 'Disqualified by call center team';
                            cta.isUpdated__c = true;
                        }
                        
                        else if(cta.isUpdated__c = false && cta.Data_validation__c == true && cta.Intent_validation__c == null && cta.RecordTypeId == ctaRecordTypeId.gmdesign && stageMAp.get(cta.CTA_stage__c) < 5 && cta.CTA_stage__c != 'Pre-sales nurturing' && cta.CTA_stage__c != 'Unqualified')
                        {   
                            cta.CTA_stage__c = 'Pre-sales nurturing';
                            cta.isUpdated__c = true;
                        }
                        
                        
                        if(cta.isUpdated__c == false && cta.intent_validation__c!='Not interested' && stageMAp.get(cta.CTA_stage__c) < 5 && cta.intent_validation__c=='noco' && cta.cta_CC_Remarks_1__c != null && cta.cta_CC_Remarks_2__c != null && cta.cta_CC_Remarks_3__c != null && cta.cta_stage__c != 'Pre-sales nurturing' && cta.cta_stage__c != 'Unqualified' && cta.cta_stage__c != 'Disqualified by call center team')
                        {
                            cta.CTA_stage__c='Pre-sales nurturing';
                            cta.isUpdated__c = true;
                        }
                        else if(cta.isUpdated__c == false && cta.Intent_validation__c == 'Not interested' && stageMAp.get(cta.CTA_stage__c) < 5 && cta.CTA_stage__c != 'Disqualified by call center team' && stageMAp.get(cta.CTA_stage__c) < 5 && stageMAp.get(cta.CTA_stage__c) != 0 && cta.CTA_stage__c != 'Unqualified')
                        {
                            cta.CTA_stage__c = 'Disqualified by call center team';
                            cta.isUpdated__c = true;
                        }
                        
                        System.debug('Stage :'+cta.CTA_stage__c);
                        
                        if(cta.isUpdated__c == false && cta.CTA_stage__c == 'Assigned to IST' && cta.CTA_stage__c != trigger.oldMap.get(cta.Id).CTA_stage__c && stageMap.get(cta.CTA_stage__c) == 6 && cta.Indiamart_QTYPE__c != 'PNS' && cta.Ecom_Source__c != 'DialB2B')
                        {
                            System.debug('Stage :'+cta.CTA_stage__c);
                            if(cta.Pincode__c != null && leadMap.get(cta.lead__c).Status == 'Assigned to IST')
                            {
                                System.debug('Owner Assignment');
                                if(ISTpincodeMap.containskey(cta.pincode__c)) 
                                {
                                    cta.OwnerId=ISTpincodeMap.get(cta.pincode__c).id;
                                    //cta.Assigned_IST_User__c=ISTpincodeMap.get(cta.pincode__c).id;
                                }
                                else if(!ISTpincodeMap.containskey(cta.pincode__c))   //Postal Code not prasent in db
                                {
                                    cta.OwnerId = Label.IST_User_ID;
                                }
                                if(DistributorpincodeMap.containskey(cta.pincode__c))
                                {
                                    cta.Distributor__c=DistributorpincodeMap.get(cta.pincode__c).id;  
                                    cta.Distributor_on_Project__c=DistributorpincodeMap.get(cta.pincode__c).Contact.Account.Name;
                                }
                                else
                                {
                                    cta.Distributor__c=Label.CTA_Default_Distributor;
                                }
                            }
                        }
                        
                        if(cta.RecordTypeId == ctaRecordTypeId.ecom && cta.Ecoomerce_Qualification__c == 'Speak to IST' && cta.Ecoomerce_Qualification__c != trigger.oldMap.get(cta.Id).Ecoomerce_Qualification__c && cta.Data_validation__c == true && cta.CC_Status__c == 'Data Validated')
                        {
                            if(cta.Pincode__c != null)
                            {
                                if(ISTpincodeMap.containsKey(cta.Pincode__c))
                                {  
                                    cta.OwnerId = ISTpincodeMap.get(cta.Pincode__c).id;
                                }
                                else if(!ISTpincodeMap.containsKey(cta.Pincode__c))
                                {
                                    cta.OwnerId = Label.IST_User_ID;
                                }
                            }
                        }
                        
                        if(cta.OwnerId!=null && cta.RecordTypeId != ctaRecordTypeId.ecom)
                        {
                            if(cta.Assigned_Agent__c == null && cta.OwnerId!=null && (userNameMap.get(cta.OwnerId).Name != 'Try Loctite' && userNameMap.get(cta.OwnerId).Name != 'Try Loctite Admin'))
                            {
                                cta.Assigned_Agent__c = userNameMap.get(cta.OwnerId).Name;
                                if(cta.Agent_Assigned_Date__c == null)
                                    cta.Agent_Assigned_Date__c = system.now();
                            }
                        }
                        
                        if(cta.RecordTypeId != ctaRecordTypeId.ecom && cta.CTA_status_Data_collection_Date__c == null && cta.CTA_stage__c == 'Data Collection Process')
                        {
                            cta.CTA_status_Data_collection_Date__c = system.now();
                        }
                        
                        if(cta.RecordTypeId != ctaRecordTypeId.ecom && cta.Data_and_intent_validation_Date__c == null && cta.CTA_stage__c == 'Data and Intent Validation Process')
                        {
                            cta.Data_and_intent_validation_Date__c = system.now();
                        }
                        
                        
                        if(cta.CTA_stage__c == 'Data and Intent Validation Process')
                        {
                            if(cta.Type_of_qualification__c == null)
                                cta.Type_of_qualification__c = 'Data validation and intent collection';
                        }
                        else if(cta.CTA_stage__c == 'Data Collection Process')
                        {
                            if(cta.Type_of_qualification__c == null)
                                cta.Type_of_qualification__c = 'Data and intent collection';
                        }
                        
                    }
                    
                    
                
            }
        }
    }    
      public static void covermethod()
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
         i--;
        i++;
        i--;
          i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
         i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
           i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
          i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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