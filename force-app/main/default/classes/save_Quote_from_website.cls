/**
 * created Date : 02/01/2020
 * created By : Akshay Phatak
 * Wrapper Class: quoteResponse
 * Test Class : testQuotationNotification
*/
public class save_Quote_from_website 
{

    public static Set<String> productSkewIds=new Set<String>();
    public static Map<String,Product2> prodMap = new  Map<String,Product2>();
    public static Map<String,OpportunityLineItem> opplineItemMap=new Map<String,OpportunityLineItem>();
    public static Map<String,pricebookentry> pricebookEntryMap=new Map<String,pricebookentry>();
    public static List<Quotation__c> quoteListtoUpdate=new List<Quotation__c>();
    public static string store_Quote(String jsonString)
    {
      try
      {
          List<quoteResponse> responseList=(List<quoteResponse>)system.JSON.deserialize(jsonString,List<quoteResponse>.class);
          String emailAddress=responseList[0].user_contact_detail.email;
          if(emailAddress=='' || emailAddress==null)
          {
             return 'Email cant be empty'; 
          }
          //get Product Details here
          
        /*for(quoteResponse.product_infoWrapper productObj :responseList[0].quotation.product_info)
        {
            productSkewIds.add(productObj.sku);
        }
        System.debug('productSkewIds---- '+productSkewIds);
        Map<Id,Product2> productMap=new Map<Id,Product2>();
        for(Product2 prod :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: productSkewIds and IsActive=true])
        {
            productMap.put(prod.id,prod);
            prodMap.put(prod.IB_SKU__c,prod);
        }
        for(OpportunityLineItem opplineItem :[select Id,Product2Id,ListPrice,UnitPrice from OpportunityLineItem where Product2.IB_SKU__c in :productSkewIds])
        {
            
            if(!opplineItemMap.containsKey(opplineItem.Product2Id))
            {
                System.debug('opplineItem Product2Id----'+opplineItem.Product2Id);
            opplineItemMap.put(productMap.get(opplineItem.Product2Id).IB_SKU__c,opplineItem);
            }
        }
        System.debug('opplineItemMap-- '+opplineItemMap);
        for(pricebookentry pr :[select Id,Product2Id,Unitprice from pricebookentry where Product2Id in : prodMap.values()])
        {
            pricebookEntryMap.put(pr.product2Id,pr); 
        }*/
          //product Details End here
          String contactorLeadId=getContactOrLeadId(responseList[0].user_contact_detail);
          System.debug('contactorLeadId--- '+contactorLeadId);
          String checkcontactorLead=contactorLeadId.substringBefore('-');
          String contactId;
          String LeadId;
          if(checkcontactorLead=='ContactID')
          {
              contactId=contactorLeadId.substringAfter('-');
          }
          else
          {
              LeadId=contactorLeadId.substringAfter('-');
          }
          String quoteID=generateQuote(contactId,LeadId,responseList[0].quotation);
          System.debug('quoteID------ '+quoteID);
          Update quoteListtoUpdate;
          return 'success';
      }
      catch(Exception e)
      {
        system.debug('e.getmessage '+e.getMessage());
        System.debug('e.getnumber '+e.getLineNumber());
        String Errormessge=e.getMessage()+e.getLineNumber();
        return Errormessge;
      }
    }
    public static String getContactOrLeadId(quoteResponse.user_contact_detailWrapper userDetails)
    {
        String email=userDetails.email;
        List<Contact> contactList=[Select id,accountId from Contact where Email=:email order by createdDate desc];
        List<Lead> LeadList=[Select id from Lead where Email=:email order by createdDate desc];
        if(contactList.size()==0 && LeadList.size()==0)
        {
           //Create new Lead here 
           Lead newLead=new Lead();
           newLead.LastName=userDetails.name;
           newLead.Email=userDetails.email;
           newLead.Company=userDetails.company;
           newLead.Phone=userDetails.phone;
           newlead.PostalCode=userDetails.pincode;
           newLead.Industry=userDetails.industry;
            newLead.promo_accept_date__c = userDetails.promo_accept_date;
            newLead.promo_accept_time__c = userDetails.promo_accept_time;
            newLead.privacy_accept_date__c = userDetails.privacy_accept_date;
            newLead.privacy_accept_time__c = userDetails.privacy_accept_time;
           newLead.Prospect_Interest_Type__c='Quotation'; 
           newLead.Flag_Quotation__c=true;
           //newLead.Role_in_organisation_IM__c=userDetails.role_in_the_organisation;
           newLead.Role_in_organisation__c=userDetails.role_in_the_organisation;
           newLead.Number_of_Employees_Custom__c=userDetails.no_of_employees;
           newLead.url_params__c=userDetails.url_params;
           newLead.Ecom_campaign__c=userDetails.utm_campaign;
           newLead.Ecom_content__c=userDetails.utm_content;
           newLead.Ecom_media__c=userDetails.utm_medium;
           newLead.Ecom_term__c=userDetails.utm_term;
           newLead.Ecom_Source__c=userDetails.utm_source;            
           //newLead.NumberOfEmployees=Integer.valueOf(userDetails.no_of_employees);
           Insert newLead;
           return 'LeadID-'+newLead.id;
        }
        else
        {
            //Check Existing Contact or Lead
           if(contactList.size()!=0)
           {
               Contact cnt=new Contact();
               cnt.Id=contactList[0].id;
               List<Account> acc=[Select id,name,Industry from account where id=: contactList[0].AccountId limit 1];
               if(acc.size()>0){
               if(acc[0]!=null && userDetails.company!=null)
               {acc[0].Name=userDetails.company;}
               if(userDetails.industry!=null)
               acc[0].Industry=userDetails.industry;
               update acc[0];
               }
               cnt.Flag_Quotation__c=true;
               cnt.LastName=userDetails.name;
               cnt.MailingPostalCode=userDetails.pincode;
               cnt.url_params__c=userDetails.url_params;
               cnt.Ecom_campaign__c=userDetails.utm_campaign;
               cnt.Ecom_content__c=userDetails.utm_content;
               cnt.Ecom_media__c=userDetails.utm_medium;
               cnt.Ecom_term__c=userDetails.utm_term;
               cnt.Ecom_Source__c=userDetails.utm_source;
               cnt.Prospect_Interest_Type__c='Quotation';
               cnt.Number_of_Employees_Custom__c=userDetails.no_of_employees;
               cnt.Industry__c=userDetails.industry;
               cnt.Role_in_organisation__c=userDetails.role_in_the_organisation;
               cnt.Phone=userDetails.phone;
               update cnt;
               return 'ContactID-'+contactList[0].id;
           }
           else if(LeadList.size()!=0)
           {
               Lead leadtoUpdate=new Lead();
               leadtoUpdate.id=LeadList[0].id;
               leadtoUpdate.Flag_Quotation__c=true;
               leadtoUpdate.LastName=userDetails.name;
               leadtoUpdate.Company=userDetails.company;
               leadtoUpdate.Phone=userDetails.phone;
               leadtoUpdate.PostalCode=userDetails.pincode;
               leadtoUpdate.Industry=userDetails.industry;
               leadtoUpdate.Prospect_Interest_Type__c='Quotation'; 
               //leadtoUpdate.Role_in_organisation_IM__c=userDetails.role_in_the_organisation;
               leadtoUpdate.Role_in_organisation__c=userDetails.role_in_the_organisation;
               leadtoUpdate.Number_of_Employees_Custom__c=userDetails.no_of_employees;
               leadtoUpdate.url_params__c=userDetails.url_params;
               leadtoUpdate.Ecom_campaign__c=userDetails.utm_campaign;
               leadtoUpdate.Ecom_content__c=userDetails.utm_content;
               leadtoUpdate.Ecom_media__c=userDetails.utm_medium;
               leadtoUpdate.Ecom_term__c=userDetails.utm_term;
               leadtoUpdate.Ecom_Source__c=userDetails.utm_source;  
               //leadtoUpdate.NumberOfEmployees=Integer.valueOf(userDetails.no_of_employees);
               Update leadtoUpdate;
               return 'LeadID-'+LeadList[0].id;
           }
            
           return null;
          
        }
        
    }
    
