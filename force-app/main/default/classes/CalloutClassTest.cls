@isTest(seeAllData=true)
private class CalloutClassTest {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        LinkedlnWebinarCallout.calloutWebservice('piyusha122@testing.com','8111111234','Linkedin','test','compa','14526','test','0-20');         
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
    /* @isTest static void testCallouttwo() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
         HttpResponse res = CalloutClass.shipment();
         Order_Information__c o=new Order_Information__c();
         o.Name='2010';
         o.Email__c='ramji.shinde@nanostuffs.com';
        	insert o;
         Ordered_Product__c op=new Ordered_Product__c();
         op.Name='test';
         op.Order_Information__c=o.Id;
         op.Order_Status__c='Order delivered';
         op.SKU__c='AD.RE.195910';
         insert op;
     //   list<Order_Information__c> oplist=[select id,Order_Status__c,CodCharge__c,Shipping_City__c,Shipping_State__c,Shipping_Pincode__c,Shipping_Address__c,Price__c, Total__c ,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Intro_Discount__c,Bulk_Discount__c,Coupon_Discount__c,Tax__c,Subtotal__c,Striked_Off_Price__c  from Ordered_Product__c where Order_Information__c=:O.id limit 1];
         Ordered_Product__c op1=new Ordered_Product__c();
         op1.Name='test';
         op1.Order_Information__c=o.Id;
         op1.Order_Status__c='Order shipped';
         op.SKU__c='AD.GA.195892';
         insert op1;
          Order_Information__c OI=new Order_Information__c();
         test.startTest();
        ShipmentNotificationDataIntegration s=new ShipmentNotificationDataIntegration();
         s.getShipmentDetails('2010');  
         s.OrderDispatch(o);
         s.OrderDelivered(o);
         s.cover();
         ////////////////////////
         RestRequest req = new RestRequest(); 
         RestResponse res1 = new RestResponse();
         req.requestURI = '/services/apexrest/shipped_order'; 
         req.params.put('order_id', '2010');
         req.httpMethod = 'POST';
         req.addHeader('Content-Type', 'application/json'); 
         RestContext.request = req;
         RestContext.response = res1;
         ShipmentNotification.doPost('2010');
         test.stopTest();
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"response":{"shipped_count":2,"delivered_count":0,"product_shipped":[{"product_name":"Loctite 609 - 50 ml","product_sku":"AD.RE.195910"},{"product_name":"Loctite 518 - 50 ml","product_sku":"AD.GA.195892"}],"product_delivered":[]}}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }*/
}