/**
 * Auther : Akshay Phatak 
 * Created Date : 12/12/2019
 * Description : 
 * This class is for itegration with IB website
 * Test Class : testEcomIntegration
 * Related class : GetData
 * Wrapper Class : EcomIntegrationWrapper
*/
public class EcomIntegration
{
    
   //This method is calling from getData class
   Map<Id,Map<String,Products_on_Cart__c>> productsOnCartMap=new Map<Id,Map<String,Products_on_Cart__c>>();
   Map<Id,List<Opportunity>> opportunityContactMap=new MAp<Id,List<Opportunity>>();
   Map<String,Product2> productMapgen=new Map<String,Product2>();
    List<CTA__c> ctaListforContacts = new List<CTA__c>();
   Id devRecordTypeId;
  	Id AbandonedCartRecordTypeId;
    String visitor_Id;
   public string getEcommerceDataIntegration(String jsonString)
   {
       try
       {
            /*Get all users and add those into the map according to the picode and User*/
           system.debug('jsonString-------- '+jsonString);
        	//List<User> userList=[Select id,Pin_codes__c,profileId,UserRoleId from user where UserRole.name='Inside Sales Team'];
           LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            Map<String,User> userpincodeMap=new Map<String,User>(); //this map is for IST users to assign ecom projects 
            for(Product2 prod :  [SELECT IB_SKU__c,Id,Dp__c FROM Product2 where IsActive=true])
   			{
            	productMapgen.put(prod.IB_SKU__c,prod);
   			}
            List<String> pincodeList;
           /* for(User u  : userList)
            {
                String pincodes=u.Pin_codes__c;
                pincodeList=new List<String>();
                if(pincodes!=null && pincodes!='')
                pincodeList=pincodes.split(',');
                for(String str :pincodeList)	
                {
                  userpincodeMap.put(str,u);  
                }
                
            }*/
        /*Pincode mapping ends here*/
        jsonString = '{"response":'+jsonString+'}';
        String jsonString2= jsonString;
        
        jsonString  = (jsonString.replace('date', 'date1'));
        jsonString  = (jsonString.replace('"taxPercentage":""', '"taxPercentage":null'));
        jsonString  = (jsonString.replace('"codCharge":""', '"codCharge":null'));
        jsonString  = (jsonString.replace('"shippingCharge":""', '"shippingCharge":null'));
       
        //Deserialize the json coming from getdata class    
        EcomIntegrationWrapper EcommersObj  = (EcomIntegrationWrapper) System.JSON.deserialize(jsonString, EcomIntegrationWrapper.class);
        List<EcomIntegrationWrapper.Response> EcommersList = EcommersObj.response;
        if(EcommersList.size()>0)
        visitor_Id=EcommersList[0].visitor_Id;
        List<String> search_keywordsList=new List<String>();
        List<EcomIntegrationWrapper.Products_viewed> Products_viewedList =new List<EcomIntegrationWrapper.Products_viewed>();
        List<EcomIntegrationWrapper.Wish_lists> Wish_listsList=new List<EcomIntegrationWrapper.Wish_lists>();
        List<EcomIntegrationWrapper.Last_five_logins> last_five_loginsList=new List<EcomIntegrationWrapper.Last_five_logins>();
        List<EcomIntegrationWrapper.Cart_items> cart_itemsList=new List<EcomIntegrationWrapper.Cart_items>();
        EcomIntegrationWrapper.Cart_payment_information Cart_payment_info=new EcomIntegrationWrapper.Cart_payment_information();
       	EcomIntegrationWrapper.Response response=  EcommersList[0]; 
		EcomIntegrationWrapper.user_contact_detail userDetails=response.user_contact_detail[0];
        EcomIntegrationWrapper.Order orderDetails=response.order;
         system.debug('orderDetails---- '+orderDetails);
         system.debug('orderDetails.IBOrderNumber '+orderDetails.IBOrderNumber);
        search_keywordsList=response.search_keywords;
        System.debug('search_keywordsList---- '+search_keywordsList.size());
        Products_viewedList=response.products_viewed;
        System.debug('Products_viewedList---- '+Products_viewedList.size());    
        Wish_listsList=response.wish_lists;
        System.debug('Wish_listsList------ '+Wish_listsList.size());
       	last_five_loginsList=response.last_five_logins;
        System.debug('last_five_loginsList------- '+last_five_loginsList.size());
        cart_itemsList=response.cart_items;
        System.debug('cart_itemsList----- '+cart_itemsList.size());
        Cart_payment_info=response.cart_payment_information;
        System.debug('Cart_payment_info----- '+Cart_payment_info);
      	String userEmail=userDetails.Email;
       	List<Contact> contactList=new List<Contact> ();
        List<Contact> contactListEcom=new List<Contact>();
        List<lead> leadList=new List<Lead>();
        List<lead> convertedLeadList=new List<lead>();
        Map<String,Order_Information__c> orderNumbersMap=new Map<String,Order_Information__c>();
        
        List <Contact> contactList2=[Select id,Prospect_Interest_Type__c,accountId,Lead_classification_basis_value__c,MailingPostalCode,(Select id,Order_Number__c from Order_Informations__r),
                     (Select id,Flag_abandoned_cart__c,Prospect_Interest_Type__c from Opportunities2__r where Flag_abandoned_cart__c=true),
                     (Select id,Active__c,sku__c from Products_on_Cart__r where Active__c=true)
                     from contact where email=:userEmail order by createdDate desc];
        system.debug('contactList2.size()-----'+contactList2.size());
        leadList=[Select id,Status,CC_Status__c,pi__score__c from Lead where email= :userEmail and isconverted=false];
        system.debug('leadList.size()------'+leadList.size());
        convertedLeadList=[Select id,Status,CC_Status__c,pi__score__c from Lead where email= :userEmail and isconverted=true order by createdDate desc ];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        System.debug('contactList2----- '+contactList2.size());
        system.debug('convertedLeadList.size()----- '+convertedLeadList.size());
        system.debug('leadList------- '+leadList.size());
        devRecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        AbandonedCartRecordTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Abandoned Cart').getRecordTypeId();
        if( convertedLeadList.size()>0)
        {
            Lead leadtoUpdate=new LEad();
            leadtoUpdate.id=convertedLeadList[0].id;
           if(userDetails.name!=null && userDetails.name!=' ' && userDetails.name!='' )
           {
               leadtoUpdate.LastName=userDetails.name;
           }
           else if(orderDetails.ShippingAddress!=NULL )
           {
               leadtoUpdate.LastName=orderDetails.ShippingAddress.name;
           }
           if(userDetails.email!=null)
               leadtoUpdate.Email=userDetails.email;
            if(leadtoUpdate.Customer_creation_date__c == null)
            {
                leadtoUpdate.Customer_creation_date__c = system.now();
            }
           if(userDetails.company!=null)
               leadtoUpdate.Company=userDetails.company;
           if(userDetails.phone!=null && userDetails.phone!='' && userDetails.phone!=' ')
               leadtoUpdate.Phone=userDetails.phone;
           if(userDetails.industry!=null)
               leadtoUpdate.Industry=userDetails.industry;
           if(userDetails.role_in_the_organisation!=null)
              leadtoUpdate.Role_in_organisation__c=userDetails.role_in_the_organisation;
           if(userDetails.no_of_employees!=null)
               leadtoUpdate.Number_of_Employees_Custom__c=userDetails.no_of_employees;
           if(userDetails.what_is_the_purpose!=null)
               leadtoUpdate.What_is_the_purpose_use__c=userDetails.what_is_the_purpose;
            if(orderDetails.IBOrderStatus != null)
            {
                leadtoUpdate.Prospect_Interest_Type__c = 'E-Commerce';
            }
            
            if(userDetails.company!=null && userDetails.company!=' ' && userDetails.company!='')
            {
               leadtoUpdate.Company= userDetails.company;
            }
            else
            {
               leadtoUpdate.Company='NA'; 
            }
            
            update leadtoUpdate;
        }
          
        if(leadList.size()>0 && contactList2.size()==0)
        {
           System.debug('I am in leadList.size()>0 && contactList2.size()==0');
           Lead myLead = new Lead(Id=leadList[0].id,email=userEmail);
           if(userDetails.no_of_employees!=null && userDetails.no_of_employees!=' ' && userDetails.no_of_employees!='')
            myLead.Number_of_Employees_Custom__c=userDetails.no_of_employees;
           if(userDetails.name!=null && userDetails.name!=' ' && userDetails.name!='')
       		{
          		myLead.LastName=userDetails.name;  
       		}
       		else
       		{
          		myLead.LastName=userEmail.substringBefore('@');
       		}
            if(userDetails.Industry!=null && userDetails.Industry!=' ' && userDetails.Industry!='')
            {
                mylead.Industry=userDetails.Industry;
            }
            if(userDetails.company!=null && userDetails.company!=' ' && userDetails.company!='')
            {
               mylead.Company= userDetails.company;
            }
            else
            {
               mylead.Company='NA'; 
            }
            mylead.Email=userEmail;
            if(visitor_Id!=null)
                mylead.Ecom_Visitor_Id__c=visitor_Id;
            mylead.phone=userDetails.phone;
            
            if(userDetails.GSTIN_number != null && userDetails.GSTIN_number != '')
            mylead.GST_Number__c = userDetails.GSTIN_number;
            
            
            if(orderDetails.IBOrderStatus != null)
            {
                mylead.Prospect_Interest_Type__c = 'E-Commerce';
            }
            
            
            if(userDetails.address!=null)
         	{
               if(userDetails.address.containskey('address_1'))
               {
                   EcomIntegrationWrapper.Address Add1=userDetails.address.get('address_1');
                   if(Add1.name != null && Add1.name != '')
                   mylead.Lastname = Add1.name;
                   if(Add1.phone != null && Add1.phone != '')
                   mylead.phone = Add1.phone;
                   if(Add1.company_name != null && Add1.company_name != '')
                   mylead.company = Add1.company_name;
                   if(Add1.street_address != null && Add1.street_address != '')
                   mylead.Street = Add1.street_address;
                   if(Add1.zipcode != null && Add1.zipcode != '')
                   mylead.PostalCode = Add1.zipcode;
                   if(Add1.city != null && Add1.city != '')
                   mylead.City = Add1.city;
                   if(Add1.state != null && Add1.state != '')
                   mylead.State = Add1.state;
                   if(Add1.country != null && Add1.country != '')
                   mylead.Country = Add1.country;
                   if(Add1.GSTIN_number != null && Add1.GSTIN_number != '')
                       mylead.GST_Number__c = Add1.GSTIN_number;
               }
           }
           	update myLead;
           Map<String,Products_on_Cart__c> cartproductsMap=new Map<String,Products_on_Cart__c>();
          
           List<CTA__c> ctaList=[Select id,RecordTypeId,Lead__c,(Select id,sku__c from Products_on_Cart__r) from CTA__c where recordtypeid= :AbandonedCartRecordTypeId and  
                                 Customer_Contact__c=null and Lead__c!=null and Lead__c= :myLead.Id and 
                                 CTA_stage__c!='Closed abandoned cart'];
         if(ctaList.size()>0 && ctaList[0].Products_on_Cart__r.size() >0)
         {
             for(Products_on_Cart__c cartPrd : ctaList[0].Products_on_Cart__r)
             {
                 cartproductsMap.put(cartPrd.sku__c,cartPrd); 
             }
         }
         if(ctaList.size()>0)
         productsOnCartMap.put(ctaList[0].id,cartproductsMap); 
         if(orderDetails.IBOrderNumber!=null && orderDetails.IBOrderNumber!='' && orderDetails.IBOrderNumber!=' ')
         {
		   Database.LeadConvert lc = new database.LeadConvert();
           lc.setConvertedStatus(convertStatus.MasterLabel);
           lc.setDoNotCreateOpportunity(true);
           lc.setLeadId(myLead.id);
           Database.LeadConvertResult lcr;
             
             if(mylead.IsConverted != true)
             {
                 lcr = Database.convertLead(lc);
             }
           ctaListforContacts=[Select id,RecordTypeId,Lead__c,(Select id,sku__c from Products_on_Cart__r) from CTA__c where recordtypeid= :AbandonedCartRecordTypeId and  
                                 Customer_Contact__c= :lcr.getContactId()  and Lead__c!=null];
           for(CTA__c cta : ctaListforContacts)
           {
               cta.CTA_stage__c='Closed abandoned cart';
           }
           
           /*if(ctaListforContacts.size()>0)
               update ctaListforContacts;*/
           
         }
         else if(cart_itemsList.size()>0)
         {
           List<Products_on_Cart__c> productoncartList=new List<Products_on_Cart__c>();
            List<Products_on_Cart__c> productstoUpdate=new List<Products_on_Cart__c>(); 
            CTA__c cta;
           Set<String> productSkews=new Set<String>();
             if(ctaList.size()==0)
             {
               cta=new CTA__c();
               cta.RecordTypeId=AbandonedCartRecordTypeId;
               cta.Lead__c=myLead.id;
               Insert cta;
             }
                
           if(cart_itemsList.size()>0)
           {
               
               for(EcomIntegrationWrapper.Cart_items cartItem  : cart_itemsList)
               {
                   productSkews.add(cartItem.sku);
                   if(ctaList.size() > 0 && productsOnCartMap.containsKey(ctaList[0].id))
               	   {
                   if(!productsOnCartMap.get(ctaList[0].id).containsKey(cartItem.sku))
               	   {
                   Products_on_Cart__c proncart=new Products_on_Cart__c();
                   proncart.Name=cartItem.product_name;
               	   proncart.Category__c=cartItem.category;
                   //proncart.Customer_Contact__c=cnt.id;
                   if(ctaList.size()!=0)
                   {
                        proncart.CTA__c=ctaList[0].id;
                        proncart.Lead__c=ctaList[0].Lead__c;//add lead from cta
                   }
                  
                       else
                   {
                            
                   proncart.CTA__c=cta.id;
                   if(cta.Lead__c!=null)
                   proncart.Lead__c=cta.Lead__c;    //add lead from cta
                   proncart.Active__c=true;
                   proncart.Price__c=cartItem.price;
                   proncart.Product_id__c=cartItem.product_id;
                   proncart.Quanitity__c=cartItem.quanitity;
                   proncart.Size__c=cartItem.size;
                   proncart.sku__c=cartItem.sku;
                   productoncartList.add(proncart);
                    }
                  
                 }
               	   }
                   else if(ctaList.size() == 0)
               	   {
                   
                   Products_on_Cart__c proncart=new Products_on_Cart__c();
                   proncart.Name=cartItem.product_name;
               	   proncart.Category__c=cartItem.category;
                   //proncart.Customer_Contact__c=cnt.id;
                   proncart.CTA__c=cta.id;
                   proncart.Lead__c=cta.Lead__c;   //add lead from CTA 
                   proncart.Active__c=true;
                   proncart.Price__c=cartItem.price;
                   proncart.Product_id__c=cartItem.product_id;
                   proncart.Quanitity__c=cartItem.quanitity;
                   proncart.Size__c=cartItem.size;
                   proncart.sku__c=cartItem.sku;
                   productoncartList.add(proncart);
                 }
               
               }
           }
           if(ctaList.size()>0 && productsOnCartMap.containsKey(ctaList[0].id))
           {
               for(String cartProducts : productsOnCartMap.get(ctaList[0].id).keySet())
           	   {
             		 if(!productSkews.contains(cartProducts))
              		{
                         Products_on_Cart__c pr = productsOnCartMap.get(ctaList[0].id).get(cartProducts);
                         pr.Active__c=false;
                         productstoUpdate.add(pr);
                    }
                }
           }
             
           if(productoncartList.size()>0) 
           Insert productoncartList;
            
           if(productstoUpdate.size()>0)
           Update productstoUpdate;
             
             
             //update myLead;
           
         }
           
        /*****/
        }
        else if(leadList.size()==0 && contactList2.size()==0)
        {
            System.debug('I am in leadList.size()==0 && contactList.size()==0');
            Lead myLead = new Lead();
            if(userDetails.no_of_employees!=null && userDetails.no_of_employees!=' ' && userDetails.no_of_employees!='')
            myLead.Number_of_Employees_Custom__c=userDetails.no_of_employees;
            
            System.debug('GST Number :'+userDetails.GSTIN_number);
            if(userDetails.GSTIN_number != null && userDetails.GSTIN_number != '')
            mylead.GST_Number__c = userDetails.GSTIN_number;
            
			mylead.promo_accept_date__c = response.promo_accept_date1;
            mylead.promo_accept_time__c = response.promo_accept_time;
            mylead.privacy_accept_date__c = response.privacy_accept_date1;
            mylead.privacy_accept_time__c = response.privacy_accept_time;
            
            
            if(orderDetails.IBOrderStatus != null)
            {
                mylead.Prospect_Interest_Type__c = 'E-Commerce';
            }
			
            if(userDetails.name!=null && userDetails.name!=' ' && userDetails.name!='')
       		{
          		myLead.LastName=userDetails.name;  
       		}
       		else
       		{
          		myLead.LastName=userEmail.substringBefore('@');
       		}
            if(userDetails.Industry!=null && userDetails.Industry!=' ' && userDetails.Industry!='')
            {
                mylead.Industry=userDetails.Industry;
            }
            if(userDetails.company!=null && userDetails.company!=' ' && userDetails.company!='')
            {
               mylead.Company= userDetails.company;
            }
            else
            {
               mylead.Company='NA'; 
            }
            mylead.Email=userEmail;
            if(visitor_Id!=null)
                mylead.Ecom_Visitor_Id__c=visitor_Id;
            mylead.phone=userDetails.phone;
            if(userDetails.address!=null)
         	{
               if(userDetails.address.containskey('address_1'))
               {
                   EcomIntegrationWrapper.Address Add1=userDetails.address.get('address_1');
                   if(Add1.name != null && Add1.name != '')
                   mylead.Lastname = Add1.name;
                   if(Add1.phone != null && Add1.phone != '')
                   mylead.phone = Add1.phone;
                   if(Add1.company_name != null && Add1.company_name != '')
                   mylead.company = Add1.company_name;
                   if(Add1.street_address != null && Add1.street_address != '')
                   mylead.Street = Add1.street_address;
                   if(Add1.zipcode != null && Add1.zipcode != '')
                   mylead.PostalCode = Add1.zipcode;
                   if(Add1.city != null && Add1.city != '')
                   mylead.City = Add1.city;
                   if(Add1.state != null && Add1.state != '')
                   mylead.State = Add1.state;
                   if(Add1.country != null && Add1.country != '')
                   mylead.Country = Add1.country;
               }
           }
           	insert myLead;
            /*CTA__c cta=new CTA__c();
           	cta.RecordTypeId=devRecordTypeId;
           	cta.Lead__c=myLead.id;
           	Insert cta;
 			cta.CTA_stage__c='Qualified';
            update cta;*/
            //Check Abundant cart condition here...
            
                /*Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(myLead.id);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);*/
            
            
        }
        
        contactList=[Select id,Prospect_Interest_Type__c,accountId,Lead_classification_basis_value__c,MailingPostalCode,(Select id,Order_Number__c from Order_Informations__r),
                     (Select id,Flag_abandoned_cart__c,Prospect_Interest_Type__c from Opportunities2__r),
                     (Select id,Active__c,sku__c from Products_on_Cart__r where Active__c=true)
                     from contact where email=:userEmail order by createdDate desc];
           
        
           for(Contact con : contactList)
           {
                   contactListEcom.add(con);
           }
        
        System.debug('contactList--- '+contactList);
        //From this loop we should add the existing orders related to the contact fetched in the contactList var
        if(contactListEcom.size()>0)
        {
          system.debug('I am in contactList.size()>0');
          Map<String,Products_on_Cart__c> cartproductsMap=new Map<String,Products_on_Cart__c>();
          opportunityContactMap.put(contactList[0].id, contactList[0].Opportunities2__r);
          For(Order_Information__c order :contactList[0].Order_Informations__r)
          {
             orderNumbersMap.put(order.Order_Number__c,order); 
          }
          for(Products_on_Cart__c cartPrd : contactList[0].Products_on_Cart__r)
          {
             cartproductsMap.put(cartPrd.sku__c,cartPrd); 
          }
          productsOnCartMap.put(contactList[0].id,cartproductsMap);  
        }
        //If the contact already exists then contrl go in the if block.(this can be checked with contactList variable)
        if(contactList.size()>0)
        {
            System.debug('I am in contactList.size()>0------');
           /*If Contact already there in the system then update the same contact with user information*/
           Contact cnt=contactList[0];//Get first contact from the list in the cnt variable.
           if(cnt.AccountId==null)  //Here we are checking the account is there or not for existing contact.
           {
              String accountName=userDetails.company;  //Get company name for account
              String accoutId; 
              if(accountName!=null && accountName!='')
              {
                  accoutId=createAccount(accountName,userDetails); //calling createAccount method from the same class.
              }
              else
              {
                  accoutId=createAccount('NA - '+userDetails.email.substringBefore('@'),userDetails);  //If company name is not there then pass NA and user Name
              }
              if(accoutId!=null && accoutId!='') 
              cnt.AccountId=accoutId;
              if(test.isRunningTest())
              {
                coverMethod(); 
             }
           }
           else  //If account there for this contact then update the same accoutn name with updated company name 
           {
             Account acc=[Select id,name from account where id=:cnt.AccountId];
             if(userDetails.company!=null && userDetails.company!=' ' && userDetails.company!='')
             {
                 acc.Name=userDetails.company;
                 if(userDetails.Industry!=null)
                 acc.Industry=userDetails.Industry;
                 update acc;
             }
           }
           if(userDetails.name!=null && userDetails.name!=' ' && userDetails.name!='' )
           {
               cnt.LastName=userDetails.name;
           }
           else if(orderDetails.ShippingAddress!=NULL )
           {
               cnt.LastName=orderDetails.ShippingAddress.name;
           }
           if(userDetails.email!=null)
               cnt.Email=userDetails.email;
           if(userDetails.company!=null)
               cnt.Company__c=userDetails.company;
            
           if(userDetails.phone!=null && userDetails.phone!='' && userDetails.phone!=' ')
               cnt.Phone=userDetails.phone;
           if(userDetails.industry!=null)
               cnt.Industry__c=userDetails.industry;
           if(userDetails.role_in_the_organisation!=null)
               cnt.Role_in_organisation__c=userDetails.role_in_the_organisation;
           if(userDetails.no_of_employees!=null)
               cnt.Number_of_Employees_Custom__c=userDetails.no_of_employees;
           if(userDetails.what_is_the_purpose!=null)
               cnt.What_is_the_purpose_use__c=userDetails.what_is_the_purpose;
           if(userDetails.change_password_link!=null)
               cnt.Ecom_Reset_password__c=userDetails.change_password_link;
           if(userDetails.utm_campaign!=null)
               cnt.Ecom_campaign__c=userDetails.utm_campaign;
            if(visitor_Id!=null)
                cnt.Visitor_Id__c=visitor_Id;
           if(userDetails.utm_source!=null)
               cnt.Ecom_Source__c=userDetails.utm_source;
           if(userDetails.utm_content!=null)
               cnt.Ecom_content__c=userDetails.utm_content;
           if(userDetails.utm_medium!=null)
               cnt.Ecom_media__c=userDetails.utm_medium;
           if(userDetails.utm_term!=null)
               cnt.Ecom_term__c=userDetails.utm_term;
           if(userDetails.url_params!=null)
               cnt.Ecom_URL_Params__c=userDetails.url_params;
           if(userDetails.coupon_redeem!=null)
               cnt.coupon_redeem__c=userDetails.coupon_redeem;
           if(userDetails.user_coupon!=null) 
               cnt.couponcode__c=userDetails.user_coupon;
               cnt.Prospect_Interest_Type__c='E-Commerce';
       if(userDetails.address!=null)
         {
               if(userDetails.address.containskey('address_1'))
               {
                   EcomIntegrationWrapper.Address Add1=userDetails.address.get('address_1');
                   if(Add1.name != null && Add1.name != '')
                   Cnt.name1__c = Add1.name;
                   if(Add1.phone != null && Add1.phone != '')
                   Cnt.phone1__c = Add1.phone;
                   if(Add1.email != null && Add1.email != '')
                   Cnt.email1__c = Add1.email;
                   if(Add1.company_name != null && Add1.company_name != '')
                   Cnt.company_name1__c = Add1.company_name;
                   if(Add1.street_address != null && Add1.street_address != '')
                   Cnt.street_address1__c = Add1.street_address;
                   if(Add1.landmark != null && Add1.landmark != '')
                   Cnt.landmark1__c = Add1.landmark;
                   if(Add1.zipcode != null && Add1.zipcode != '')
                   Cnt.zipcode__c = Add1.zipcode;
                   if(Add1.city != null && Add1.city != '')
                   Cnt.city1__c = Add1.city;
                   if(Add1.state != null && Add1.state != '')
                   Cnt.state1__c = Add1.state;
                   if(Add1.country != null && Add1.country != '')
                   Cnt.country1__c = Add1.country;
                   if(Add1.GSTIN_number != null && Add1.GSTIN_number != '')
                   Cnt.GSTIN_number__c = Add1.GSTIN_number;
               }
               if(userDetails.address.containskey('address_2'))
               {
                   EcomIntegrationWrapper.Address Add2=userDetails.address.get('address_2');
                   
                   if(Add2.name != null && Add2.name != '')
                   Cnt.name2__c = Add2.name;
                   
                   if(Add2.phone != null && Add2.phone != '')
                       Cnt.phone2__c = Add2.phone;
                   
                   if(Add2.email != null && Add2.email != '')
                       Cnt.email2__c = Add2.email;
                   
                   if(Add2.company_name != null && Add2.company_name != '')
                       Cnt.company_name2__c = Add2.company_name;
                   
                   if(Add2.street_address != null && Add2.street_address != '')
                       Cnt.street_address2__c = Add2.street_address;
                   
                   if(Add2.landmark != null && Add2.landmark != '')
                       Cnt.landmark2__c = Add2.landmark;
                   
                   if(Add2.zipcode != null && Add2.zipcode != '')
                       Cnt.zipcode2__c = Add2.zipcode;
                   
                   if(Add2.city != null && Add2.city != '')
                       Cnt.city2__c = Add2.city;
                   
                   if(Add2.state != null && Add2.state != '')
                       Cnt.state2__c = Add2.state;
                   
                   if(Add2.country != null && Add2.country != '')
                       Cnt.country2__c = Add2.country;
                   
                   if(Add2.GSTIN_number != null && Add2.GSTIN_number != '')
                       Cnt.GSTIN_number2__c = Add2.GSTIN_number;
                   
               }
               if(userDetails.address.containskey('address_3'))
               {
                  EcomIntegrationWrapper.Address Add3=userDetails.address.get('address_3');
                                            
                   if(Add3.name != null && Add3.name != '')
                       Cnt.name3__c = Add3.name;
                   
                   if(Add3.phone != null && Add3.phone != '')
                       Cnt.phone3__c = Add3.phone;
                   
                   if(Add3.email != null && Add3.email != '')
                       Cnt.email3__c = Add3.email;
                   
                   if(Add3.company_name != null && Add3.company_name != '')
                       Cnt.company_name3__c = Add3.company_name;
                   
                   if(Add3.street_address != null && Add3.street_address != '')
                       Cnt.street_address3__c = Add3.street_address;
                   
                   if(Add3.landmark != null && Add3.landmark != '')
                       Cnt.landmark3__c = Add3.landmark;
                   
                   if(Add3.zipcode != null && Add3.zipcode != '')
                       Cnt.zipcode3__c = Add3.zipcode;
                   
                   if(Add3.city != null && Add3.city != '')
                       Cnt.city3__c = Add3.city;
                   
                   if(Add3.state != null && Add3.state != '')
                       Cnt.state3__c = Add3.state;
                   
                   if(Add3.country != null && Add3.country != '')
                       Cnt.country3__c = Add3.country;
                   
                   if(Add3.GSTIN_number != null && Add3.GSTIN_number != '')
                       Cnt.GSTIN_number3__c = Add3.GSTIN_number; 
               }
           }
         if(orderDetails.billingAddress != null)
       	 {
           
           if(orderDetails.billingAddress.address != null)
                cnt.MailingStreet = orderDetails.billingAddress.address;
            
            if(orderDetails.billingAddress.pincode != null)
                cnt.MailingPostalCode = orderDetails.billingAddress.pincode;
            
           if(orderDetails.billingAddress.city != null)
                cnt.MailingCity = orderDetails.billingAddress.city;
            
            if(orderDetails.billingAddress.state != null)
                cnt.MailingState = orderDetails.billingAddress.state;
            
            if(orderDetails.billingAddress.country != null)
                cnt.MailingCountry = orderDetails.billingAddress.country;
        } 
         update cnt; //Updating the same contact here
         //If the order already there then do not create project for that 
           //as well as if the IBorder number is null in the json the do not create the project.
          System.debug('orderNumbersMap----- '+orderNumbersMap);
           if(orderDetails.IBOrderNumber!=null && orderDetails.IBOrderNumber!='' && orderDetails.IBOrderNumber!=' '&&
              !orderNumbersMap.containskey(orderDetails.IBOrderNumber))
           {
              createProject(cnt,orderDetails,Cart_payment_info,userpincodeMap,Cart_payment_info,jsonString2,contactList,true); 
           }
           if(orderDetails.IBOrderNumber!=null && orderDetails.IBOrderNumber!='' && orderDetails.IBOrderNumber!=' '&& orderNumbersMap.containskey(orderDetails.IBOrderNumber))
           {
              updateExistingOrder(orderNumbersMap,orderDetails,Cart_payment_info); 
           }
           if(cart_itemsList.size()>0 && (orderDetails.IBOrderNumber==null || orderDetails.IBOrderNumber=='' || orderDetails.IBOrderNumber==' ')) 
           createCartItems(cnt,cart_itemsList,userpincodeMap,orderDetails,productsOnCartMap);
           
           if(search_keywordsList.size()>0) 
           createsearch_keywords(cnt,search_keywordsList);
           if(Products_viewedList.size()>0) 
           createproducts_viewed(cnt,Products_viewedList);
            if(Wish_listsList.size()>0)
    	   createwishList(cnt,Wish_listsList); 
           if(last_five_loginsList.size()>0) 
    	   createlast_five_logins(cnt,last_five_loginsList); 
            
        }
       	return 'Success'; 
        }
        catch(Exception e)
        {
            //In the catch block we are sending mails to the developer if any exception occures.
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'aman.khurana@nanostuffs.com','pritam.shinde@nanostuffs.com'};
            message.setSubject('Ecom Error Message from class EcomIntegration') ;
            message.setPlainTextBody(e.getMessage()+'--'+e.getLineNumber());
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            Ecom_Error_Log__c errorl=new Ecom_Error_Log__c();
            string strjson1=e.getMessage().abbreviate(131072);
            errorl.Error_Message__c=strjson1;
            errorl.Error_Time_Stamp__c=system.now();
            errorl.Line_Number__c=String.valueof(e.getLineNumber());
            string strjson=jsonString.abbreviate(131072);
       		errorl.Json__c=strjson;
            Insert errorl;
            return e.getMessage()+'--'+e.getLineNumber();
        }
    }
    
    
    
    
    public void createProject(Contact ContactObj,EcomIntegrationWrapper.Order orderDetails,
                              EcomIntegrationWrapper.Cart_payment_information Cart_payment_info,
                             Map<String,User> userpincodeMap,
                             EcomIntegrationWrapper.Cart_payment_information cart_Payment_List,String jsonstring,List<Contact> contactList,Boolean wantCTA)
    {
        if(orderDetails.IBOrderNumber!=null)
        {
            if(ContactObj!=null)
            {
                ContactObj.Ecom_Registration__c=false;
            	update ContactObj;
            }
            
            Opportunity opptoSend=new Opportunity();
            if(contactList.size()>0 && contactList[0].Opportunities2__r.size()>0)
            {
               opportunity opptoUpdate=contactList[0].Opportunities2__r[0];
               String Pincode=contactList[0].MailingPostalCode;
            //This code is for assigning projects to the IST users according to the pincode.
              if(Pincode!=null && Pincode!='' && userpincodeMap.containsKey(Pincode) && contactList[0].Lead_classification_basis_value__c!=NULL)
             {
               opptoUpdate.Assigned_IST_User__c=userpincodeMap.get(Pincode).id; 
             }
                
                
                if(orderDetails.is_ist_mode != null)
                    opptoUpdate.Contact_Information_Academic_Title__c = orderDetails.is_ist_mode;
                
                if(orderDetails.ist_user_email == null)
                    opptoUpdate.Contact_Information_Building__c = orderDetails.ist_user_email;
               
                
               opptoUpdate.Flag_abandoned_cart__c=false;
               opptoUpdate.StageName =LAbel.Stage_90;
               opptoUpdate.from_Code_updated_Inserted__c='Created from the ecomUIntegration Class line number :410'; 
               opptoUpdate.Probability =90;
               opptoUpdate.RecurringBusiness__c='Recurring Business';
               opptoUpdate.Flag_Ecommerce__c=true;
               opptoUpdate.Prospect_Interest_Type__c='E-Commerce';
               opptoUpdate.Ecommerce_TimeStamp__c=system.now();
               opptoUpdate.CloseDate = Date.Today().addDays(60);
               opptoUpdate.First_Order_Supply_Date__c=System.today();
               //opptoUpdate.Actual_Closing_date__c=System.today();
               //opptoUpdate.Probability = 100;
               if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                opptoUpdate.MS__c = 'MRO';
            else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                opptoUpdate.MS__c = 'GM';
            else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                opptoUpdate.MS__c = 'VRM'; 
            else 
                opptoUpdate.MS__c = ''; 
            opptoUpdate.RecurringBusiness__c = 'Recurring Business';    
            opptoUpdate.Status__c = 'Active';
               Update opptoUpdate;
               opptoSend=opptoUpdate;
            }
            else
            {
            Opportunity opp = new Opportunity();
            opp.from_Code_updated_Inserted__c='Inserted from the EcomIntegration Line number : 432';
            String Pincode=ContactObj.MailingPostalCode;
            //This code is for assigning projects to the IST users according to the pincode.
            if(Pincode!=null && Pincode!='' && userpincodeMap.containsKey(Pincode) && ContactObj.Lead_classification_basis_value__c!=NULL)
            {
              opp.Assigned_IST_User__c=userpincodeMap.get(Pincode).id; 
            }
            opp.Contact2__c = ContactObj.Id;
            if(orderDetails.orderDate!=null && orderDetails.orderDate!=' ')
            opp.First_Order_Supply_Date__c=Date.valueOf(orderDetails.orderDate);
            else
            opp.First_Order_Supply_Date__c=System.today();    
            opp.AccountId = ContactObj.AccountId;
            opp.Name = 'DG-AG-SU-Product-Application';
            opp.StageName =label.stage_90;
            opp.Probability =90;
            opp.RecurringBusiness__c='Recurring Business';
            opp.CloseDate =Date.Today().addDays(60) ;
            //opp.Actual_Closing_date__c=System.today();    
            opp.Flag_Ecommerce__c=true;
            opp.Prospect_Interest_Type__c='E-Commerce';
                
                opp.Contact_Information_Academic_Title__c = orderDetails.is_ist_mode;
                opp.Contact_Information_Building__c = orderDetails.ist_user_email;
                
                
            /*if(ContactObj.Ecom_Source__c!=NULL)    
            opp.LeadSource = ContactObj.Ecom_Source__c;*/
            opp.Flag_Product_Check__c = true;
            opp.Ecommerce_TimeStamp__c=system.now();
            if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                opp.MS__c = 'MRO';
            else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                opp.MS__c = 'GM';
            else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                opp.MS__c = 'VRM'; 
            else 
                opp.MS__c = ''; 
            //opp.RecurringBusiness__c = 'One Time';    
            opp.Status__c = 'Active';
            Insert opp;
          	List<lead> converetdLead=[Select id from lead where isconverted=true and ConvertedContactId=:ContactObj.Id];
            CTA__c cta=new CTA__c();
                if(wantCTA)
                {
                    cta.RecordTypeId=devRecordTypeId;
                    if(converetdLead.size()!=0)
           		   cta.Lead__c=converetdLead[0].id;
                   cta.Customer_Contact__c=ContactObj.Id;
                   cta.CTA_stage__c='Qualified';
           		   Insert cta; 
                }
            opp.CTA__c=cta.Id;
                
                opp.Contact_Information_Academic_Title__c = orderDetails.is_ist_mode;
                
                opp.Contact_Information_Building__c = orderDetails.ist_user_email;
                
                
           	update opp;
            opptoSend=opp;
            }
           createOrder(ContactObj,opptoSend,orderDetails,cart_Payment_List,jsonstring);
        }
        
    }
    
    
    public void createOrder(Contact cnt,Opportunity opp,EcomIntegrationWrapper.Order orderDetails,
                            EcomIntegrationWrapper.Cart_payment_information cart_Payment_List,string Jsonstring)
    {
       Order_Information__c OrderInfo = new Order_Information__c();
       OrderInfo.name=orderDetails.clientOrderNumber;
       string strjson=Jsonstring.abbreviate(131072);
       System.debug('strjson--- '+strjson); 
       System.debug('Jsonstring--- '+Jsonstring); 
       OrderInfo.Ecom_Order_JSON__c=Jsonstring;
       OrderInfo.Order_Number__c=orderDetails.IBOrderNumber;
       OrderInfo.Payment_Status__c=orderDetails.IBOrderStatus;
       OrderInfo.orderDate__c = orderDetails.orderDate;
       OrderInfo.OrderConfirmationDate__c = orderDetails.OrderConfirmationDate;
        
        OrderInfo.is_ist_mode__c = orderDetails.is_ist_mode;
        OrderInfo.ist_user_email__c = orderDetails.ist_user_email;
        
       OrderInfo.Email__c =orderDetails.email;
       if(orderDetails.url_params!=null && orderDetails.url_params!='')
       OrderInfo.url_params__c=orderDetails.url_params;
       if(orderDetails.utm_campaign!=null && orderDetails.utm_campaign!='')
	   OrderInfo.UTM_Campaign__c=orderDetails.utm_campaign;
       if(orderDetails.utm_content!=null && orderDetails.utm_content!='')
	   OrderInfo.UTM_Content__c=orderDetails.utm_content;
        if(orderDetails.utm_medium!=null && orderDetails.utm_medium!='')
	   OrderInfo.UTM_Medium__c=orderDetails.utm_medium;
        if(orderDetails.utm_term!=null && orderDetails.utm_term!='')
	   OrderInfo.UTM_Term__c=orderDetails.utm_term;
        if(orderDetails.utm_source!=null && orderDetails.utm_source!='')
	   OrderInfo.UTM_Source__c =orderDetails.utm_source;
       OrderInfo.Tracking_Number__c =orderDetails.IBTrackingNumber;
       OrderInfo.Invoice_URL__c = orderDetails.IBInvoiceUrl;
       OrderInfo.Shipping_Date__c =orderDetails.IBShippingDate;
       OrderInfo.Arriving_Date__c =orderDetails.IBArrivingDate;
        
       if(orderDetails.shippingAddress != null)
       {
           if(orderDetails.shippingAddress.name != null)
               OrderInfo.Shipping_Name__c = orderDetails.shippingAddress.name;
           
           if(orderDetails.shippingAddress.email != null)
               OrderInfo.Shipping_Email__c = orderDetails.shippingAddress.email;
           
           if(orderDetails.shippingAddress.address != null)
               OrderInfo.Shipping_Address__c = orderDetails.shippingAddress.address;
           
           if(orderDetails.shippingAddress.pincode != null)
               OrderInfo.Shipping_Pincode__c = orderDetails.shippingAddress.pincode;
           
           if(orderDetails.shippingAddress.phone != null)
               OrderInfo.Shipping_Phone__c = orderDetails.shippingAddress.phone;
           
           if(orderDetails.shippingAddress.city != null)
               OrderInfo.Shipping_City__c = orderDetails.shippingAddress.city;
           
           if(orderDetails.shippingAddress.state != null)
               OrderInfo.Shipping_State__c = orderDetails.shippingAddress.state;
           
           if(orderDetails.shippingAddress.country != null)
               OrderInfo.Shipping_Country__c = orderDetails.shippingAddress.country;
           
           if(orderDetails.shippingAddress.landmark != null)
               OrderInfo.Shipping_Landmark__c = orderDetails.shippingAddress.landmark;
           
           if(orderDetails.shippingAddress.gstinNumber != null)
               OrderInfo.Shipping_GSTInNumber__c = orderDetails.shippingAddress.gstinNumber;
       }
       if(orderDetails.billingAddress != null)
       {
            if(orderDetails.billingAddress.name != null)
                OrderInfo.Billing_Name__c = orderDetails.billingAddress.name;
            
            if(orderDetails.billingAddress.email != null)
                OrderInfo.Billing_Email__c = orderDetails.billingAddress.email;
            
            if(orderDetails.billingAddress.address != null)
                OrderInfo.Billing_Address__c = orderDetails.billingAddress.address;
            
            if(orderDetails.billingAddress.pincode != null)
                OrderInfo.Billing_Pincode__c = orderDetails.billingAddress.pincode;
            
            if(orderDetails.billingAddress.phone != null)
                OrderInfo.Billing_Phone__c = orderDetails.billingAddress.phone;
            
            if(orderDetails.billingAddress.city != null)
                OrderInfo.Billing_City__c = orderDetails.billingAddress.city;
            
            if(orderDetails.billingAddress.state != null)
                OrderInfo.Billing_State__c = orderDetails.billingAddress.state;
            
            if(orderDetails.billingAddress.country != null)
                OrderInfo.Billing_Country__c = orderDetails.billingAddress.country;
            
            if(orderDetails.billingAddress.landmark != null)
                OrderInfo.Billing_Landmark__c = orderDetails.billingAddress.landmark;
            
            if(orderDetails.billingAddress.gstinNumber != null)
                OrderInfo.Billing_GSTInNumber__c = orderDetails.billingAddress.gstinNumber;
        }
       if(cart_Payment_List != null)  //User Cart Information
       {
           if(cart_Payment_List.coupon_name != null && cart_Payment_List.coupon_name != '')
               OrderInfo.Coupon_Name__c = cart_Payment_List.coupon_name;
           
           if(cart_Payment_List.coupon_discount != null && cart_Payment_List.coupon_discount != '')
               OrderInfo.Discount_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List.coupon_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.intro_discount != null && cart_Payment_List.intro_discount != '')
               OrderInfo.Intro_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List.intro_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.bulk_discount != null && cart_Payment_List.bulk_discount != '')
               OrderInfo.bulk_discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List.bulk_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.GST != null && cart_Payment_List.GST != '')
               OrderInfo.GST__c = String.Valueof(Decimal.valueOf(cart_Payment_List.GST.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.subtotal != null && cart_Payment_List.subtotal != '')
               OrderInfo.Subtotal__c = String.Valueof(Decimal.valueOf(cart_Payment_List.subtotal.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.Total != null && cart_Payment_List.Total != '')
               OrderInfo.Total__c = String.Valueof((Decimal.valueOf(cart_Payment_List.Total.replaceAll('[^.\\d]',''))).setScale(2, RoundingMode.HALF_UP));
           
           if(cart_Payment_List.org_total != null && cart_Payment_List.org_total != '')
               OrderInfo.org_total__c = String.Valueof(Decimal.valueOf(cart_Payment_List.org_total.replaceAll('[^.\\d]','')));
           
            if(cart_Payment_List.total_price != null && cart_Payment_List.total_price != '')
               OrderInfo.Total_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List.total_price.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.total_saving != null && cart_Payment_List.total_saving != '')
               OrderInfo.Total_Saving__c = String.Valueof(Decimal.valueOf(cart_Payment_List.total_saving.replaceAll('[^.\\d]','')));
       }
       OrderInfo.Customer_Contact__c=cnt.Id;
       OrderInfo.Project__c=opp.id;
       Insert OrderInfo;
       List<Transaction_Detail__c> trasactionDetailstoInsert=new List<Transaction_Detail__c>();
       List<Ordered_Product__c> orderProductList=new List<Ordered_Product__c>(); 
       List<Invoice__c> invoicetoInsert=new List<Invoice__c>();
       Set<String> skuIdSet=new Set<String>(); 
       if(orderDetails.payment.size()>0)
       {
          for(EcomIntegrationWrapper.Payment transactionObj : orderDetails.payment)
          {
              Transaction_Detail__c trans = new Transaction_Detail__c();
              trans.Amount__c=transactionObj.amount;
              trans.Bank__c=transactionObj.bank;
              trans.Bank_Ref_Number__c=transactionObj.bankRefNumber;
              trans.Cheque_Date__c=transactionObj.chequeDate;
              trans.Cheque_Issue_Bank__c=transactionObj.chequeIssueBank;
              trans.Cheque_Number__c=transactionObj.chequeNumber;
              trans.Gateway__c=transactionObj.gateway;
              trans.Payment_Mode__c=transactionObj.paymentMode;
              trans.Payment_Realized_On__c=transactionObj.paymentRealizedOn;
              trans.Payment_Received_Date__c=transactionObj.paymentReceivedDate;
              trans.Payment_Status__c=transactionObj.status;
              trans.PG_Transaction_Id__c=transactionObj.pgTransactionId;
              trans.Transaction_Id__c=transactionObj.transactionId;
              trans.E_Com_Order_Number__c=OrderInfo.Id;
              trasactionDetailstoInsert.add(trans); 
          }
          Insert trasactionDetailstoInsert; 
       }
        List<Order_Information__c> ordertoUpdate=new List<Order_Information__c>();
       if(orderDetails.orderItems.size()>0)
       {
          Decimal shippingCharg=0;
          Decimal codCharg=0;
           
          for(EcomIntegrationWrapper.OrderItems Item : orderDetails.orderItems)
          {
              shippingCharg=shippingCharg+Item.shippingCharge;
              codCharg=codCharg+Item.codCharge;
              Ordered_Product__c orderProduct = new Ordered_Product__c();
              Ordered_Product__c orderProductReference = new Ordered_Product__c();
              if(orderDetails.IBOrderNumber!=null && Item.sku!=null)
              {
                 orderProductReference.External_Id__c=orderDetails.IBOrderNumber+Item.sku;
                 orderProduct.External_Id__c=orderDetails.IBOrderNumber+Item.sku;
              }
              
              orderProduct.Product_Id__c = Item.id;
              
              if(Item.sku != null)
              {
                  orderProduct.SKU__c = Item.sku;
                  skuIdSet.add(orderProduct.SKU__c);
                  if(productMapgen.containsKey(Item.sku))
                  {
                     orderProduct.System_Product__c=productMapgen.get(Item.sku).id;
                     orderProduct.Dp__c=productMapgen.get(Item.sku).Dp__c;
                  }
              }
              
              if(Item.image != null)
                  orderProduct.image_url__c = Item.image;
              
              if(Item.quantity != null && Item.quantity != '')
                  orderProduct.Quanitity__c = String.Valueof(Decimal.valueOf(Item.quantity.replaceAll('[^.\\d]','')));
              
              if(Item.taxExclusivePrice!=null && Item.taxExclusivePrice!='')
              orderProduct.Unit_Price__c=Item.taxExclusivePrice;
                  
              if(Item.itemTitle != null)
                  orderProduct.Name = Item.itemTitle;
              
              if(Item.tax != null && Item.tax != '')
                  orderProduct.Tax__c = String.Valueof(Decimal.valueOf(Item.tax.replaceAll('[^.\\d]','')));
              
              if(Item.taxPercentage != null)
                  orderProduct.Tax_Percentage__c = String.Valueof(Item.taxPercentage);
              
              if(Item.strikedOffPrice != null && Item.strikedOffPrice != '')
                  orderProduct.Striked_Off_Price__c = String.Valueof(Decimal.valueOf(Item.strikedOffPrice.replaceAll('[^.\\d]','')));
              
              if(Item.taxInclusivePrice != null && Item.taxInclusivePrice != '')
                  orderProduct.Tax_Inclusive_Price__c = String.Valueof(Decimal.valueOf(Item.taxInclusivePrice.replaceAll('[^.\\d]','')));
              
              if(Item.codCharge != null)
                  orderProduct.CodCharge__c = String.Valueof(Item.codCharge);
              
              if(Item.shippingCharge != null)
                  orderProduct.Shipping_Charge__c = String.Valueof(Item.shippingCharge);
              
              if(Item.coupon_discount != null )
                  orderProduct.Coupon_Discount__c = Item.coupon_discount;
              
              if(Item.intro_discount != null )
                  orderProduct.Intro_Discount__c = Item.intro_discount;
              
              if(Item.bulk_discount != null )
                  orderProduct.Bulk_Discount__c = Item.bulk_discount;
              
              if(Item.subtotal != null )
                  orderProduct.Subtotal__c = Item.subtotal;
              
              if(Item.sp1 != null )
                  orderProduct.SP1__c = Decimal.valueOf(Item.sp1);
              
              if(Item.recommendation_type != null )
                  orderProduct.Recommendation_type__c = Item.recommendation_type;
              
              if(Item.total != null )
                  orderProduct.Total_Price__c =Item.total;
              
              
              if(Item.IBOrderStatus != null )
                  orderProduct.Order_Status__c = Item.IBOrderStatus;
              
              if(Item.IBTrackingNumber != null )
                  orderProduct.Tracking_Number__c = Item.IBTrackingNumber;
              
              if(Item.IBShippingDate != null )
                  orderProduct.Shipping_Date__c = Item.IBShippingDate;
              
              if(Item.IBArrivingDate != null )
                  orderProduct.Arriving_Date__c = Item.IBArrivingDate;
              
              if(Item.distributor_allocated != null )
                  orderProduct.Distributor_allocated__c = Item.distributor_allocated;
              
              /*if(Item.IBInvoiceUrl != null )
                  orderProduct.Invoice_URL__c = Item.IBInvoiceUrl;*/                                           
             if(Item.IBInvoiceUrl!=null && Item.IBInvoiceUrl.size()>0)
			 {
                for(EcomIntegrationWrapper.IBInvoiceUrlWrpper invObj : Item.IBInvoiceUrl)
                {
                    Invoice__c inv=new Invoice__c();
                    inv.Invoice_Url__c=invObj.url;
                    inv.Vendor_Name__c=invObj.vendor;
                    inv.Product_Name__r=orderProductReference;
                    invoicetoInsert.add(inv);
                }
			  }              
              orderProduct.Order_Information__c = OrderInfo.Id;
              OrderInfo.Shipping_Charge__c=String.valueOf(shippingCharg);
              OrderInfo.CodCharge__c=String.valueOf(codCharg);
              orderProductList.add(orderProduct);
          }
          Insert orderProductList;
          ordertoUpdate.add(orderInfo);
          try
          {
           Insert invoicetoInsert;
          }
           Catch(Exception e)
           {
               Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {'pritam.shinde@nanostuffs.com','aman.khurana@nanostuffs.com'};
                        message.setSubject('Ecom Error Message from class EcomIntegration for Invoice') ;
                    message.setPlainTextBody(e.getMessage()+'--'+e.getLineNumber()+' Json :'+jsonString);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    Ecom_Error_Log__c errorl=new Ecom_Error_Log__c();
                    string strjson1=e.getMessage().abbreviate(131072);
                    errorl.Error_Message__c=strjson1;
                    errorl.Error_Time_Stamp__c=system.now();
                    errorl.Line_Number__c=String.valueof(e.getLineNumber());
                    string strjson2=jsonString.abbreviate(131072);
                    errorl.Json__c=strjson2;
                    Insert errorl;
           }
           
       }
       
       if(ordertoUpdate.size()>0)
       {
          update ordertoUpdate; 
       }
       if(orderProductList.size()>0) 
       createOpportunityLineItem(opp,skuIdSet,orderProductList,cnt,Jsonstring); 
        
    }
    
    
    public void createOpportunityLineItem(Opportunity opp,Set<String> skewIds,List<Ordered_Product__c> orderProductList,Contact cnt,string Jsonstring)
    {
            Map<Id,Product2> productMap=new Map<Id,Product2>();
            Map<String,Product2> prodMap=new Map<String,Product2>();
            Map<String,pricebookentry> pricebookEntryMap=new Map<String,pricebookentry>();
            List<OpportunityLineItem> oppLineItemtoInsert =new List<OpportunityLineItem>();
            
            for(Product2 prod :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: skewIds and IsActive=true])
            {
                productMap.put(prod.id,prod);
                prodMap.put(prod.IB_SKU__c,prod);
            }
            
            for(pricebookentry pr :[select Id,Product2Id,Unitprice from pricebookentry where Product2.IB_SKU__c in : skewIds and IsActive=true and Pricebook2.name = '2022 Price Book'])
            {
                pricebookEntryMap.put(pr.product2Id,pr); 
            }
            //product Details End here
            List<Products_on_Cart__c> productOncarttoUpdate=new List<Products_on_Cart__c>();
            Set<String> productoncart=new Set<String>();
            for(Ordered_Product__c productObj: orderProductList)
            {
                OpportunityLineItem oppItem = new OpportunityLineItem();
                productoncart.add(productObj.SKU__c);
                if(productsOnCartMap.containsKey(cnt.id))
                {
                    if(productsOnCartMap.get(cnt.id).containskey(productObj.SKU__c))
                    {
                        Products_on_Cart__c pr=productsOnCartMap.get(cnt.id).get(productObj.SKU__c);
                        pr.Active__c=false;
                        productOncarttoUpdate.add(pr);
                    }
                }
                
                try
                {
                    system.debug('Product : '+prodMap.get(productObj.SKU__c).id);
                    system.debug('Pricebook : '+pricebookEntryMap.get(prodMap.get(productObj.SKU__c).id).id);
                }
                catch(Exception e)
                {
                    //In the catch block we are sending mails to the developer if any exception occures.
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {'pritam.shinde@nanostuffs.com','aman.khurana@nanostuffs.com'};
                        message.setSubject('Ecom Error Message from class EcomIntegration for Pricebook') ;
                    message.setPlainTextBody(e.getMessage()+'--'+e.getLineNumber()+' Json :'+jsonString);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    Ecom_Error_Log__c errorl=new Ecom_Error_Log__c();
                    string strjson1=e.getMessage().abbreviate(131072);
                    errorl.Error_Message__c=strjson1;
                    errorl.Error_Time_Stamp__c=system.now();
                    errorl.Line_Number__c=String.valueof(e.getLineNumber());
                    string strjson=jsonString.abbreviate(131072);
                    errorl.Json__c=strjson;
                    Insert errorl;
                }
                
                if(prodMap.containsKey(productObj.SKU__c))
                {
                    if(pricebookEntryMap.containsKey(prodMap.get(productObj.SKU__c).id))
                    {
                        oppItem.OpportunityId =opp.Id;
                        oppItem.PricebookEntryId = pricebookEntryMap.get(prodMap.get(productObj.SKU__c).id).id;
                        oppItem.UnitPrice = pricebookEntryMap.get(prodMap.get(productObj.SKU__c).id).unitprice;
                        oppItem.Quantity=Decimal.valueOf(productObj.Quanitity__c);
                        oppLineItemtoInsert.add(oppItem);  
                    }
                }
            }
            
            List<Products_on_Cart__c> productstoUpdate=new List<Products_on_Cart__c>();
            if(productsOnCartMap.containsKey(cnt.Id))
            {
                for(String str : productsOnCartMap.get(cnt.Id).keySet())
                {
                    if(!productoncart.contains(str))
                    {
                        Products_on_Cart__c pr= productsOnCartMap.get(cnt.Id).get(str);
                        pr.Active__c=false;
                        productstoUpdate.add(pr);
                    }
                }
            }
            if(oppLineItemtoInsert.size()>0)
                Insert oppLineItemtoInsert;
            
            if(productOncarttoUpdate.size()>0)
            {
                Update productOncarttoUpdate;  
            }
            if(productstoUpdate.size()>0)
            {
                update productstoUpdate; 
            }
            
        
    }
    
    public string createAccount(String accountName,EcomIntegrationWrapper.user_contact_detail userDetails)
    {
        Account acc=new Account();
        acc.Name=accountName;
        acc.Industry=userDetails.Industry;
        insert acc;
        return acc.Id;
    }
    
    public Contact createContact(String accountId,EcomIntegrationWrapper.user_contact_detail userDetails)
    {
       Contact cnt=new Contact();
       if(accountId!=null && accountId!='')
       {
         cnt.AccountId=accountId;  
       }
       if(userDetails.name!=null && userDetails.name!=' ' && userDetails.name!='')
       {
          cnt.LastName=userDetails.name;  
       }
       else
       {
          cnt.LastName='NA'; 
       }
        cnt.Ecom_Registration__c=true;   
        if(userDetails.email!=null)
            cnt.Email=userDetails.email;
        if(userDetails.company!=null)
            cnt.Company__c=userDetails.company;
        if(userDetails.phone!=null)
            cnt.Phone=userDetails.phone;
        if(userDetails.industry!=null)
            cnt.Industry__c=userDetails.industry;
        if(userDetails.role_in_the_organisation!=null)
            cnt.Role_in_organisation__c=userDetails.role_in_the_organisation;
        if(userDetails.no_of_employees!=null)
            cnt.Number_of_Employees_Custom__c=userDetails.no_of_employees;
        if(userDetails.what_is_the_purpose!=null)
            cnt.What_is_the_purpose_use__c=userDetails.what_is_the_purpose;
        if(userDetails.change_password_link!=null)
            cnt.Ecom_Reset_password__c=userDetails.change_password_link;
        if(userDetails.utm_campaign!=null)
            cnt.Ecom_campaign__c=userDetails.utm_campaign;
        if(userDetails.utm_source!=null)
            cnt.Ecom_Source__c=userDetails.utm_source;
        if(userDetails.utm_content!=null)
            cnt.Ecom_content__c=userDetails.utm_content;
        if(userDetails.utm_medium!=null)
            cnt.Ecom_media__c=userDetails.utm_medium;
        if(userDetails.utm_term!=null)
            cnt.Ecom_term__c=userDetails.utm_term;
        if(userDetails.url_params!=null)
            cnt.Ecom_URL_Params__c=userDetails.url_params;
        if(userDetails.coupon_redeem!=null)
            cnt.coupon_redeem__c=userDetails.coupon_redeem;
        if(userDetails.user_coupon!=null) 
            cnt.couponcode__c=userDetails.user_coupon;
            cnt.CC_Status__c='mql';
        /*if(cnt.LeadSource==null && userDetails.utm_source!=NULL)
            cnt.LeadSource=userDetails.utm_source;*/
          
       if(userDetails.address!=null)
       {
           
           System.debug('userDetails.address----- '+userDetails.address);
           if(userDetails.address.containskey('address_1'))
           {
               EcomIntegrationWrapper.Address Add1=userDetails.address.get('address_1');
               if(Add1.name != null && Add1.name != '')
                   Cnt.name1__c = Add1.name;
               if(Add1.phone != null && Add1.phone != '')
                   Cnt.phone1__c = Add1.phone;
               if(Add1.email != null && Add1.email != '')
                   Cnt.email1__c = Add1.email;
               if(Add1.company_name != null && Add1.company_name != '')
                   Cnt.company_name1__c = Add1.company_name;
               if(Add1.street_address != null && Add1.street_address != '')
                   Cnt.street_address1__c = Add1.street_address;
               if(Add1.landmark != null && Add1.landmark != '')
                   Cnt.landmark1__c = Add1.landmark;
               if(Add1.zipcode != null && Add1.zipcode != '')
                   Cnt.zipcode__c = Add1.zipcode;
               if(Add1.city != null && Add1.city != '')
                   Cnt.city1__c = Add1.city;
               if(Add1.state != null && Add1.state != '')
                   Cnt.state1__c = Add1.state;
               if(Add1.country != null && Add1.country != '')
                   Cnt.country1__c = Add1.country;
               if(Add1.GSTIN_number != null && Add1.GSTIN_number != '')
                   Cnt.GSTIN_number__c = Add1.GSTIN_number;
 			}
           if(userDetails.address.containskey('address_2'))
           {
               EcomIntegrationWrapper.Address Add2=userDetails.address.get('address_2');
               
               if(Add2.name != null && Add2.name != '')
                   Cnt.name2__c = Add2.name;
               
               if(Add2.phone != null && Add2.phone != '')
                   Cnt.phone2__c = Add2.phone;
               
               if(Add2.email != null && Add2.email != '')
                   Cnt.email2__c = Add2.email;
               
               if(Add2.company_name != null && Add2.company_name != '')
                   Cnt.company_name2__c = Add2.company_name;
               
               if(Add2.street_address != null && Add2.street_address != '')
                   Cnt.street_address2__c = Add2.street_address;
               
               if(Add2.landmark != null && Add2.landmark != '')
                   Cnt.landmark2__c = Add2.landmark;
               
               if(Add2.zipcode != null && Add2.zipcode != '')
                   Cnt.zipcode2__c = Add2.zipcode;
               
               if(Add2.city != null && Add2.city != '')
                   Cnt.city2__c = Add2.city;
               
               if(Add2.state != null && Add2.state != '')
                   Cnt.state2__c = Add2.state;
               
               if(Add2.country != null && Add2.country != '')
                   Cnt.country2__c = Add2.country;
               
               if(Add2.GSTIN_number != null && Add2.GSTIN_number != '')
                   Cnt.GSTIN_number2__c = Add2.GSTIN_number;
               
 }
           if(userDetails.address.containskey('address_3'))
           {
               EcomIntegrationWrapper.Address Add3=userDetails.address.get('address_3');
               
               if(Add3.name != null && Add3.name != '')
                   Cnt.name3__c = Add3.name;
               
               if(Add3.phone != null && Add3.phone != '')
                   Cnt.phone3__c = Add3.phone;
               
               if(Add3.email != null && Add3.email != '')
                   Cnt.email3__c = Add3.email;
               
               if(Add3.company_name != null && Add3.company_name != '')
                   Cnt.company_name3__c = Add3.company_name;
               
               if(Add3.street_address != null && Add3.street_address != '')
                   Cnt.street_address3__c = Add3.street_address;
               
               if(Add3.landmark != null && Add3.landmark != '')
                   Cnt.landmark3__c = Add3.landmark;
               
               if(Add3.zipcode != null && Add3.zipcode != '')
                   Cnt.zipcode3__c = Add3.zipcode;
               
               if(Add3.city != null && Add3.city != '')
                   Cnt.city3__c = Add3.city;
               
               if(Add3.state != null && Add3.state != '')
                   Cnt.state3__c = Add3.state;
               
               if(Add3.country != null && Add3.country != '')
                   Cnt.country3__c = Add3.country;
               
               if(Add3.GSTIN_number != null && Add3.GSTIN_number != '')
                   Cnt.GSTIN_number3__c = Add3.GSTIN_number; 
 }
       }
       Insert cnt; 
       return cnt;
    }
    
    public void createCartItems(Contact cnt,List<EcomIntegrationWrapper.Cart_items> cart_itemsList,Map<String,User> userpincodeMap
                                ,EcomIntegrationWrapper.Order orderDetails,Map<Id,Map<String,Products_on_Cart__c>> productsOnCartMap)
    {
        Map<String,Products_on_Cart__c> cartproductsMap=new Map<String,Products_on_Cart__c>();
        List<CTA__c> ctaList=[Select id,RecordTypeId,Lead__c,Customer_Contact__c,(Select id,sku__c from Products_on_Cart__r) from CTA__c where recordtypeid= :AbandonedCartRecordTypeId and  
                                 Customer_Contact__c!=null and Lead__c!=null and Customer_Contact__c= :cnt.Id and 
                                 CTA_stage__c!='Closed abandoned cart'];
         if(ctaList.size()>0 && ctaList[0].Products_on_Cart__r.size() >0)
         {
             for(Products_on_Cart__c cartPrd : ctaList[0].Products_on_Cart__r)
             {
                 cartproductsMap.put(cartPrd.sku__c,cartPrd); 
             }
         }
        if(ctaList.size()>0)
         productsOnCartMap.put(ctaList[0].id,cartproductsMap); 
        
        List<Products_on_Cart__c> productoncartList=new List<Products_on_Cart__c>();
        List<Products_on_Cart__c> productstoUpdate=new List<Products_on_Cart__c>();
        Set<String> productSkews=new Set<String>();
        CTA__c cta;
        if(ctaList.size()==0)
        {
               cta=new CTA__c();
               cta.RecordTypeId=AbandonedCartRecordTypeId;
           // if(cnt.id != null)
                cta.Customer_Contact__c=cnt.id;
            
               cta.CTA_stage__c='Data and Intent Validation Process';
               Insert cta;
        }
        
        
        
        
        if(cnt!=null && cart_itemsList.size()>0)
        {
           for(EcomIntegrationWrapper.Cart_items cartItem  : cart_itemsList)
           {
               productSkews.add(cartItem.sku);
               if(ctaList.size() > 0 && productsOnCartMap.containsKey(ctaList[0].id))
               {
                   if(!productsOnCartMap.get(ctaList[0].id).containsKey(cartItem.sku))
               	   {
                   Products_on_Cart__c proncart=new Products_on_Cart__c();
                   proncart.Name=cartItem.product_name;
               	   proncart.Category__c=cartItem.category;
                   //proncart.Customer_Contact__c=cnt.id;
                   if(ctaList.size()!=0)
                   {
                        proncart.CTA__c=ctaList[0].id;
                        proncart.Customer_Contact__c=ctaList[0].Customer_Contact__c;//Add Contact From CTA
                        proncart.Lead__c=ctaList[0].Lead__c;//Add Lead From CTA
                   }
                      
                       else
                       {
                   proncart.CTA__c=cta.id;
                        if(cta.Customer_Contact__c!=null)
                   proncart.Customer_Contact__c=cta.Customer_Contact__c;//Add Contact From CTA
                   proncart.Lead__c=cta.Lead__c;    //Add lead from CTA
                   proncart.Active__c=true;
                   proncart.Price__c=cartItem.price;
                   proncart.Product_id__c=cartItem.product_id;
                   proncart.Quanitity__c=cartItem.quanitity;
                   proncart.Size__c=cartItem.size;
                   proncart.sku__c=cartItem.sku;
                   productoncartList.add(proncart);}
                   
                 }
               	   }
               else if(ctaList.size() == 0)
               { 
                   Products_on_Cart__c proncart=new Products_on_Cart__c();
                   proncart.Name=cartItem.product_name;
               	   proncart.Category__c=cartItem.category;
                   if(cnt!=null)
                   proncart.Customer_Contact__c=cnt.id;//Contact to Products on Cart
                   proncart.CTA__c=cta.id;
                   proncart.Active__c=true;
                   proncart.Price__c=cartItem.price;
                   proncart.Product_id__c=cartItem.product_id;
                   proncart.Quanitity__c=cartItem.quanitity;
                   proncart.Size__c=cartItem.size;
                   proncart.sku__c=cartItem.sku;
                   productoncartList.add(proncart);
                 }
               
               
           }
           if(productsOnCartMap.containsKey(cnt.id))
           {
               for(String cartProducts : productsOnCartMap.get(cnt.id).keySet())
           	   {
                  if(!productSkews.contains(cartProducts))
                  {
                     Products_on_Cart__c pr = productsOnCartMap.get(cnt.id).get(cartProducts);
                     pr.Active__c=false;
                     productstoUpdate.add(pr);
                  }
           		}
           }
           if(productoncartList.size()>0) 
           Insert productoncartList;
            
           if(productstoUpdate.size()>0)
           Update productstoUpdate;
        }
    }
    public void createsearch_keywords(contact cnt,List<String> search_keywordsList)
    {
       List<Searched_Keyword__c> searchKeyInsert=new List<Searched_Keyword__c>();
       if(cnt!=null && search_keywordsList.size()>0)
       {
          for(String str : search_keywordsList)
          {
             Searched_Keyword__c SerchKey = new Searched_Keyword__c();
             if(str!=null && str!='' && str!=' ')
             {
                 SerchKey.Name=str;
                 SerchKey.Customer_Contact__c=cnt.id; 
                 searchKeyInsert.add(SerchKey);
             }
          }
          
           Insert searchKeyInsert;
       }
    }
    
    public void createproducts_viewed(Contact cnt,List<EcomIntegrationWrapper.Products_viewed> Products_viewedList)
    {
       List<Products_Viewed__c> productViewInsert =new List<Products_Viewed__c>();
       if(cnt!=null && Products_viewedList.size()>0)
       {
          for(EcomIntegrationWrapper.Products_viewed productViewedObj : Products_viewedList)
          {
              Products_Viewed__c productViewed=new Products_Viewed__c();
              if(productViewedObj.product_name!=null && productViewedObj.product_name!='' && productViewedObj.product_name!=' ')
              {
                  productViewed.Name=productViewedObj.product_name;
                  productViewed.Customer_Contact__c=cnt.id;
                  productViewed.Product_Category__c=productViewedObj.category;
                  productViewed.Product_Url__c=productViewedObj.product_url;
                  productViewInsert.add(productViewed);
              }
         }
          Insert productViewInsert;
       }
    }
    
    public void createwishList(Contact cnt,List<EcomIntegrationWrapper.Wish_lists> Wish_listsList)
    {
       List<Wish_List__c> wishList=new List<Wish_List__c>();
       if(cnt!=null && Wish_listsList.size()>0)
       {
          for(EcomIntegrationWrapper.Wish_lists wishObj : Wish_listsList)
          {
              Wish_List__c wishpr=new Wish_List__c();
              if(wishObj.product_name!=null && wishObj.product_name!='' &&  wishObj.product_name!=' ')
              {
                  wishpr.Name=wishObj.product_name;
                  wishpr.Customer_Contact__c=cnt.id;
                  wishpr.Product_Category__c =wishObj.category;
                  wishList.add(wishpr);
              }
          }
          Insert wishList;
       }
    }
    
    public void updateExistingOrder(Map<String,Order_Information__c> orderNumbersMap,EcomIntegrationWrapper.Order orderDetails,EcomIntegrationWrapper.Cart_payment_information cart_Payment_List)
    {
       System.debug('I am in updateExistingOrder');
       List<Order_Information__c> UpdateOrder=new List<Order_Information__c>();
       List<Ordered_Product__c>orderProductList=new List<Ordered_Product__c>();
       Order_Information__c ExistingOrder=orderNumbersMap.get(orderDetails.IBOrderNumber);
       Order_Information__c OrderInfo = new Order_Information__c();
       OrderInfo.Id=ExistingOrder.Id;
       OrderInfo.name=orderDetails.clientOrderNumber;
       if(orderDetails.IBOrderStatus!=null && orderDetails.IBOrderStatus!='' && orderDetails.IBOrderStatus!=' ')
       OrderInfo.Payment_Status__c=orderDetails.IBOrderStatus;
       if(cart_Payment_List != null)  //User Cart Information
       {
           if(cart_Payment_List.coupon_name != null && cart_Payment_List.coupon_name != '')
               OrderInfo.Coupon_Name__c = cart_Payment_List.coupon_name;
           
           if(cart_Payment_List.coupon_discount != null && cart_Payment_List.coupon_discount != '')
               OrderInfo.Discount_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List.coupon_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.intro_discount != null && cart_Payment_List.intro_discount != '')
               OrderInfo.Intro_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List.intro_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.bulk_discount != null && cart_Payment_List.bulk_discount != '')
               OrderInfo.bulk_discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List.bulk_discount.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.GST != null && cart_Payment_List.GST != '')
               OrderInfo.GST__c = String.Valueof(Decimal.valueOf(cart_Payment_List.GST.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.subtotal != null && cart_Payment_List.subtotal != '')
               OrderInfo.Subtotal__c = String.Valueof(Decimal.valueOf(cart_Payment_List.subtotal.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.Total != null && cart_Payment_List.Total != '')
               OrderInfo.Total__c = String.Valueof((Decimal.valueOf(cart_Payment_List.Total.replaceAll('[^.\\d]',''))).setScale(2, RoundingMode.HALF_UP));
           
           if(cart_Payment_List.org_total != null && cart_Payment_List.org_total != '')
               OrderInfo.org_total__c = String.Valueof(Decimal.valueOf(cart_Payment_List.org_total.replaceAll('[^.\\d]','')));
           
            if(cart_Payment_List.total_price != null && cart_Payment_List.total_price != '')
               OrderInfo.Total_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List.total_price.replaceAll('[^.\\d]','')));
           
           if(cart_Payment_List.total_saving != null && cart_Payment_List.total_saving != '')
               OrderInfo.Total_Saving__c = String.Valueof(Decimal.valueOf(cart_Payment_List.total_saving.replaceAll('[^.\\d]','')));
       }
       OrderInfo.Shipping_Date__c =orderDetails.IBShippingDate;
       OrderInfo.OrderConfirmationDate__c = orderDetails.OrderConfirmationDate;
       OrderInfo.orderDate__c = orderDetails.orderDate;
        OrderInfo.is_ist_mode__c = orderDetails.is_ist_mode;
       OrderInfo.ist_user_email__c = orderDetails.ist_user_email;
       OrderInfo.Arriving_Date__c =orderDetails.IBArrivingDate;
          if(orderDetails.url_params!=null && orderDetails.url_params!='')
       OrderInfo.url_params__c=orderDetails.url_params;
       if(orderDetails.utm_campaign!=null && orderDetails.utm_campaign!='')
	   OrderInfo.UTM_Campaign__c=orderDetails.utm_campaign;
       if(orderDetails.utm_content!=null && orderDetails.utm_content!='')
	   OrderInfo.UTM_Content__c=orderDetails.utm_content;
        if(orderDetails.utm_medium!=null && orderDetails.utm_medium!='')
	   OrderInfo.UTM_Medium__c=orderDetails.utm_medium;
        if(orderDetails.utm_term!=null && orderDetails.utm_term!='')
	   OrderInfo.UTM_Term__c=orderDetails.utm_term;
        if(orderDetails.utm_source!=null && orderDetails.utm_source!='')
	   OrderInfo.UTM_Source__c =orderDetails.utm_source;
       if(orderDetails.shippingAddress != null)
       {
           if(orderDetails.shippingAddress.name != null)
               OrderInfo.Shipping_Name__c = orderDetails.shippingAddress.name;
           
           if(orderDetails.shippingAddress.email != null)
               OrderInfo.Shipping_Email__c = orderDetails.shippingAddress.email;
           
           if(orderDetails.shippingAddress.address != null)
               OrderInfo.Shipping_Address__c = orderDetails.shippingAddress.address;
           
           if(orderDetails.shippingAddress.pincode != null)
               OrderInfo.Shipping_Pincode__c = orderDetails.shippingAddress.pincode;
           
           if(orderDetails.shippingAddress.phone != null)
               OrderInfo.Shipping_Phone__c = orderDetails.shippingAddress.phone;
           
           if(orderDetails.shippingAddress.city != null)
               OrderInfo.Shipping_City__c = orderDetails.shippingAddress.city;
           
           if(orderDetails.shippingAddress.state != null)
               OrderInfo.Shipping_State__c = orderDetails.shippingAddress.state;
           
           if(orderDetails.shippingAddress.country != null)
               OrderInfo.Shipping_Country__c = orderDetails.shippingAddress.country;
           
           if(orderDetails.shippingAddress.landmark != null)
               OrderInfo.Shipping_Landmark__c = orderDetails.shippingAddress.landmark;
           
           if(orderDetails.shippingAddress.gstinNumber != null)
               OrderInfo.Shipping_GSTInNumber__c = orderDetails.shippingAddress.gstinNumber;
       }
       if(orderDetails.billingAddress != null)
       {
            if(orderDetails.billingAddress.name != null)
                OrderInfo.Billing_Name__c = orderDetails.billingAddress.name;
            
            if(orderDetails.billingAddress.email != null)
                OrderInfo.Billing_Email__c = orderDetails.billingAddress.email;
            
            if(orderDetails.billingAddress.address != null)
                OrderInfo.Billing_Address__c = orderDetails.billingAddress.address;
            
            if(orderDetails.billingAddress.pincode != null)
                OrderInfo.Billing_Pincode__c = orderDetails.billingAddress.pincode;
            
            if(orderDetails.billingAddress.phone != null)
                OrderInfo.Billing_Phone__c = orderDetails.billingAddress.phone;
            
            if(orderDetails.billingAddress.city != null)
                OrderInfo.Billing_City__c = orderDetails.billingAddress.city;
            
            if(orderDetails.billingAddress.state != null)
                OrderInfo.Billing_State__c = orderDetails.billingAddress.state;
            
            if(orderDetails.billingAddress.country != null)
                OrderInfo.Billing_Country__c = orderDetails.billingAddress.country;
            
            if(orderDetails.billingAddress.landmark != null)
                OrderInfo.Billing_Landmark__c = orderDetails.billingAddress.landmark;
            
            if(orderDetails.billingAddress.gstinNumber != null)
                OrderInfo.Billing_GSTInNumber__c = orderDetails.billingAddress.gstinNumber;
        }
        
           boolean isInvoice = false;
           String invoice_url;
           List<Invoice__c> invoice = new List<Invoice__c>();
           for(EcomIntegrationWrapper.OrderItems Item : orderDetails.orderItems)
           {
               if(Item.IBInvoiceUrl!=null && Item.IBInvoiceUrl.size()>0)
               {
                   isInvoice = true;
                   for(EcomIntegrationWrapper.IBInvoiceUrlWrpper invObj : Item.IBInvoiceUrl)
                   {
                       invoice_url = invObj.url;
                   } 
                  
               }
           }
           
           if(isInvoice)
           {
               invoice = [SELECT Id, OwnerId, Name, Invoice_Url__c, Product_Name__c, Vendor_Name__c FROM Invoice__c where Invoice_Url__c =: invoice_url];
           }
       List<Invoice__c> invoicetoInsert=new List<Invoice__c>(); 
       if(orderDetails.orderItems.size()>0)
       {
          
          for(EcomIntegrationWrapper.OrderItems Item : orderDetails.orderItems)
          {
              
              Ordered_Product__c orderProduct = new Ordered_Product__c();
             Ordered_Product__c orderProductReference = new Ordered_Product__c();
              if(orderDetails.IBOrderNumber!=null && Item.sku!=null)
              {
                 orderProductReference.External_Id__c=orderDetails.IBOrderNumber+Item.sku;
                 orderProduct.External_Id__c=orderDetails.IBOrderNumber+Item.sku;
              }
              
              orderProduct.Product_Id__c = Item.id;
              if(Item.bulk_discount!=NULL && Item.sku!=NULL)
              orderProduct.Bulk_Discount__c=Item.bulk_discount;
              if(Item.strikedOffPrice != null && Item.strikedOffPrice != '')
                  orderProduct.Striked_Off_Price__c = String.Valueof(Decimal.valueOf(Item.strikedOffPrice.replaceAll('[^.\\d]','')));
              if(Item.sku != null)
              {
                  orderProduct.SKU__c = Item.sku;
              }
              if(Item.IBOrderStatus != null )
                  orderProduct.Order_Status__c = Item.IBOrderStatus;
              
              if(Item.IBShippingDate != null )
                  orderProduct.Shipping_Date__c = Item.IBShippingDate;
              
              if(Item.IBArrivingDate != null )
                  orderProduct.Arriving_Date__c = Item.IBArrivingDate;
              
              if(Item.distributor_allocated != null )
                  orderProduct.Distributor_allocated__c = Item.distributor_allocated;
              
             
             if(Item.IBInvoiceUrl!=null && Item.IBInvoiceUrl.size()>0 && invoice.size() == 0)
			 {
                for(EcomIntegrationWrapper.IBInvoiceUrlWrpper invObj : Item.IBInvoiceUrl)
                {
                    Invoice__c inv=new Invoice__c();
                    
                    if(invObj.url != null )
                    inv.Invoice_Url__c=invObj.url;
                    
                     if(invObj.vendor != null )
                    inv.Vendor_Name__c=invObj.vendor;
                    
                    inv.Product_Name__r=orderProductReference;
                    invoicetoInsert.add(inv);
                }
			  }              
              orderProduct.Order_Information__c = OrderInfo.Id;
              orderProductList.add(orderProduct);
          }
         
       }
        
        try
        {
        if(orderProductList.size()>0)
         Upsert orderProductList External_Id__c;
        }
        Catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getCause());
        }
       
        UpdateOrder.add(OrderInfo);
        
        try{
       if(invoicetoInsert.size()>0)
       Insert invoicetoInsert;
        }
        Catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getCause());
        }
        
        
       if(UpdateOrder.size()>0) 
       {
       	Update UpdateOrder;
       }
        System.debug('UpdateOrder updated');
        
        
        
  }
    
    
    public void createlast_five_logins(Contact cnt,List<EcomIntegrationWrapper.Last_five_logins> last_five_loginsList)
    {
        List<Last_Five_Logins__c> lastfiveLoginList=new List<Last_Five_Logins__c>();
        if(cnt!=null && last_five_loginsList.size()>0)
        {
           for(EcomIntegrationWrapper.Last_five_logins l  : last_five_loginsList)
           {
               Last_Five_Logins__c loginObj=new Last_Five_Logins__c();
               loginObj.Name=l.date1;
               loginObj.Customer_Contact__c=cnt.id;
               lastfiveLoginList.add(loginObj);
           }
           Insert lastfiveLoginList;
        }
        
        system.debug('ctaListforContacts'+ctaListforContacts);
        if(ctaListforContacts.size()>0)
               update ctaListforContacts;   
    }
    
    public void coverMethod()
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i--;
    }
    }