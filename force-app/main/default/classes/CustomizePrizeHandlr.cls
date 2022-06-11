/*
 * test Class : test_trg_customizePrice
*/
public class CustomizePrizeHandlr 
{
	public static List<Opportunity> opptoInsert=new List<Opportunity>();
    public static boolean selfupdatetriggerFlag=true;
    public static Map<String,pricebookentry> pricebookEntryMap=new Map<String,pricebookentry>();
    public static Map<String,Product2> prodMap=new Map<String,Product2>();
    public static List<OpportunityLineItem> oppLineItemtoInsert=new List<OpportunityLineItem>();
    public static set<Id> leadIds=new Set<Id>();
    public static List<Lead> leadstoUpdate=new List<Lead>();
    public static List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
    public static Set<id> quoteSet=new Set<id>();
    public static List<Opportunity> opportunitytoUpdate=new List<Opportunity>();
    public static List<Account> accounttoupdate=new List<Account>();
    public static List<Contact> contacttoUpdate =new List<Contact>();
    public static List<Customized_Price__c> CustomizeListtoUpdate=new List<Customized_Price__c>();
   	public static Map<id,List<Quotation__c>> leadQuotationNumberMap=new Map<Id,List<Quotation__c>>();
   	public static Map<id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>();
   	public static Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
    public static List<task> taskstoInsert=new List<task>();
    public static void trg_Customizeprice(list<Customized_Price__c> CustomizePriceList,Map<Id,Customized_Price__c> oldMap,Map<String,user> userpincodeMap)
    {
        //List<Request__c> quotationproductList=[Select id,(Select id,SKU__c,Quantity__c from Products__r) from Quotation__c where id in :quotationList];
        //Map<Id,List<Product__c>> mapproducts=new Map<Id,List<Product__c>>();
        Set<String> skewIds=new Set<String>();
        Map<Id,Customized_Price__c> customizePriceMap=new Map<Id,Customized_Price__c>();
        List<Customized_Price__c> CustomizePriceListCopy=[Select id,Project_Name__c,Contact_Pincode__c,Contact_Name__c,Lead_Name__c,SKU__c from Customized_Price__c where id in :CustomizePriceList];
        for(Customized_Price__c Q : CustomizePriceListCopy)
        {
          customizePriceMap.put(Q.id,Q);
          skewIds.add(Q.SKU__c);
        }
        //get Product Details here
        Map<Id,Product2> productMap=new Map<Id,Product2>();
        for(Product2 prod :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: skewIds and IsActive=true])
        {
            productMap.put(prod.id,prod);
            prodMap.put(prod.IB_SKU__c,prod);
        }
       	for(pricebookentry pr :[select Id,Product2Id,Unitprice from pricebookentry where Product2.IB_SKU__c in : skewIds])
        {
        	pricebookEntryMap.put(pr.product2Id,pr); 
        }
          //product Details End here
        Map<id,String> leadPostalcodeMap=new Map<id,String>();
        for(Customized_Price__c q : CustomizePriceListCopy)
        {
           if(q.Contact_Name__c!=null)
           {
               string pincode=q.Contact_Pincode__c;
               User u;
               if(userpincodeMap.containskey(pincode))
               {
                  u=userpincodeMap.get(pincode); 
               }
               String oppid=createProject(q.Contact_Name__c,q.SKU__c,u);
               if(customizePriceMap.containsKey(q.Id))
               customizePriceMap.get(q.Id).Project_Name__c =oppid;
               CustomizeListtoUpdate.add(customizePriceMap.get(q.Id));
           }
           else if(q.Lead_Name__c!=null)
           {
              leadIds.add(q.Lead_Name__c);
              quoteSet.add(q.Id);
           }
        }
        
        
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        Map<Id,List<Customized_Price__c>> leadCustomizePriceMap=new Map<Id,List<Customized_Price__c>>(); 
        
