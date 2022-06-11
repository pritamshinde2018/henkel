public class QuotationTriggerHandlr 
{
    public static List<Opportunity> opptoInsert=new List<Opportunity>();
    public static List<Quotation__c> quotationListtoUpdate=new List<Quotation__c>();
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
    public static Map<id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>();
    public static Map<id,List<Customized_Price__c>> leadCustomizedPriceMap=new Map<Id,List<Customized_Price__c>>();
    public static Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
    public static List<Task> taskstoInsert=new List<Task>();
    public static void trg_Quotation(list<Quotation__c> quotationList,Map<Id,Quotation__c> oldMap,Map<String,user> userpincodeMap)
    {
        List<Quotation__c> quotationproductList=[Select id,Opportunity__c,Customer_Contact__c,Lead_Name__c,(Select id,SKU__c,Quantity__c from Products__r) from Quotation__c where id in :quotationList];
        Map<Id,List<Product__c>> mapproducts=new Map<Id,List<Product__c>>();
        Set<String> skewIds=new Set<String>();
        Map<Id,Quotation__c> quotMap=new Map<Id,Quotation__c>();
        for(Quotation__c Q : quotationproductList)
        {
          mapproducts.put(Q.id,Q.Products__r);
           quotMap.put(Q.Id,Q);
          for(Product__c pr  : Q.Products__r)
          {
              skewIds.add(pr.SKU__c);
          }
          
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
        for(Quotation__c q : quotationList)
        {
           if(q.Customer_Contact__c!=null)
           {
               string pincode=q.Contact_Pincode__c;
               User u;
               if(userpincodeMap.containskey(pincode))
               {
                  u=userpincodeMap.get(pincode); 
               }
               String oppid=createProject(q.Customer_Contact__c,mapproducts.get(q.Id),u);
               System.debug('oppid----- '+oppid);
               if(quotMap.containsKey(q.Id))
               quotMap.get(q.Id).Opportunity__c =oppid;
               quotationListtoUpdate.add(quotMap.get(q.Id));
           }
           else if(q.Lead_Name__c!=null)
           {
              leadIds.add(q.Lead_Name__c);
              quoteSet.add(q.Id);
           }
        }
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        Map<Id,List<Quotation__c>> leadQuotationMap=new Map<Id,List<Quotation__c>>(); 
        for(Lead l : [Select id,PostalCode,IsConverted,(Select id from Quotations__r),(Select id from Refer_Friends__r),(Select id from Request_Callbacks__r),(Select id from Customized_Prices__r),Flag_Quotation__c from lead where id in : leadIds])
        {
            leadQuotationMap.put(l.Id,l.Quotations__r);
            leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
       		leadCustomizedPriceMap.put(l.id,l.Customized_Prices__r);
       		leadReferFrndMap.put(l.id,l.Refer_Friends__r);
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            leadPostalcodeMap.put(l.Id,l.PostalCode);
            Leadconvert.setLeadId(l.id);
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
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT id,Contact_email__c,Assigned_IST_User__c ,Prospect_Interest_Type__c,Distributor__c,Contact2__c FROM Opportunity WHERE id IN :oppIdSet]); 
        Map<Id,Contact> cntMap=new Map<Id,Contact>([Select id,MailingPostalCode  from contact where id in : contactIdSet]);
        List<Request__c> requesttoUpdate=new List<Request__c>();
    	List<Customized_Price__c> customizetoUpdate=new List<Customized_Price__c>();
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
            oppMap.get(oppID).prospect_interest_type__c='Quotation';
            oppMap.get(oppID).from_Code_updated_Inserted__c='Updated from the QuotationTriggerHandler Line no. 105';
            oppMap.get(oppID).Contact2__c=cntMap.get(result.getContactId()).id;
            oppMap.get(oppID).Flag_Quotation__c=True;
            oppMap.get(oppID).Quotation_Timestamp__c=System.Now();
            oppMap.get(oppID).CloseDate=date.valueOf(system.Now().addMonths(2));
            Task quote = new Task();
            quote.Subject = 'Check customer\'s intent basis quotation';
                quote.WhatId = oppMap.get(oppID).Id;
                if(u!=null)
                quote.OwnerId =u.id;
                //t2.ActivityDate = opp.SampleReceivedOn__c + 1;
                quote.Customer_Email_Id__c=oppMap.get(oppID).Contact_email__c ; 
                quote.Status = 'Open';
                quote.Priority = 'High';
                quote.Original_Due_Date__c =system.today()+1;
                // t4.Customer_Email_Id__c=oppmap.get(opp.id);
                quote.ActivityDate=system.today()+1;
            taskstoInsert.add(quote);
            System.debug('userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId()))--- '+userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId())));
            if(leadPostalcodeMap.containskey(result.getLeadId()))
            {
              System.debug('userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId()))---'+userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId())));
              if(userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId())))
              oppMap.get(oppID).Assigned_IST_User__c=userpincodeMap.get(leadPostalcodeMap.get(result.getLeadId())).id; 
              else
              oppMap.get(oppID).Assigned_IST_User__c=label.default_IST;
            }
            opportunitytoUpdate.add(oppMap.get(oppID));
            if(leadQuotationMap.containsKey(result.getLeadId()))
            {
                if(leadQuotationMap.get(result.getLeadId()).size()>0)
                {
                    for(Quotation__c q : leadQuotationMap.get(result.getLeadId()))
                    {
                       q.Customer_Contact__c=result.getContactId();
                       if(quoteSet.contains(q.Id))
                       {
                          q.Opportunity__c=result.getOpportunityId();
                          q.Customer_Contact__c=result.getContactId();
                          createOpportunityLineItem(oppMap.get(oppID).id,mapproducts.get(q.Id));
                          
                       }
                       quotationListtoUpdate.add(q);
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
        	if(leadCustomizedPriceMap.containsKey(result.getLeadId()))
        	{
           Integer Customizepricecnt =leadCustomizedPriceMap.get(result.getLeadId()).size();
            if(Customizepricecnt>0)
            {
               for(Customized_Price__c req : leadCustomizedPriceMap.get(result.getLeadId()))
               {
                   req.Contact_Name__c=result.getContactId();
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
                   req.Contact_Name__c=result.getContactId();
                   refertoUpdate.add(req);
               }
            }  
        }
        }
        
        if(quotationListtoUpdate.size()>0)
        {
           selfupdatetriggerFlag=false;
           update quotationListtoUpdate; 
        }
        if(opportunitytoUpdate.size()>0)
        {
            update opportunitytoUpdate;
        }
        if(customizetoUpdate.size()>0)
        {
            update customizetoUpdate;
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
            insert taskstoInsert;
        }
        
    }
    public static String createProject(String contact_ID,List<Product__c> productList,user u)
    {
        System.debug('I am creating Opportunity');
        Contact cnt=[Select id,accountid from contact where id=:contact_ID];
        Opportunity newopp=new Opportunity();
        newopp.Name='DG-AG-SU-Product-Application';
        newopp.Status__c='Active';
        newopp.Contact2__c=contact_ID;
        newopp.closedate=date.valueOf(system.Now().addMonths(2));
        if(u!=null)
        newopp.Assigned_IST_User__c=u.id;
        else
        newopp.Assigned_IST_User__c=label.default_IST;
        newopp.AccountId=cnt.AccountId;
        newopp.Prospect_Interest_Type__c='Quotation';
        newopp.from_Code_updated_Inserted__c='Created from the QuotationTriggerHandler Line number : 156';
        newopp.StageName='Trial Scheduled/Intent to buy';
        newopp.probability=30;
        newopp.Flag_Quotation__c=True;
        newopp.Quotation_Timestamp__c=System.Now();
        insert newopp;
        
        Task quote = new Task();
            quote.Subject = 'Check customer\'s intent basis quotation';
                quote.WhatId = newopp.Id;
        		if(u!=null)
                quote.OwnerId = u.id;
                //t2.ActivityDate = opp.SampleReceivedOn__c + 1;
                quote.Customer_Email_Id__c=newopp.Contact_email__c ; 
                quote.Status = 'Open';
                quote.Priority = 'High';
                quote.Original_Due_Date__c =system.today()+1;
                // t4.Customer_Email_Id__c=oppmap.get(opp.id);
                quote.ActivityDate=system.today()+1;
            taskstoInsert.add(quote);
        
        
        //opptoInsert.add(newopp);
        createOpportunityLineItem(newopp.id,productList);
        return newopp.id;
    } 
   
    
    public static void createOpportunityLineItem(String oppId,List<Product__c> productList)
    {
        System.debug('I am creating OpportunityLineItem');
        System.debug('createOpportunityLineItem--oppId '+oppId);
        for(Product__c productObj : productList)
        {
            OpportunityLineItem oppItem = new OpportunityLineItem();
        	oppItem.OpportunityId =oppId;
        	oppItem.PricebookEntryId = pricebookEntryMap.get(prodMap.get(productObj.SKU__c).id).id;
        	//oppItem.Quantity = Decimal.valueOf(listId[p].Quanitity__c);
        	
            //if(opplineItemMap.containsKey(productObj.sku))
        	oppItem.UnitPrice = pricebookEntryMap.get(prodMap.get(productObj.SKU__c).id).unitprice;
            oppItem.Quantity=Decimal.valueOf(productObj.Quantity__c);
            //oppItem.TotalPrice=100;
        	oppLineItemtoInsert.add(oppItem);
        }        
        Insert oppLineItemtoInsert;
    }
}