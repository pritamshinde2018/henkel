/*
 * trigger name : trg_onRequesttoCallBack
*/
public class RequesttoCallbackHandlr 
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
    public static List<Request__c> requestListtoUpdate=new List<Request__c>();
    public static Map<id,List<Quotation__c>> leadQuotationNumberMap=new Map<Id,List<Quotation__c>>();
    public static Map<id,List<Customized_Price__c>> leadCustomizedPriceMap=new Map<Id,List<Customized_Price__c>>();
    public static Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
    public static void trg_RequesttoCallback(list<Request__c> requestList,Map<Id,Request__c> oldMap,Map<String,user> userpincodeMap)
    {
        //List<Request__c> quotationproductList=[Select id,(Select id,SKU__c,Quantity__c from Products__r) from Quotation__c where id in :quotationList];
        //Map<Id,List<Product__c>> mapproducts=new Map<Id,List<Product__c>>();
        Set<String> skewIds=new Set<String>();
        Map<Id,Request__c> requestMap=new Map<Id,Request__c>();
        List<Request__c> requestListCopy=[Select id,Product_SKU__c,Contact_Name__c,Lead_Name__c,Contact_Pincode__c from Request__c where id in :requestList];
        for(Request__c Q : requestListCopy)
        {
          requestMap.put(Q.Id,Q);
          skewIds.add(Q.Product_SKU__c);
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
        for(Request__c q : requestListCopy)
        {
           if(q.Contact_Name__c!=null)
           {
               string pincode=q.Contact_Pincode__c;
               User u;
               if(userpincodeMap.containskey(pincode))
               {
                  u=userpincodeMap.get(pincode); 
               }
               String oppid=createProject(q.Contact_Name__c,q.Product_SKU__c,u);
               if(requestMap.containsKey(q.Id))
               requestMap.get(q.Id).Project_Name__c =oppid;
               requestListtoUpdate.add(requestMap.get(q.Id));
           }
           else if(q.Lead_Name__c!=null)
           {
              leadIds.add(q.Lead_Name__c);
              quoteSet.add(q.Id);
           }
        }
        
        
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        Map<Id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>(); 
        for(Lead l : [Select id,PostalCode,IsConverted,(Select id from Customized_Prices__r) ,(Select id from Quotations__r),(Select id from Refer_Friends__r),(Select id,Product_SKU__c from Request_Callbacks__r),Flag_Quotation__c from lead where id in : leadIds])
        {
            leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
            leadQuotationNumberMap.put(l.Id,l.Quotations__r);
            leadCustomizedPriceMap.put(l.Id,l.Customized_Prices__r);
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
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT id,Prospect_Interest_Type__c,Distributor__c,Contact2__c FROM Opportunity WHERE id IN :oppIdSet]); 
        Map<Id,Contact> cntMap=new Map<Id,Contact>([Select id from contact where id in : contactIdSet]);
        List<Quotation__c> quotationstoUpdate=new List<Quotation__c>();
        List<Customized_Price__c> customizetoUpdate=new List<Customized_Price__c>();
    	List<Refer_Friend__c> refertoUpdate=new List<Refer_Friend__c>();
        for(Database.LeadConvertResult result : lcr)
        {
            ID oppId = result.getOpportunityId() != null ? result.getOpportunityId() : null ;
            oppMap.get(oppID).Name = 'DG-AG-SU-Product-Application';
            oppMap.get(oppID).from_Code_updated_Inserted__c='Updated from RequesttoCallbackHandlr Class';
            oppMap.get(oppID).Status__c = 'Active';
            oppMap.get(oppID).stagename='Trial Scheduled/Intent to buy';
            oppMap.get(oppID).Flag_Request_Callback__c=True;
            oppMap.get(oppID).Request_Callback_Timestamp__c=System.now();
            oppMap.get(oppID).CloseDate =date.valueOf(system.Now().addMonths(2));
            oppMap.get(oppID).Contact2__c=cntMap.get(result.getContactId()).id;
            if(leadPostalcodeMap.containskey(result.getLeadId()))
            {
              if(userpincodeMap.containskey(leadPostalcodeMap.get(result.getLeadId())))
              oppMap.get(oppID).Assigned_IST_User__c=userpincodeMap.get(leadPostalcodeMap.get(result.getLeadId())).id; 
           	  else
              oppMap.get(oppID).Assigned_IST_User__c=label.default_IST;
            }
            opportunitytoUpdate.add(oppMap.get(oppID));
            if(leadRequestCallBackMap.containsKey(result.getLeadId()))
            {
                if(leadRequestCallBackMap.get(result.getLeadId()).size()>0)
                {
                    for(Request__c q : leadRequestCallBackMap.get(result.getLeadId()))
                    {
                       q.Contact_Name__c=result.getContactId();
                       if(quoteSet.contains(q.Id))
                       {
                          q.Project_Name__c=result.getOpportunityId();
                          q.Contact_Name__c=result.getContactId();
                          createOpportunityLineItem(oppMap.get(oppID).id,q.Product_SKU__c);
                          
                       }
                       requestListtoUpdate.add(q);
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
        if(requestListtoUpdate.size()>0)
        {
           selfupdatetriggerFlag=false;
           update requestListtoUpdate; 
        }
        if(quotationstoUpdate.size()>0)
        {
           update quotationstoUpdate;
        }
        if(customizetoUpdate.size()>0)
        {
           update customizetoUpdate; 
        }
        if(refertoUpdate.size()>0)
        {
           update refertoUpdate; 
        }
        if(opportunitytoUpdate.size()>0)
        {
            update opportunitytoUpdate;
        }
   }
    public static String createProject(String contact_ID,String productSku,user u)
    {
        System.debug('I am creating Opportunity');
        Contact cnt=[Select id,accountid from contact where id=:contact_ID];
        Opportunity newopp=new Opportunity();
        newopp.Name='DG-AG-SU-Product-Application';
        newopp.from_Code_updated_Inserted__c='Inserted from requesttoCallbackHandler';
        newopp.Status__c='Active';
        newopp.Flag_Request_Callback__c=True;
        newopp.Request_Callback_Timestamp__c=System.now();
        newopp.Contact2__c=contact_ID;
        if(u!=null)
        newopp.Assigned_IST_User__c=u.Id;  
        else
        newopp.Assigned_IST_User__c=label.default_IST;
        
        newopp.AccountId=cnt.AccountId;
        newopp.Prospect_Interest_Type__c='Request a callback';
        newopp.StageName='Sample Sent/Inquiry Received';
        //newopp.SampleRequested_Timestamp__c=system.today();
        //newopp.Which_Product_Sent__c =ct.Which_Product_Sent__c;
        newopp.CloseDate=date.valueOf(system.Now().addMonths(2));
        insert newopp;
        //opptoInsert.add(newopp);
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