        for(Lead l : [Select id,PostalCode,IsConverted,(Select id,SKU__c from Customized_Prices__r),(Select id from Quotations__r),(Select id from Request_Callbacks__r),(Select id from Refer_Friends__r),Flag_Quotation__c from lead where id in : leadIds])
        {
            leadCustomizePriceMap.put(l.Id,l.Customized_Prices__r);
            leadQuotationNumberMap.put(l.Id,l.Quotations__r); 
       		leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
       		leadReferFrndMap.put(l.id,l.Refer_Friends__r);
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(l.id);
            leadPostalcodeMap.put(l.Id,l.PostalCode);
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            if(l.IsConverted != true)
            MassLeadconvert.add(Leadconvert);
        }
        System.debug('MassLeadconvert--- '+MassLeadconvert.size());
        List<Database.LeadConvertResult> lcr = new List<Database.LeadConvertResult>();
        if (!MassLeadconvert.isEmpty()) 
    	{
        	lcr = Database.convertLead(MassLeadconvert);
    	}
        
        Set<Id> oppIdSet=new Set<Id>();
        Set<Id> accountIdSet=new Set<Id>();
        Set<Id> contactIdSet=new set<Id>();
        System.debug('lcr '+lcr.size());
        for(Database.LeadConvertResult result : lcr)
        {
           oppIdSet.add(result.getOpportunityId()); 
           accountIdSet.add(result.getAccountId());
           contactIdSet.add(result.getContactId());
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT id,Contact_email__c,Prospect_Interest_Type__c,Distributor__c,Contact2__c FROM Opportunity WHERE id IN :oppIdSet]); 
        Map<Id,Contact> cntMap=new Map<Id,Contact>([Select id,mailingpostalcode from contact where id in : contactIdSet]);
        List<Quotation__c> quotationstoUpdate=new List<Quotation__c>();
    	List<Request__c> requesttoUpdate=new List<Request__c>();
    	List<Refer_Friend__c> refertoUpdate=new List<Refer_Friend__c>();
        for(Database.LeadConvertResult result : lcr)
        {
            ID oppId = result.getOpportunityId() != null ? result.getOpportunityId() : null ;
            String pincode=cntMap.get(result.getContactId()).mailingpostalcode;
            User u;
               if(userpincodeMap.containskey(pincode))
               {
                  u=userpincodeMap.get(pincode); 
               }
            oppMap.get(oppID).Name = 'DG-AG-SU-Product-Application';
            oppMap.get(oppID).Status__c = 'Active';
            oppMap.get(oppID).stagename='Trial Scheduled/Intent to buy';
            oppMap.get(oppID).Prospect_Interest_Type__c='Customized Price';
            oppMap.get(oppID).Flag_Get_Customized_Price__c=True;
            oppMap.get(oppID).Customized_Price_Timestamp__c=System.now();
            oppMap.get(oppID).from_Code_updated_Inserted__c='Updated from customizedprizeHandler Line 105';
            oppMap.get(oppID).Contact2__c=cntMap.get(result.getContactId()).id;
            oppMap.get(oppID).closedate=date.valueOf(system.Now().addMonths(2));
            Task cp = new Task();
                cp.Subject = 'Send quote for custom price request';
                cp.WhatId = oppMap.get(oppID).Id;
            	if(u!=null)
                cp.OwnerId =u.Id;
                //t2.ActivityDate = opp.SampleReceivedOn__c + 1;
                cp.Customer_Email_Id__c=oppMap.get(oppID).Contact_email__c ; 
                cp.Status = 'Open';
                cp.Priority = 'High';
                cp.Original_Due_Date__c =system.today()+1;
                // t4.Customer_Email_Id__c=oppmap.get(opp.id);
                cp.ActivityDate=system.today()+1;
            taskstoInsert.add(cp);
            if(leadPostalcodeMap.containskey(result.getLeadId()))
            {
              if(userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId())))
              oppMap.get(oppID).Assigned_IST_User__c=userpincodeMap.get(leadPostalcodeMap.get(result.getLeadId())).id;
              else
              oppMap.get(oppID).Assigned_IST_User__c=label.default_IST;
            }
            opportunitytoUpdate.add(oppMap.get(oppID));
            if(leadCustomizePriceMap.containsKey(result.getLeadId()))
            {
                if(leadCustomizePriceMap.get(result.getLeadId()).size()>0)
                {
                    for(Customized_Price__c q : leadCustomizePriceMap.get(result.getLeadId()))
                    {
                       q.Contact_Name__c=result.getContactId();
                       if(quoteSet.contains(q.Id))
                       {
                          q.Project_Name__c=result.getOpportunityId();
                          q.Contact_Name__c=result.getContactId();
                          createOpportunityLineItem(oppMap.get(oppID).id,q.SKU__c);
                          
                       }
                       CustomizeListtoUpdate.add(q);
                    }
                }
            }
            
            if(leadQuotationNumberMap.containsKey(result.getLeadId()))
            {
                Integer quotationNumber=leadQuotationNumberMap.get(result.getLeadId()).size();
                if(quotationNumber>0)
                {
                    for(Quotation__c q : leadQuotationNumberMap.get(result.getLeadId()))
                    {
                        q.Customer_Contact__c=result.getContactId();
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
                        req.Contact_Name__c=result.getContactId();
                        requesttoUpdate.add(req);
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
                        req.Contact_Name__c=result.getContactId();
                        refertoUpdate.add(req);
                    }
                }  
            }
        }
        if(CustomizeListtoUpdate.size()>0)
        {
           selfupdatetriggerFlag=false;
           update CustomizeListtoUpdate; 
        }
        if(opportunitytoUpdate.size()>0)
        {
            update opportunitytoUpdate;
        }
        if(quotationstoUpdate.size()>0)
        {
           update quotationstoUpdate; 
        }
        if(requesttoUpdate.size()>0)
        {
          update requesttoUpdate;
        }
        if(refertoUpdate.size()>0)
        {
            update refertoUpdate;
        }
        if(taskstoInsert.size()>0)
        {
           Insert  taskstoInsert;
        }
   }
    public static String createProject(String contact_ID,String productSku,user u)
    {
        System.debug('I am creating Opportunity');
        Contact cnt=[Select id,accountid from contact where id=:contact_ID];
        Opportunity newopp=new Opportunity();
        newopp.Name='DG-AG-SU-Product-Application';
        newopp.Status__c='Active';
        newopp.Contact2__c=contact_ID;
        newopp.AccountId=cnt.AccountId;
        newopp.Prospect_Interest_Type__c='Customized Price';
        newopp.StageName='Trial Scheduled/Intent to buy';
        newopp.Flag_Get_Customized_Price__c=True;
        newopp.Customized_Price_Timestamp__c=System.now();
       // newopp.SampleRequested_Timestamp__c=system.today();
        newopp.from_Code_updated_Inserted__c='Inserted from CustomizedPrizeHandler Line 154';
        if(u!=Null)
        newopp.Assigned_IST_User__c=u.id;
        else
        newopp.Assigned_IST_User__c=label.default_IST;
        //newopp.Which_Product_Sent__c =ct.Which_Product_Sent__c;
        newopp.CloseDate=date.valueOf(system.Now().addMonths(2));
        insert newopp;
        //opptoInsert.add(newopp);
      
        Task cp = new Task();
                cp.Subject = 'Send quote for custom price request';
                cp.WhatId = newopp.Id;
            	if(u!=null)
                cp.OwnerId =u.Id;
                //t2.ActivityDate = opp.SampleReceivedOn__c + 1;
                cp.Customer_Email_Id__c=newopp.Contact_email__c ; 
                cp.Status = 'Open';
                cp.Priority = 'High';
                cp.Original_Due_Date__c =system.today()+1;
                // t4.Customer_Email_Id__c=oppmap.get(opp.id);
                cp.ActivityDate=system.today()+1;
            taskstoInsert.add(cp);
        createOpportunityLineItem(newopp.id,productSku);
        return newopp.id;
    } 
    
    public static void createOpportunityLineItem(String oppId,String productsku)
    {
        System.debug('I am creating OpportunityLineItem');
        System.debug('createOpportunityLineItem--oppId '+oppId);
        OpportunityLineItem oppItem = new OpportunityLineItem();
        oppItem.OpportunityId =oppId;
        oppItem.PricebookEntryId = pricebookEntryMap.get(prodMap.get(productsku).id).id;
        oppItem.UnitPrice = pricebookEntryMap.get(prodMap.get(productsku).id).unitprice;
        oppItem.Quantity=1;
        oppLineItemtoInsert.add(oppItem);
        Insert oppLineItemtoInsert;
     }
}