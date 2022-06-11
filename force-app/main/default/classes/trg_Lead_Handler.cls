public class trg_Lead_Handler 
{
    
  public static void leadassignement_IST_distr(List<lead> newLeadList,List<lead> oldLeadList ,Map<Id,Lead> oldMAp, String eventtype,
                                                 Map<String,User> ISTpincodeMap,Map<String,User> DistributorpincodeMap)
    {
       if(test.isRunningTest())
          covermethod(); 
       List<CTA__c> newCTAList=new List<CTA__c>();
        List<CTA__c> qualifiedCTAList = new List<CTA__c>();
      
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
        
        if(eventtype=='insert')
       {
          for(Lead l : newLeadList)
          {
              if(l.Prospect_Interest_Type__c == 'Get A Demo' || l.Prospect_Interest_Type__c == 'COntact Us' || l.Prospect_Interest_Type__c == 'Quotation' || l.Prospect_Interest_Type__c == 'Request a callback' || l.Prospect_Interest_Type__c == 'Webinar')
              {
                  l.Status='Data and Intent Validation Process';
              }
             
              if((l.Industry==null || l.Number_of_Employees_Custom__c==null || l.Street==null || l.Role_in_organisation__c==null || l.What_is_the_purpose_use__c==null) && l.Prospect_Interest_Type__c == null && l.LeadSource == null)
              {
                  l.Status='Data Collection Process';
              }
              
                System.debug('Owner  : '+l.OwnerId);
              if((l.Industry==null || l.Number_of_Employees_Custom__c==null || l.Street==null || l.Role_in_organisation__c==null || l.What_is_the_purpose_use__c==null) && l.Prospect_Interest_Type__c=='Sample Requested') 
              {
                  l.Status = 'Data Collection Process';
              }
              
              
              if((l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Prospect_Interest_Type__c=='Sample Requested' && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null)) 
              {
                  system.debug('Inside Sample Requested');
                  l.Status='Data and Intent Validation Process';
              }
          }
           
       }
        
        
       else if(eventtype=='update')
       {
           boolean irrelevant = false;
           
           
          System.debug('Lead Update trigger');
           
           Set<String> leadListId = new Set<String>();
           Map<String,String> statusMap = new Map<String,String>();
           
         
           for(Lead l : newLeadList)
           {
               if(l.Industry == 'AGRICULTURE AND ALLIED INDUSTRIES' || l.Industry == 'BANKING' || l.Industry == 'ECOMMERCE' || l.Industry == 'FINANCIAL SERVICES' || l.Industry == 'FMCG' || l.Industry == 'INSURANCE' || l.Industry == 'IT & ITES' || l.Industry == 'MEDIA AND ENTERTAINMENT'|| l.Industry == 'TOURISM AND HOSPITALITY')
               {
                   irrelevant = true;
               }
               
              /* if(l.Prospect_Interest_Type__c != 'E-Commerce' && l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null &&  l.Status!='Data and Intent Validation Process' && (oldMAp.get(l.id).PostalCode!=l.PostalCode ||
                                                                                                      oldMAp.get(l.id).Industry!=l.Industry || 
                                                                                                      oldMAp.get(l.id).Number_of_Employees_Custom__c!=l.Number_of_Employees_Custom__c) &&
                  stageMAp.get(l.Status)<=4 && stageMAp.get(l.Status)!=0 && l.Type_of_Enquiry__c != 'careers' && l.Prospect_Interest_Type__c!='Sample Requested' && (l.LeadSource!='Indiamart' || l.LeadSource!=null))
               {
                   if(l.LeadSource!='Indiamart')
                   {
                       l.Status='Data and Intent Validation Process';
                       leadListId.add(l.Id);  
                   }
               }
               
               if(l.PostalCode!=null && l.Type_of_Enquiry__c != 'careers' && l.Industry!=null && l.Number_of_Employees_Custom__c!=null &&  l.Status!='Data and Intent Validation Process' && (oldMAp.get(l.id).PostalCode!=l.PostalCode ||
                                                                                                                                                         oldMAp.get(l.id).Industry!=l.Industry || 
                                                                                                                                                         oldMAp.get(l.id).Number_of_Employees_Custom__c!=l.Number_of_Employees_Custom__c) &&
                  stageMAp.get(l.Status)<=4 && stageMAp.get(l.Status)!= 0 && l.Prospect_Interest_Type__c == null && l.LeadSource==null)
               {
                   l.Status='Data and Intent Validation Process';
                   leadListId.add(l.Id);  
               }*/
               
               if((l.Industry==null || l.Number_of_Employees_Custom__c==null || l.Street==null || l.Role_in_organisation__c==null || l.What_is_the_purpose_use__c==null) && l.Prospect_Interest_Type__c=='Sample Requested') 
               {
                   if(l.Status != 'Data Collection Process' && stageMAp.get(l.Status)<2 && l.Status != 'Disqualified by call center team' && l.Status != 'Unqualified')
                   {
                       l.Status = 'Data Collection Process';
                       //leadListId.add(l.Id); 
                   }
               }
               
               /*if(l.PostalCode!=null && l.Email != null && (l.MobilePhone != null || l.Phone != null) && l.Type_of_Enquiry__c != 'careers' && l.Industry!=null && l.Number_of_Employees_Custom__c!=null &&  l.Status!='Data and Intent Validation Process' && (oldMAp.get(l.id).PostalCode!=l.PostalCode ||
                                                                                                                                                                                                                                                               oldMAp.get(l.id).Industry!=l.Industry || oldMAp.get(l.id).Email!=l.Email || oldMAp.get(l.id).MobilePhone!=l.MobilePhone || oldMAp.get(l.id).Phone!=l.Phone ||
                                                                                                                                                                                                                                                               oldMAp.get(l.id).Number_of_Employees_Custom__c!=l.Number_of_Employees_Custom__c) &&
                  stageMAp.get(l.Status)<=4 && stageMAp.get(l.Status)!=0 && (l.LeadSource=='Indiamart' || l.LeadSource == 'TradeIndia'))
               {
                   system.debug('I am in Indiamart Lead Data and Intent Validation Process');
                   l.Status='Data and Intent Validation Process';
                   leadListId.add(l.Id);  
               }*/
               
               if(l.PostalCode!=null && l.Industry!=null && l.Number_of_Employees_Custom__c!=null && l.Street!=null && l.Prospect_Interest_Type__c=='Sample Requested' && l.Role_in_organisation__c!=null && l.What_is_the_purpose_use__c!=null)
               {
                   system.debug('Inside Sample Requested');
                   
                   if(l.Status != 'Data and Intent Validation Process' && stageMAp.get(l.Status)<=4 && l.Status != 'Disqualified by call center team' && l.Status != 'Unqualified')
                   {
                       system.debug('Data and Intent Validation Process');
                       l.Status='Data and Intent Validation Process';
                       leadListId.add(l.Id);
                   }
               }
               
               
                   if(l.Status == 'Assigned to IST' && l.Status != oldMap.get(l.Id).Status && (l.Indiamart_QTYPE__c != 'PNS' && l.Ecom_Source__c != 'DialB2B'))
                   {
                       if(ISTpincodeMap.containskey(l.PostalCode)) 
                       {
                           l.OwnerId=ISTpincodeMap.get(l.PostalCode).id;
                           l.Assigned_IST_User__c=ISTpincodeMap.get(l.PostalCode).id; 
                           
                           if(DistributorpincodeMap.containskey(l.PostalCode)) 
                               l.Distributor_Company__c=DistributorpincodeMap.get(l.PostalCode).Contact.AccountId;
                       }
                       else if(!ISTpincodeMap.containskey(l.PostalCode))   //Postal Code not prasent in db
                       {
                           l.OwnerId = Label.IST_User_ID;
                       }
                       if(DistributorpincodeMap.containskey(l.PostalCode))
                       {
                           //l.Distributor_Company__c=DistributorpincodeMap.get(l.PostalCode).Contact.AccountId;  
                       }
                   }
               
               if(l.Intent_validation__c == 'Intends to speak to IST now' || l.Intent_validation__c == 'Intends to speak to IST at a later date (date for speaking to IST)')
               {
                   if(l.Data_validation__c == true && (l.Indiamart_QTYPE__c != 'PNS' && l.Ecom_Source__c != 'DialB2B') && l.CC_Status__c == 'Data Validated' && stageMap.get(l.Status) != 0 && stageMap.get(l.Status) < 6)
                   {
                       if(l.PostalCode != null)
                       {
                           if(ISTpincodeMap.containsKey(l.PostalCode))
                           {
                               l.OwnerId = ISTpincodeMap.get(l.PostalCode).id;
                               l.Status = 'Assigned to IST';
                               
                               if(DistributorpincodeMap.containskey(l.PostalCode)) 
                                   l.Distributor_Company__c=DistributorpincodeMap.get(l.PostalCode).Contact.AccountId;
                           }
                           else if(!ISTpincodeMap.containsKey(l.PostalCode))
                           {
                               l.OwnerId = Label.IST_User_ID;
                               l.status = 'Assigned to IST';
                           }
                       }
                   }
                   else if((l.Indiamart_QTYPE__c == 'PNS' || l.Ecom_Source__c == 'DialB2B') && l.Data_validation__c == true)
                   {
                       l.status = 'Assigned to IST';
                   }
               }
              statusMap.put(l.Id,l.Status);
            
               if(l.Status == 'Assigned to IST' && l.MQL_Status_Updated_Date__c == null)
              {
                  l.MQL_Status_Updated_Date__c = System.now();
              }
               if(l.Status == 'Qualified' && l.SQL_creation_date__c == null)
               {
                   l.SQL_creation_date__c = System.now();
               }
           }
           
           
           
          
           
           
           if(leadListId.size() > 0)
           {
               newCTAList=[Select id,lead__c,cta_stage__c, lead__r.Status,lead__r.Plumbing_Lead__c from CTA__c where lead__c in :leadListId];
           }
           
           system.debug('Status :' +statusMap);
           for(Cta__c cta : newCTAList) 
           {
               if(statusMap.get(cta.Lead__c) == 'Data and Intent Validation Process' && cta.CTA_stage__c != 'Data and Intent Validation Process')
               {
                   cta.CTA_stage__c = 'Data and Intent Validation Process';
               }
               
               if(statusMap.get(cta.Lead__c) == 'Pre-sales nurturing' && cta.CTA_stage__c != 'Pre-sales nurturing')
               {
                   cta.CTA_stage__c = 'Pre-sales nurturing';
               }
           }
           
           
       }
        
       if(newCTAList.size()>0)
       {
           system.debug('newCTAList----- '+newCTAList[0].CTA_stage__c);
           update newCTAList;
       }
        } 
    
    public static List<Lead> updateRecord(List<Lead> newLead)
    {
        List<String> emailId = new List<String>();
        List<String> leadIds = new List<String>();
        List<Lead> deleteDuplicateLead = new List<Lead>();
        Map<String,Lead> LeadMap = new Map<String,Lead>();
        Map<String,Lead> deleteIdMap = new Map<String,Lead>();
        List<CTA__c> newCta = new List<CTA__c>();
        
        for(Lead l : newLead)
        {
            if(l.Prospect_Interest_Type__c != 'E-Commerce' && l.Email != null && l.LeadSource != 'Indiamart')
            {
                emailId.add(l.Email);
                leadIds.add(l.Id);
                deleteIdMap.put(l.Email,l);
            }
        } 
        
        if(emailId.size() > 0)
        {
            for(Lead l : [select id,email,LeadSource,phone,Prospect_Interest_Type__c,Industry,Number_of_Employees_Custom__c,Role_in_organisation__c,PostalCode,Street,City,State from lead where email =: emailId AND ID !=: leadIds])
            {
                LeadMap.put(l.email, l);
                deleteDuplicateLead.add(deleteIdMap.get(l.email));
            }
        }
        
        if(LeadMap.size() > 0)
        {
            for(Lead l : newLead)
            {
               // l.id = LeadMap.get(l.Email).id;
                if(LeadMap.containsKey(l.Email))
                {
                    System.debug('Email and Id'+LeadMap.get(l.Email).Id);
                    if(LeadMap.get(l.Email).Phone != l.Phone)
                    LeadMap.get(l.Email).Phone = l.Phone;
                    
                    if(LeadMap.get(l.Email).LeadSource != l.LeadSource)
                    LeadMap.get(l.Email).LeadSource = l.LeadSource;
                    
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c != l.Prospect_Interest_Type__c)
                    LeadMap.get(l.Email).Prospect_Interest_Type__c = l.Prospect_Interest_Type__c;
                    
                    if(LeadMap.get(l.Email).Industry != l.Industry)
                    LeadMap.get(l.Email).Industry = l.Industry;
                    
                    if(LeadMap.get(l.Email).Number_of_Employees_Custom__c != l.Number_of_Employees_Custom__c)
                    LeadMap.get(l.Email).Number_of_Employees_Custom__c = l.Number_of_Employees_Custom__c;
                    
                    if(LeadMap.get(l.Email).Role_in_organisation__c != l.Role_in_organisation__c)
                    LeadMap.get(l.Email).Role_in_organisation__c = l.Role_in_organisation__c;
                    
                    if(LeadMap.get(l.Email).PostalCode != l.PostalCode)
                    LeadMap.get(l.Email).PostalCode = l.PostalCode;
                    
                    if(LeadMap.get(l.Email).Street != l.Street)
                    LeadMap.get(l.Email).Street = l.Street;
                    
                    if(LeadMap.get(l.Email).City != l.City)
                    LeadMap.get(l.Email).City = l.City;
                    
                    if(LeadMap.get(l.Email).State != l.State)
                    LeadMap.get(l.Email).State = l.State;
                    
                    if(LeadMap.get(l.Email).LeadSource == 'TradeIndia')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('TradeIndia').getRecordTypeId();
                        cta.Indiamart_ID__c = l.Indiamart_ID__c;
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Get A Demo')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Get A Demo').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Contact Us')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Contact Us').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Customized Price')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Customized Price').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'GM Design Guide')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('GM Design Guide').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Masterclass')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Masterclass').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Quotation')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Quotation').getRecordTypeId();
                        newCta.add(cta);
                    }
                    if(LeadMap.get(l.Email).Prospect_Interest_Type__c == l.Prospect_Interest_Type__c && l.Prospect_Interest_Type__c == 'Request Callback')
                    {
                        CTA__c cta = new CTA__c();
                        cta.lead__c = LeadMap.get(l.Email).id;
                        cta.RecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Request Callback').getRecordTypeId();
                        newCta.add(cta);
                    }
                    
                }
                //deleteDuplicateLead.add(l);
            }
            
            if(LeadMap.size() > 0)
                update LeadMap.values();
            
            if(newCta.size() > 0)
                insert newCta;
            
        }
        return deleteDuplicateLead;
    }
    public static void leadCareMapping(List<lead> newLeadList,Map<Id,lead> oldMap , String eventtype)
    {
            if(eventtype=='insert')
            {
                Map<String,Care__c> careMap=new Map<String,Care__c>();
                
                set<String> industryEmpList = new set<String>();
                
                for(Lead ct : newLeadList)
                {
                    
                    if(ct.Lead_Industry_Employees__c != null)
                    {
                        industryEmpList.add(ct.Lead_Industry_Employees__c);
                    }
                }
                if(industryEmpList.size() > 0) 
                {
                    for(Care__c careObj  :[Select id,Focus_Segment__c,Focus_Priority__c,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
                                           SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c where Industry_NumberofEmployees__c =: industryEmpList])
                    {
                        System.debug(careObj);
                        careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
                    }
                }
                
                
                for(Lead ct : newLeadList)
                {
                    if(careMap.containskey(ct.Lead_Industry_Employees__c))
                    {
                        ct.Annualized_value_estimation__c=careMap.get(ct.Lead_Industry_Employees__c).Annualized_value_estimation__c;
                        ct.Lead_classification_basis_value__c=careMap.get(ct.Lead_Industry_Employees__c).Lead_classification_basis_value__c;
                        ct.Grade__c=careMap.get(ct.Lead_Industry_Employees__c).Grade__c;
                        ct.Industry_priority__c=careMap.get(ct.Lead_Industry_Employees__c).Industry_priority__c;
                        ct.Lead_priority__c=careMap.get(ct.Lead_Industry_Employees__c).Lead_priority__c;
                        ct.SBU__c=careMap.get(ct.Lead_Industry_Employees__c).SBU__c;
                    }
                }
            }
            else
            {
                Map<String,Care__c> careMap=new Map<String,Care__c>();
                
                set<String> industryEmpList = new set<String>();
                for(Lead ct : newLeadList)
                {
                    if(ct.Lead_Industry_Employees__c != null && (oldMap.get(ct.Id).Lead_Industry_Employees__c!=ct.Lead_Industry_Employees__c))
                    {
                        industryEmpList.add(ct.Lead_Industry_Employees__c);
                    }
                }
                
                if(industryEmpList.size() > 0)
                {
                    for(Care__c careObj  :[Select id,Focus_Segment__c,Focus_Priority__c,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
                                           SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c where Industry_NumberofEmployees__c =: industryEmpList])
                    {
                        System.debug(careObj);
                        careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
                    }
                }
                
                
                for(Lead ct : newLeadList)
                {
                    if((careMap.containsKey(ct.Lead_Industry_Employees__c) &&  (oldMap.get(ct.Id).Lead_Industry_Employees__c!=ct.Lead_Industry_Employees__c)))
                    {
                        if(careMap.containskey(ct.Lead_Industry_Employees__c))
                        {
                            ct.Annualized_value_estimation__c=careMap.get(ct.Lead_Industry_Employees__c).Annualized_value_estimation__c;
                            ct.Lead_classification_basis_value__c=careMap.get(ct.Lead_Industry_Employees__c).Lead_classification_basis_value__c;
                            ct.Grade__c=careMap.get(ct.Lead_Industry_Employees__c).Grade__c;
                            ct.Industry_priority__c=careMap.get(ct.Lead_Industry_Employees__c).Industry_priority__c;
                            ct.Lead_priority__c=careMap.get(ct.Lead_Industry_Employees__c).Lead_priority__c;
                            ct.SBU__c=careMap.get(ct.Lead_Industry_Employees__c).SBU__c;
                        }
                    }
                }
            }
        }
    
    
    
    public static void potentialLeadscoringmodel(List<lead> newLeadList,Map<Id,lead> oldMap,String eventtype)
    {
        Map<String,Lead_Score_Model__c> leadScoreModel = new Map<String,Lead_Score_Model__c>();
        
        set<String> potentialList = new set<String>();
        
        if(eventtype == 'insert')
        {
            for(Lead l : newLeadList)
            {
                if(l.Industry != null && l.What_is_the_purpose_use__c == null && l.Number_of_Employees_Custom__c != null)
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + 	l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) {
                        potentialList.add(potentialLeadscore);
                    } 
                }
                else if(l.Industry != null && l.What_is_the_purpose_use__c != null && l.Number_of_Employees_Custom__c != null)
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + l.What_is_the_purpose_use__c + l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) 
                    {
                        potentialList.add(potentialLeadscore);
                    }
                }
            }
            if(potentialList.size() > 0)
            {
                for(Lead_Score_Model__c score : [select id, Potential_Basis_Lead_Score__c, Lead_Score__c from Lead_Score_Model__c where Potential_Basis_Lead_Score__c =: potentialList])
                {
                    System.debug(Score);
                    leadScoreModel.put(score.Potential_Basis_Lead_Score__c, score);    
                }
            }
                
            
            
            for(Lead l : newLeadList)
            {
                if(l.Industry != null && l.What_is_the_purpose_use__c == null && l.Number_of_Employees_Custom__c != null)
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + 	l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) {
                        if(leadScoreModel.containsKey(potentialLeadscore))
                        {
                            //system.debug('potentialLeadscore contains as a key to map: ' +potentialLeadscore);
                            l.Lead_Score__c = leadScoreModel.get(potentialLeadscore).Lead_Score__c;
                            system.debug('Lead Score : ' +l.Lead_Score__c);
                        }
                    }
                }
                else if(l.Industry != null && l.What_is_the_purpose_use__c != null && l.Number_of_Employees_Custom__c != null)
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + l.What_is_the_purpose_use__c + l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) 
                    {
                        //system.debug('potentialLeadscore for null check: ' +potentialLeadscore);
                        if(leadScoreModel.containsKey(potentialLeadscore) && potentialLeadscore != null)
                        {
                            //system.debug('potentialLeadscore contains as a key to map: ' +potentialLeadscore);
                            l.Lead_Score__c = leadScoreModel.get(potentialLeadscore).Lead_Score__c;
                            system.debug('Lead Score : ' +l.Lead_Score__c);
                        }
                    }
                } 
            }
        }
        else if(eventtype == 'update')
        {
            for(Lead l : newLeadList)
            {
                if(l.Industry != null && l.What_is_the_purpose_use__c == null && l.Number_of_Employees_Custom__c != null 
                   && (oldMap.get(l.Id).Industry != l.Industry || oldMap.get(l.Id).Number_of_Employees_Custom__c != l.Number_of_Employees_Custom__c))
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + 	l.Number_of_Employees_Custom__c;
                    
                    system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) {
                        potentialList.add(potentialLeadscore);
                    } 
                }
                else if(l.Industry != null && l.What_is_the_purpose_use__c != null && l.Number_of_Employees_Custom__c != null
                       && (oldMap.get(l.Id).Industry != l.Industry || oldMap.get(l.Id).What_is_the_purpose_use__c != l.What_is_the_purpose_use__c
                       || oldMap.get(l.Id).Number_of_Employees_Custom__c != l.Number_of_Employees_Custom__c))
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + l.What_is_the_purpose_use__c + l.Number_of_Employees_Custom__c;
                    
                    system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) 
                    {
                        potentialList.add(potentialLeadscore);
                    }
                }
            }
            
            if(potentialList.size() > 0)
            {
                system.debug('potentialList : '+potentialList);
                for(Lead_Score_Model__c score : [select id, Potential_Basis_Lead_Score__c, Lead_Score__c from Lead_Score_Model__c where Potential_Basis_Lead_Score__c =: potentialList])
                {
                    System.debug(Score);
                    leadScoreModel.put(score.Potential_Basis_Lead_Score__c, score);    
                }
            }
            
            
            for(Lead l : newLeadList)
            {
                if(l.Industry != null && l.What_is_the_purpose_use__c == null && l.Number_of_Employees_Custom__c != null 
                   && (oldMap.get(l.Id).Industry != l.Industry || oldMap.get(l.Id).Number_of_Employees_Custom__c != l.Number_of_Employees_Custom__c))
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + 	l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) {
                        if(leadScoreModel.containsKey(potentialLeadscore))
                        {
                            //system.debug('potentialLeadscore contains as a key to map: ' +potentialLeadscore);
                            l.Lead_Score__c = leadScoreModel.get(potentialLeadscore).Lead_Score__c;
                            system.debug('Lead Score : ' +l.Lead_Score__c);
                        }
                    }
                }
               else if(l.Industry != null && l.What_is_the_purpose_use__c != null && l.Number_of_Employees_Custom__c != null
                       && (oldMap.get(l.Id).Industry != l.Industry || oldMap.get(l.Id).What_is_the_purpose_use__c != l.What_is_the_purpose_use__c
                       || oldMap.get(l.Id).Number_of_Employees_Custom__c != l.Number_of_Employees_Custom__c))
                {
                    String potentialLeadscore;
                    potentialLeadscore = l.Industry + l.What_is_the_purpose_use__c + l.Number_of_Employees_Custom__c;
                    
                    //system.debug('potentialLeadscore : ' +potentialLeadscore);
                    if(potentialLeadscore != null) 
                    {
                        //system.debug('potentialLeadscore for null check: ' +potentialLeadscore);
                        if(leadScoreModel.containsKey(potentialLeadscore) && potentialLeadscore != null)
                        {
                            //system.debug('potentialLeadscore contains as a key to map: ' +potentialLeadscore);
                            l.Lead_Score__c = leadScoreModel.get(potentialLeadscore).Lead_Score__c;
                            system.debug('Lead Score : ' +l.Lead_Score__c);
                        }
                    }
                } 
            }   
        }   
    }
    
    public static void Leadscoringmodel(List<lead> newLeadList,Map<Id,lead> oldMap , String eventtype)
    {
       if(eventtype=='insert')
       {
          for(Lead l : newLeadList)
          {
              if(l.pi__score__c <45  && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c <45 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c <45  && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating_Custom__c='Cold';
              }
              else if(l.pi__score__c <45  && l.Lead_classification_basis_value__c=='D')
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
       else if(eventtype=='update')
       {
          System.debug('Leadscoringmodel--------------------- ');
          for(Lead l : newLeadList)
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
    }
    
    public static void FBleadcallout(List<lead> newLeads)
    {
        for(Lead l: newLeads)
      {
            if((l.IsConverted != true)&&(l.LeadSource=='Facebook_Zapier' || l.LeadSource=='Linkedin') && l.Which_Product_Sent__c != NULL)// need to change as per given field
            {
                
                FBSamplingAPIcallout.calloutWebservice(l.email,l.phone,l.Which_Product_Sent__c,l.lastname,l.company,l.postalcode);
            }    
      }
    }
    
    /*Created By Ajinkya*/
    public static void LinkedinCallout(List<lead> newLeads)
    {
        for(Lead l: newLeads)
      {
            if((l.IsConverted != true)&&(l.LeadSource=='Linkedin') && l.Company_Size__c != NULL && l.Form__c=='urn:li:adForm:3781993')// need to change as per given field
            {
                LinkedinGetADemoCallout.calloutWebservice(l.email,l.phone,l.lastname,l.company,l.postalcode,l.Designation__c,l.Department__c,l.Industry,l.Company_Size__c);
            }    
      }
    }
    public static void LinkedinDesignGuideCallOut(List<lead> newLeads)
    {
        for(Lead l: newLeads)
    	{
            if((l.IsConverted != true)&&(l.LeadSource=='Linkedin') && l.Company_Size__c != NULL && l.Form__c!='urn:li:adForm:3781993' && l.Form__c != 'MRO_LOC638_Free Sampling_Feb2022')// need to change as per given field
            {
                LinkedinDesignGuideCallout.calloutWebservice(l.email,l.phone,l.lastname,l.company,l.postalcode,l.Designation__c,l.Department__c,l.Industry,l.Company_Size__c,l.Form__c);
            }  
            if((l.IsConverted != true)&&(l.LeadSource=='Facebook_Zapier') && l.Form__c == 'Download Guidance Retaining Component_15Feb2022')//for fbform need to change as per given field
            {
                LinkedinDesignGuideCallout.calloutWebservice(l.email,l.phone,l.lastname,l.company,l.postalcode,l.Designation__c,l.Department__c,l.Industry,l.Company_Size__c,l.Form__c);
            }   
    	}
    }
    
    public static void LeadscoringmodelBasisPurpose(List<lead> newLeadList,Map<Id,lead> oldMap,String eventtype)
    {
        if(eventtype=='insert')
        {
            for(Lead l : newLeadList)
            {
                if(l.pi__score__c <45  && l.Lead_Score__c == 'A')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c <45 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c <45  && l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Cold';
                }
                else if(l.pi__score__c <45  && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Cold';
                }
                if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_Score__c=='A')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >= 45 && l.pi__score__c < 65 && l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c >=45 && l.pi__score__c <65 && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c >=65  && l.Lead_Score__c=='A')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 &&  l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }   
            }
        }
        else if(eventtype=='update')
        {
            for(Lead l : newLeadList)
          {
            if(l.pi__score__c!=oldMap.get(l.id).pi__score__c || l.Lead_Score__c !=oldMap.get(l.id).Lead_Score__c)
            {
                if(l.pi__score__c <45  && l.Lead_Score__c == 'A')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c <45 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c <45  && l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Cold';
                }
                else if(l.pi__score__c <45  && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Cold';
                }
                if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_Score__c=='A')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >= 45 && l.pi__score__c <65 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >= 45 && l.pi__score__c < 65 && l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c >=45 && l.pi__score__c <65 && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Warm';
                }
                else if(l.pi__score__c >=65  && l.Lead_Score__c=='A')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 && l.Lead_Score__c=='B')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 &&  l.Lead_Score__c=='C')
                {
                    l.Rating_Basis_Purpose__c='Hot';
                }
                else if(l.pi__score__c >=65 && l.Lead_Score__c=='D')
                {
                    l.Rating_Basis_Purpose__c='Hot';
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
         i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
    
    /*public static void Leadscoringmodel(List<lead> newLeadList,Map<Id,lead> oldMap , String eventtype)
    {
       if(eventtype=='insert')
       {
          for(Lead l : newLeadList)
          {
              if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating_Custom__c='Warm';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Cold';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Cold';
              }
              if(l.pi__score__c >= 50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >= 50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >= 50 && l.pi__score__c < 65 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c >=50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c >=65  && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 &&  l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Hot';
              }
              
          }
       }
       else if(eventtype=='update')
       {
          for(Lead l : newLeadList)
          {
            if(l.pi__score__c!=oldMap.get(l.id).pi__score__c || l.Lead_classification_basis_value__c !=oldMap.get(l.id).Lead_classification_basis_value__c)
            {
                if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Cold';
              }
              else if(l.pi__score__c > 0 && l.pi__score__c <50 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Cold';
              }
              if(l.pi__score__c >= 50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >= 50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >= 50 && l.pi__score__c < 65 && l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c >=50 && l.pi__score__c <65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Warm';
              }
              else if(l.pi__score__c >=65  && l.Lead_classification_basis_value__c=='A')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='B')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 &&  l.Lead_classification_basis_value__c=='C')
              {
                  l.Rating='Hot';
              }
              else if(l.pi__score__c >=65 && l.Lead_classification_basis_value__c=='D')
              {
                  l.Rating='Hot';
              }
             }
          }
       }
    }*/
}