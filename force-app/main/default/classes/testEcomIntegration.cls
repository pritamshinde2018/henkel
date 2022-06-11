@isTest
public class testEcomIntegration 
{
    @isTest
	public static void testMethod1()
    {
        EcomAPI__c e=new EcomAPI__c();
        e.IsActivated__c=true;
        insert e;
        
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',IB_SKU__c='AD.TH1.333678',IDH__c='AD.GA.195902',isactive=true);
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntryCT
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
          
        );
        Insert pbe;
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs31.salesforce.com/services/apexrest/GetData';
        request.httpMethod = 'POST';
        String jasonString='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "taylen.quincee@oovy.org", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
        request.requestBody=blob.valueOf(jasonString);
        RestContext.request = request;
        GetData.doPost();
        
    }
    
    
    @isTest
	public static void testMethod2()
    {
         EcomAPI__c e=new EcomAPI__c();
        e.IsActivated__c=true;
        insert e;
        
       Contact cnt=new Contact();
       cnt.LastName='testContact';
       cnt.Email='test@test.com';
       cnt.Lead_classification_basis_value__c='A';
       insert cnt;
        
        /*Lead lObj=new Lead();
        lObj.LastName='testLead';
        lObj.pi__score__c=75;
        lObj.email='leadEmail@test.com';
        lObj.Company='testCompany';
        insert lObj;*/
        
        
        
        
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',IB_SKU__c='AD.TH1.333678',IDH__c='AD.GA.195902',isactive=true);
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
          
        );
        Insert pbe;
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs31.salesforce.com/services/apexrest/GetData';
        request.httpMethod = 'POST';
        String jasonString='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "test@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
        request.requestBody=blob.valueOf(jasonString);
        RestContext.request = request;
        GetData.doPost();
        
       Order_Information__c ord=new Order_Information__c();
        ord.Name='101631';
        ord.Customer_Contact__c=cnt.id;
        insert ord;
       	
        String jasonString3='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "test@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString3);
        RestContext.request = request;
        GetData.doPost();
        
        String jasonString1='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "leadEmail@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString1);
        RestContext.request = request;
        GetData.doPost();
        
        String jasonString2='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "leadEmail@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "", "IBOrderNumber": "", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString2);
        RestContext.request = request;
        GetData.doPost();
        
    }
    
    
    @isTest
	public static void testMethod3()
    {
         EcomAPI__c e=new EcomAPI__c();
        e.IsActivated__c=false;
        insert e;
        
       Contact cnt=new Contact();
       cnt.LastName='testContact';
       cnt.Email='test@test.com';
       cnt.Lead_classification_basis_value__c='A';
       insert cnt;
        
        /*Lead lObj=new Lead();
        lObj.LastName='testLead';
        lObj.pi__score__c=75;
        lObj.email='leadEmail@test.com';
        lObj.Company='testCompany';
        insert lObj;*/
        
        
        
        
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',IB_SKU__c='AD.TH1.333678',IDH__c='AD.GA.195902',isactive=true);
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
          
        );
        Insert pbe;
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs31.salesforce.com/services/apexrest/GetData';
        request.httpMethod = 'POST';
        String jasonString='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "test@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
        request.requestBody=blob.valueOf(jasonString);
        RestContext.request = request;
        GetData.doPost();
        
       Order_Information__c ord=new Order_Information__c();
        ord.Name='101631';
        ord.Order_Number__c='101631';
        ord.Customer_Contact__c=cnt.id;
        insert ord;
       	
        String jasonString3='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "test@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString3);
        RestContext.request = request;
        GetData.doPost();
        
        String jasonString1='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "leadEmail@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString1);
        RestContext.request = request;
        GetData.doPost();
        
        String jasonString2='[{"userid": 628190, "visitor_id": "1631", "user_contact_detail": [{"name": "test taylen", "email": "test@test.com", "company": "testtaylen", "phone": "9158296137", "industry": "Bicycle & Bicycle parts manufacturing", "role_in_the_organisation": "I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning", "no_of_employees": "20-100", "what_is_the_purpose": "Trading/Re-selling", "change_password_link": "http://", "Ecom_campaign": "GSA_On_demand_", "Ecom_Source": "FB_GSA_static", "Ecom_content": "On_demand", "Ecom_media": "cpc", "Ecom_term": "June19", "Ecom_URL_Params": "utm_source=FB_GSA_static&utm_medium=cpc&utm_campaign=GSA_On_demand_&utm_term=June19&utm_content=On_demand&fbclid=IwAR2udUCZeIfe1BE1mMWxo9YlPK6T7UBipBJ0USg0Uih5zHArS1yO4lNa1eE", "address": {"address_1": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number":"5418489"},"address_2": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"},"address_3": {"name": "test taylen", "phone": "9158296137", "email": "", "company_name": "test", "street_address": "Address", "landmark": "CST", "city": "Mumbai", "zipcode": "400001", "state": "Maharashtra", "country": "India", "GSTIN_number": "123456"}}, "coupon_redeem": false, "user_coupon": ""}], "search_keywords": ["bsifhwe"], "products_viewed": [{"product_name": "Loctite 567", "category": "Thread Sealants", "product_url": null}], "wish_lists": [], "last_five_logins": [{"date": "2020-01-22 06:55:44.625171+00:00"}], "order": {"clientOrderNumber": "1631", "IBOrderNumber": "101631", "IBOrderStatus": "Order Placed", "orderDate": "2020-01-22", "email": "taylen.quincee@oovy.org", "IBTrackingNumber": "", "IBInvoiceUrl": "", "IBShippingDate": "", "IBArrivingDate": "", "shippingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "billingAddress": {"name": "test taylen", "phone": "9158296137", "email": "taylen.quincee@oovy.org", "address": "Address", "landmark": "CST", "pincode": "400001", "city": "Mumbai", "state": "Maharashtra", "country": "India", "gstinNumber": ""}, "payment": [{"paymentMode": "cod", "status": "unpaid", "gateway": "", "amount": "1131.10", "transactionId": "", "paymentRealizedOn": "", "pgTransactionId": "", "chequeNumber": "", "chequeIssueBank": "", "chequeDate": "", "bankRefNumber": "", "bank": "", "paymentReceivedDate": ""}], "orderItems": [{"id": "2786", "sku": "AD.TH1.333678", "quantity": "1", "itemTitle": "Loctite 567", "taxPercentage": 18.0, "strikedOffPrice": "908.4746", "taxInclusivePrice": "1031.5574", "codCharge": 22.1785, "shippingCharge": 77.3668, "coupon_discount": "0.00", "bulk_discount": "0.00", "total": "1031.5574", "IBOrderStatus": "Order Placed", "tax": "157.3562", "image": "", "intro_discount": "", "subtotal": "", "IBInvoiceUrl": null, "IBShippingDate": "", "IBArrivingDate": "", "IBTrackingNumber": ""}]}, "cart_items":[{"product_id":"123","product_name":"jskk","price":"10","category":"sfgsf","size":"52","quanitity":"5","sku":"AD.TH1.333678"}], "cart_payment_information": {"coupon_name": "", "coupon_discount": "", "total_saving": "0", "GST": "157.3562", "subtotal": "874.2012", "intro_discount": "", "bulk_discount": "0.00", "org_total": "1072.0000", "Total": "1131.1027"}}]';
		request.requestBody=blob.valueOf(jasonString2);
        RestContext.request = request;
        GetData.doPost();
        
    }
}