    public static string generateQuote(String contactId,String LeadId,quoteResponse.quotationwrapper quoteInfo)
    {
        System.debug('generateQuote-contactId---- '+contactId);
        System.debug('generateQuote-LeadId---- '+LeadId);
        Id CTArecordTypeId =Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Quotation').getRecordTypeId();
        String OpportunityID;
        Quotation__c quote=new Quotation__c();
        CTA__c quotationCTA=new CTA__c();
        quotationCTA.RecordTypeId=CTArecordTypeId;
         if(contactId!=null && contactId!='')
         {
           quote.Customer_Contact__c=contactId;
           quotationCTA.Customer_Contact__c=contactId;
           quotationCTA.CTA_stage__c='Assigned to IST';
           //List<Opportunity> oppList=[Select id,contactId,Prospect_Interest_Type__c  from Opportunity where contactID=:contactId and Prospect_Interest_Type__c='Quotation' order by createdDate desc];
           /*if(oppList.size()!=0)
           {
               OpportunityID=oppList[0].id;
               createOpportunityLineItem(oppList[0].id,quoteInfo);
               System.debug('OpportunityID----- '+OpportunityID);
           }
           else
           {
               OpportunityID=createProject(contactId,quoteInfo);
               createOpportunityLineItem(OpportunityID,quoteInfo);
               System.debug('OpportunityID---- '+OpportunityID);
           }*/
        }
         quote.Comments__c=quoteInfo.Comments;
         quote.Quotation_Number__c=Decimal.valueOf(quoteInfo.Quotation_Number);
         quote.Product_Names__c=quoteInfo.Product_Names;
         quote.Approver_Email__c=quoteInfo.approver_email;
         quote.Total_Product_Number__c=quoteInfo.Total_Product_Number;
         quote.Coupon_Code__c=quoteInfo.Coupon_Code;
         quote.Quote_PDF_Link__c=quoteInfo.Quote_PDF_Link;
         quote.Total_MRP__c=Decimal.valueOf(quoteInfo.Total_MRP);
         quote.Total_Price__c=Decimal.valueOf(quoteInfo.Total_Price);
         quote.Discount_Applied__c=Decimal.valueOf(quoteInfo.Discount_Applied);
         quote.GST_Price__c=Decimal.valueOf(quoteInfo.GST_Price);
         quote.Total__c=Decimal.valueOf(quoteInfo.Total);
         quote.Shipping_Charge__c=Decimal.valueOf(quoteInfo.Shipping_Charge);
         quote.Total_Payable__c =Decimal.valueOf(quoteInfo.Total_Payable);
        
        
        
        
        
          
         quotationCTA.Comments__c=quoteInfo.Comments;
         quotationCTA.Quotation_Number__c=Decimal.valueOf(quoteInfo.Quotation_Number);
         quotationCTA.Product_Names__c=quoteInfo.Product_Names;
         quotationCTA.Approver_Email__c=quoteInfo.approver_email;
         quotationCTA.Total_Product_Number__c=quoteInfo.Total_Product_Number;
         quotationCTA.Coupon_Code__c=quoteInfo.Coupon_Code;
         quotationCTA.Quote_PDF_Link__c=quoteInfo.Quote_PDF_Link;
         quotationCTA.Total_MRP__c=Decimal.valueOf(quoteInfo.Total_MRP);
         quotationCTA.Total_Price__c=Decimal.valueOf(quoteInfo.Total_Price);
         quotationCTA.Discount_Applied__c=Decimal.valueOf(quoteInfo.Discount_Applied);
         quotationCTA.GST_Price__c=Decimal.valueOf(quoteInfo.GST_Price);
         quotationCTA.Total__c=Decimal.valueOf(quoteInfo.Total);
         quotationCTA.Shipping_Charge__c=Decimal.valueOf(quoteInfo.Shipping_Charge);
         quotationCTA.Total_Payable__c =Decimal.valueOf(quoteInfo.Total_Payable);
         //quote.CC_Status__c='mql';
         if(OpportunityID!=null && OpportunityID!='')
         {
            quote.Opportunity__c= OpportunityID;
         }
         if(LeadId!=null && LeadId!='')
         {
             quote.Lead_Name__c=LeadId;
             quotationCTA.Lead__c=LeadId;
         }
         Insert quote;
        Insert quotationCTA;
         createQuotationProducts(quote.id,quoteInfo,quotationCTA.Id);
         QuotationsMails.sendQuotationMails(quote.Id);
        /*quote.CC_Status__c='mql';
        update quote;*/
         return quote.id;
     
    }
    public static void createQuotationProducts(String Quotationid,quoteResponse.quotationwrapper quoteInfo, String ctaid)
    {
       System.debug('I am creating QuotationProducts');
       List<Product__c> quoteProductList=new List<Product__c>();
       for(quoteResponse.product_infoWrapper productObj : quoteInfo.product_info)
        {
            Product__c quotionProduct=new Product__c();
            quotionProduct.SKU__c=productObj.sku;
            quotionProduct.Quantity__c=String.valueof(productObj.quantity);
            quotionProduct.Name = productObj.itemTitle;  
            quotionProduct.Product_Image_URL__c=productObj.image;
            quotionProduct.GST_Price__c=Decimal.valueOf(productObj.gst);
            quotionProduct.GST_Percentage__c=productObj.gstpercentage;
            quotionProduct.Unit_Price__c=Decimal.valueOf(productObj.unitprice);
            quotionProduct.Total__c=Decimal.valueOf(productObj.total);
            quotionProduct.Product_Discription__c=productObj.product_Description;
            quotionProduct.Quotation__c=Quotationid;
            quotionProduct.CTA__c=ctaid;
            quoteProductList.add(quotionProduct) ;     
         }
        System.debug('quoteProductList.size()---- '+quoteProductList.size());
        insert quoteProductList;
    }
    /*public static String createProject(String contact_ID,quoteResponse.quotationwrapper quoteInfo)
    {
        System.debug('I am creating Opportunity');
        Contact cnt=[Select id,accountid from contact where id=:contact_ID];
        Opportunity newopp=new Opportunity();
        newopp.Name='DG-AG-SU-Product-Application';
        newopp.Status__c='Active';
        newopp.Contact2__c=contact_ID;
        newopp.AccountId=cnt.AccountId;
        newopp.Prospect_Interest_Type__c='Quotation';
        newopp.StageName='Trial Scheduled/Intent to buy/Webinar attended';
        newopp.SampleRequested_Timestamp__c=system.today();
        //newopp.Which_Product_Sent__c =ct.Which_Product_Sent__c;
        newopp.CloseDate=system.today();
        insert newopp;
        return newopp.id;
    } */ 
    
