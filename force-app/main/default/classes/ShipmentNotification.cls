@RestResource (urlMapping='/shipped_order/*')
global class ShipmentNotification{
   
    @HttpPost
    global static void doPost(String order_id) {
    
   
    try
        {
       /* upsert ecomNot Name;*/
           ShipmentNotificationDataIntegration testss = new ShipmentNotificationDataIntegration();
           testss.getShipmentDetails(order_id);
           RestContext.response.addHeader('Content-Type', 'application/json');
           RestContext.response.responseBody = Blob.valueOf('{ "status" : "200", "message" : "ssssss" }');
           
    }
    catch(Exception e)
        {
            RestContext.response.addHeader('Content-Type', 'application/json');
         	RestContext.response.responseBody = Blob.valueOf('{ "status" : "500", "message" : "Sever Error" }');
        }

    }
    

}