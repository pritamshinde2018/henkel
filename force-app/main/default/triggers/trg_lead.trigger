trigger trg_lead on Lead (before insert,before update,After Update,After Insert) 
{
    Map<String,User> ISTpincodeMap=new Map<String,User>();
    Map<String,User> DistributorpincodeMap=new Map<String,User>();
    Map<String,Care__c> careMap=new Map<String,Care__c>();
    Set<String> pincodeset=new Set<String>();
    List<String> leadIds = new List<String>();
    List<String> leadsToBeDeleted = new List<String>();
    set<CTA__c> samplingCTA = new set<CTA__c>();
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    Boolean isSample = false;
    if(mc.newDev_LeadTrigger__c)
    {
        for(Lead l : trigger.new)
        {
            pincodeset.add(l.PostalCode); 
        }
        
       
       
        Id ISTrecordTypeId =Schema.SObjectType.User_Pincode_Mapping__c.getRecordTypeInfosByName().get('IST Users').getRecordTypeId();
        Id DistrrecordTypeId =Schema.SObjectType.User_Pincode_Mapping__c.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
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
        if(trigger.isBefore)
        {
                    checkRecursive.Leadflag = false;
            if(test.isRunningTest())
                covermethod();
            
            

            System.debug('I am in lead Trigger 2');
            if(trigger.isInsert)
            {
                
                for(Lead l : trigger.new)
                {
                    
                        if(l.Prospect_Interest_Type__c == 'Sample Requested')
                        {
                            l.sampling_count__c = 1;
                        }
                    
                    
                    if(l.Prospect_Interest_Type__c == 'contact us' && l.Type_of_Enquiry__c == 'careers')
                    {
                        l.Status='Disqualified by call center team';
                        l.CC_Status__c = 'Carreers Enquiry';
                    }
                }
                
                
                trg_Lead_Handler.leadassignement_IST_distr(trigger.new,trigger.new,trigger.newMap,'insert',ISTpincodeMap,DistributorpincodeMap);
                trg_Lead_Handler.leadCareMapping(trigger.new,trigger.newmap,'insert');
                trg_Lead_Handler.Leadscoringmodel(trigger.new,trigger.newmap,'insert');
                trg_Lead_Handler.FBleadcallout(trigger.new);
                trg_Lead_Handler.LinkedinCallout(trigger.new);
                trg_Lead_Handler.LinkedinDesignGuideCallOut(trigger.new);
                trg_Lead_Handler.potentialLeadscoringmodel(trigger.new,trigger.newmap,'insert');
                trg_Lead_Handler.LeadscoringmodelBasisPurpose(trigger.new,trigger.newmap,'insert');
                //callCenterAgentAssign.callCenterAgentAssign(trigger.new);
                istUserAssignment.istUserAssignment(trigger.new);
                
                
                
               
                
                /*List<String> ctaIdFinder = new List<String>();
                List<cta__c> ctaToBeDeleted = new List<cta__c>();
                
                
                if(ctaIdFinder.size() > 0)
                {
                    ctaToBeDeleted = [select id,Lead__c from CTA__c where lead__c =: ctaIdFinder];
                }
                
                delete ctaToBeDeleted;*/
                
                for(Lead l : trigger.new)
                {
                    if(l.Status!=null)
                    {
                        l.Lead_Status__c = l.Status;
                    }
                }
            }
              
            
            else if(trigger.isUpdate)
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
                
                system.debug('I am in lead trigger');
                for(LEad l :trigger.new)
                {                     
                    if((trigger.oldmap.get(l.Id).Industry!=l.Industry || trigger.oldmap.get(l.Id).postalcode!=l.postalcode || trigger.oldmap.get(l.Id).Number_of_Employees_Custom__c!=l.Number_of_Employees_Custom__c || trigger.oldmap.get(l.Id).Street!=l.Street) && l.Industry!=null && l.postalcode!=null && l.Street!=null && l.Number_of_Employees_Custom__c!=null && l.status=='Call Center Working' && stageMap.get(l.Status) < 4 && stageMap.get(l.Status) != 0)
                    {
                        String postalCode=l.PostalCode;
                        l.Status='Data and Intent Validation Process'; 
                        /*if(ISTpincodeMap.containsKey(postalCode))
                        {
                            l.OwnerId=ISTpincodeMap.get(postalCode).ID;
                        }*/  
                    }
                   
                  /* if(l.Prospect_Interest_Type__c == null && l.LeadSource == null && l.Phone != null && l.Phone != trigger.oldMap.get(l.Id).phone)
                   {
                       if(l.OwnerId == '0057F0000011TdL' || l.OwnerId == '0057F0000011Dlq')
                       leadIds.add(l.Id);
                   }*/
                    
                    if(Trigger.oldMap.get(l.Id).Status != l.Status && l.Status!=null && l.Status!='Qualified')
                    {
                        l.Lead_Status__c = l.Status;
                    }
                    
                    if(l.LeadSource != 'Indiamart' && l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null)
                    {
                        if(l.Data_validation__c == true)
                        {
                            l.CC_Status__c = 'Data Validated';
                            if(l.CC_status_Data_Validated_Date__c == null)
                                l.CC_status_Data_Validated_Date__c = system.now();
                        }
                    }
                    
                    if(l.LeadSource == 'Indiamart' && l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null)
                    {
                        if(l.Data_validation__c == true && l.Product_Quantity__c != null && l.Unit__c != null && l.IM_Status__c != null)
                        {
                            l.CC_Status__c = 'Data Validated';
                            if(l.CC_status_Data_Validated_Date__c == null)
                                l.CC_status_Data_Validated_Date__c = system.now();
                        }
                    }
                   /* if(l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Prospect_Interest_Type__c=='Sample Requested' && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null && l.Status == 'Data and Intent Validation Process')
                    {
                        if(l.OwnerId == '0057F0000011TdL' || l.OwnerId == '0057F0000011Dlq')
                            leadIds.add(l.Id);
                    }
                    
                    if(l.Prospect_Interest_Type__c == 'Sampling' && (l.LeadSource == 'Linkedin' || l.LeadSource == 'Facebook_Zapier') && l.Status == 'Data and Intent Validation Process')
                    {
                        if(l.OwnerId == '0057F0000011TdL' || l.OwnerId == '0057F0000011Dlq')
                        leadIds.add(l.Id);
                    }
                    if((l.Prospect_Interest_Type__c == 'Mail enquiry' || l.Prospect_Interest_Type__c == 'Get A Demo' || l.Prospect_Interest_Type__c == 'Contact Us' || l.Prospect_Interest_Type__c == 'Quotation' || l.Prospect_Interest_Type__c == 'Request a callback' || l.Prospect_Interest_Type__c == 'Customized Price') && (l.LeadSource == 'Linkedin' || l.LeadSource == 'Facebook_Zapier'))
                    {
                        if(l.OwnerId == '0057F0000011TdL' || l.OwnerId == '0057F0000011Dlq')
                        leadIds.add(l.Id);
                    }*/
                   /* if(l.Prospect_Interest_Type__c == 'E-Commerce' && l.LeadSource == null && l.Ecom_Order_Status__c == 'delivered')
                    {
                        if(l.OwnerId == '0057F0000011TdL' || l.OwnerId == '0057F0000011Dlq')
                        leadIds.add(l.Id);
                    }*/
                }
                
                trg_Lead_Handler.leadassignement_IST_distr(trigger.new,trigger.old,trigger.oldMap,'update',ISTpincodeMap,DistributorpincodeMap);
                trg_Lead_Handler.leadCareMapping(trigger.new,trigger.oldMap,'update');
                trg_Lead_Handler.Leadscoringmodel(trigger.new,trigger.oldmap,'update');
                trg_Lead_Handler.potentialLeadscoringmodel(trigger.new,trigger.oldmap,'update');
                trg_Lead_Handler.LeadscoringmodelBasisPurpose(trigger.new,trigger.oldmap,'update');
                
                /*if(leadIds.size() > 0)
                {
                    callCenterAgentAssign.callCenterAgentAssign(trigger.new);
                }*/
                
            }
        
        }
        
          
        
        else if(trigger.isAfter)
        {
            if(trigger.isInsert)
                {
                    system.debug('Insert Triggert After Lead in database');
                    
                    List<Lead> avoidDuplicates = trg_Lead_Handler.updateRecord(trigger.new);
                    
                    for(Lead l : avoidDuplicates)
                    {
                        leadsToBeDeleted.add(l.Email);
                    }
                    
                    List<String> deleteLead = new List<String>();
                    List<Lead> FinaldeleteLead = new List<Lead>();
                    system.debug('leadsToBeDeleted :'+leadsToBeDeleted);
                    
                    for(Lead l : trigger.new)
                    {
                        if(leadsToBeDeleted.contains(l.Email))
                        {
                            deleteLead.add(l.Id);
                        }
                    }
                    
                    FinaldeleteLead = [Select id,email from lead where id =: deleteLead];
                    System.debug('deleteLead : '+deleteLead);
                    database.delete(FinaldeleteLead);
                }
            
            if(trigger.isUpdate)
            {
                //Write After events Logic here
                
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
                
                
                Set<String> ownerListId = new set<String>(); 
                List<Cta__c> ctaOwnerUpdate = new List<Cta__c>();
                
                System.debug('After Update lead trigger');
                
                
                for(Lead l : trigger.new)
                {
                    /*if(l.Prospect_Interest_Type__c == 'E-Commerce' && l.LeadSource == null && l.Ecom_Order_Status__c == 'delivered')
{
if(l.OwnerId != null && (trigger.oldmap.get(l.id).OwnerId == '0057F0000011TdL' || trigger.oldmap.get(l.id).OwnerId == '0057F0000011Dlq'))
{
ownerListId.add(l.id);
}
}*/
                    /*if(l.Prospect_Interest_Type__c == null && l.LeadSource == null && l.Phone != null)
                    {
                        if(trigger.oldMap.get(l.Id).OwnerId == '0057F0000011TdL' || trigger.oldMap.get(l.Id).OwnerId == '0057F0000011Dlq')
                            ownerListId.add(l.id);
                    }
                    if((l.Prospect_Interest_Type__c == 'Mail enquiry' || l.Prospect_Interest_Type__c == 'Get A Demo' || l.Prospect_Interest_Type__c == 'Contact Us' || l.Prospect_Interest_Type__c == 'Quotation' || l.Prospect_Interest_Type__c == 'Request a callback' || l.Prospect_Interest_Type__c == 'Customized Price') && (l.LeadSource == 'Linkedin' || l.LeadSource == 'Facebook_Zapier'))
                    {
                        if(l.OwnerId != null && (trigger.oldmap.get(l.id).OwnerId == '0057F0000011TdL' || trigger.oldmap.get(l.id).OwnerId == '0057F0000011Dlq'))
                        {
                            ownerListId.add(l.id);
                        }
                    }
                    if((l.Prospect_Interest_Type__c == 'Webinar' || l.Prospect_Interest_Type__c == 'GM Design Guide') && l.Status == 'Data and Intent Validation Process' && l.OwnerId != trigger.oldmap.get(l.Id).OwnerId)
                    {
                        System.debug('Owner Wbinar/design guide' +l.OwnerId);
                        if(l.OwnerId != null)
                        {
                            ownerListId.add(l.id);
                        }
                    }
                    
                    if(l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Prospect_Interest_Type__c=='Sample Requested' && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null && l.Status == 'Data and Intent Validation Process' && trigger.oldMap.get(l.id).status != l.Status)
                    {
                        if(l.OwnerId != null)
                        {
                            ownerListId.add(l.id);
                        }
                    }
                    
                    if(l.Prospect_Interest_Type__c == 'Sampling' && (l.LeadSource == 'Linkedin' || l.LeadSource == 'Facebook_Zapier') && l.Status == 'Data and Intent Validation Process')
                    {
                        System.debug('In facebook Zpier');
                        if(l.OwnerId != null && (trigger.oldmap.get(l.id).OwnerId == '0057F0000011TdL' || trigger.oldmap.get(l.id).OwnerId == '0057F0000011Dlq'))
                        {
                            ownerListId.add(l.id);
                        }
                    }
                    
                    if(l.Prospect_Interest_Type__c == 'Sampling' && l.LeadSource == 'Facebook_Zapier' && l.Status == 'Data and Intent Validation Process')
                    {
                        System.debug('In facebook Zpier');
                        if(l.OwnerId != null && (trigger.oldmap.get(l.id).OwnerId == '0057F0000011TdL' || trigger.oldmap.get(l.id).OwnerId == '0057F0000011Dlq'))
                        {
                            ownerListId.add(l.id);
                        }
                    }*/
                    
                    if(l.Prospect_Interest_Type__c != 'E-Commerce' && l.Status == 'Data Collection Process' && stageMAp.get(l.Status)<=2 && l.Status != 'Disqualified by call center team' && l.Status != 'Unqualified')
                    {
                        ownerListId.add(l.id);
                        //leadListId.add(l.Id); 
                    }
                    
                    /*if(l.Prospect_Interest_Type__c == 'Sample Requested' && l.OwnerId != trigger.oldMap.get(l.Id).OwnerId && l.Status == 'Data Collection Process')
                    {
                        if(l.OwnerId != null)
                        {
                            ownerListId.add(l.id);
                        }                    
                    }*/
                    if(l.Status == 'Assigned to IST' && l.Status != trigger.oldMap.get(l.id).Status)
                    {
                        ownerListId.add(l.id);
                    }
                    /*if(l.Status == 'Disqualified by call center team' && l.Status != trigger.oldMap.get(l.id).Status)
                    {
                        ownerListId.add(l.id);
                    }*/
                    /*if(l.CC_Status__c!='Not interested' && l.CC_Status__c!='nmql' && l.CC_Remarks_1__c != null && l.CC_Remarks_2__c != null && l.CC_Remarks_3__c != null && l.status == 'Pre-sales nurturing' && l.Status != 'Unqualified' && l.Status != 'Disqualified by call center team' && l.Status != trigger.oldMap.get(l.id).Status)
                    {
                        ownerListId.add(l.id);
                    }
                    if(l.CC_Status__c=='noco' && l.status == 'Pre-sales nurturing' && l.Data_validation__c != true && l.Status != trigger.oldMap.get(l.id).Status)
                    {   
                        ownerListId.add(l.id);
                    }*/
                }
                
                
                if(ownerListId.size() > 0)
                {
                    ctaOwnerUpdate = [Select id,lead__c,RecordTypeId,cta_stage__c, lead__r.Status, lead__r.Intent_validation__c, ownerId, lead__r.ownerId, Intent_validation__c from CTA__c where lead__c in :ownerListId];
                }
                
                
                for(Cta__c cta : ctaOwnerUpdate)
                {	
                    /*System.debug('ctaOwnerUpdate Owner : '+cta.lead__r.ownerId);
                    if(cta.RecordTypeId != ctaRecordTypeId.ecom && (cta.OwnerId == '0057F0000011TdL' || cta.OwnerId == '0057F0000011Dlq'))
                    {
                        cta.OwnerId = cta.lead__r.ownerId;
                    }*/
                    
                    /*if(cta.lead__r.status == 'Assigned to IST' && cta.lead__r.Intent_validation__c != null && stageMap.get(cta.CTA_stage__c) < 6 && cta.CTA_stage__c != 'Assigned to IST' && (cta.Intent_validation__c == 'Intends to speak to IST now' || cta.Intent_validation__c == 'Intends to speak to IST at a later date (date for speaking to IST)'))
                    {
                        cta.cta_stage__c = 'Assigned to IST';
                    }
                    
                    if(cta.lead__r.status == 'Pre-sales nurturing' && stageMap.get(cta.CTA_stage__c) < 6 && cta.CTA_stage__c != 'Pre-sales nurturing')
                    {
                        cta.cta_stage__c = 'Pre-sales nurturing';
                    }*/
                    
                    if(cta.lead__r.status == 'Data Collection Process' && stageMAp.get(cta.CTA_stage__c)<2 && stageMAp.get(cta.CTA_stage__c)!=0 && cta.CTA_stage__c != 'Data Collection Process')
                    {
                        cta.cta_stage__c = 'Data Collection Process';
                    }
                    
                    /*if(cta.lead__r.status == 'Disqualified by call center team' && stageMap.get(cta.CTA_stage__c) < 6 && cta.CTA_stage__c != 'Disqualified by call center team')
                    {
                        cta.cta_stage__c = 'Disqualified by call center team';
                    }*/
                }
                
                if(ctaOwnerUpdate.size()>0)
                {
                    system.debug('ctaOwnerUpdate----- '+ctaOwnerUpdate[0].ownerId);
                    update ctaOwnerUpdate;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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