    /*public static void createOpportunityLineItem(String oppId,quoteResponse.quotationwrapper quoteInfo)
    {
        System.debug('I am creating OpportunityLineItem');
        System.debug('createOpportunityLineItem--oppId '+oppId);
        List<quoteResponse.product_infoWrapper> quoteProducts=new List<quoteResponse.product_infoWrapper>();
        
        quoteProducts.addAll(quoteInfo.product_info);
        List<opportunityLineItem> oppItemList=new List<opportunityLineItem>();
        System.debug('quoteInfo.product_info------ '+quoteInfo.product_info);
        System.debug('quoteInfo.product_info size------ '+quoteInfo.product_info.size());
        for(quoteResponse.product_infoWrapper productObj : quoteInfo.product_info)
        {
            OpportunityLineItem oppItem = new OpportunityLineItem();
            oppItem.OpportunityId =oppId;
            oppItem.PricebookEntryId = pricebookEntryMap.get(prodMap.get(productObj.sku).id).id;
            //oppItem.Quantity = Decimal.valueOf(listId[p].Quanitity__c);
            System.debug('productObj.sku------ '+productObj.sku);
            System.debug('opplineItemMap-----   '+opplineItemMap);
            //if(opplineItemMap.containsKey(productObj.sku))
            oppItem.UnitPrice = pricebookEntryMap.get(prodMap.get(productObj.sku).id).unitprice;
            oppItem.Quantity=productObj.quantity;
            //oppItem.TotalPrice=100;
            oppItemList.add(oppItem);
        }        
        Insert oppItemList;
    }*/ 
    
}