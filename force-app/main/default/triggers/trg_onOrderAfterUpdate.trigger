/*
 * testClass : test_trg_onOrderAfterUpdate
*/
trigger trg_onOrderAfterUpdate on Order_Information__c (after insert, after update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsecomordertrgActivated__c)
    {
       System.debug('I am in trigger');
    String msg;
    
    list<Ordered_Product__c> Products=new list<Ordered_Product__c>();
    for(Order_Information__c orderObj : trigger.new)
    {
      
        //If IB Status Changed
       if(trigger.isUpdate)
       {
        if (orderObj.IndustryBuying_Status__c != null && orderObj.IndustryBuying_Status__c != trigger.oldMap.get(orderObj.Id).IndustryBuying_Status__c)
        {
            //Contact c = [select LastName, Name, Phone from Contact where Id =: orderObj.Customer_Contact__c];
            String message = 'LOCTITE eStore Order ID '+orderObj.Order_Number__c+' has been '+orderObj.IndustryBuying_Status__c+' on '+orderObj.LastModifiedDate +'via Blue Dart (shipment no 533343012). For queries, reach us on 18001801080 or visit www.tryloctite.in';
            
            if(orderObj.CustomerName__c != '')
                msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
            else
                msg = 'Hi,'+message;
            
            
            
            if (orderObj.Payment_Status__c == 'Order delivered')
            IndustryBuying_Helper.OrderDelivered(orderObj);
            
            if (orderObj.Payment_Status__c == 'Order shipped')
            IndustryBuying_Helper.OrderDispatch(orderObj);
            
            if (orderObj.Payment_Status__c == 'Order out for delivery')
            IndustryBuying_Helper.OrderOutForDelivery(orderObj);
            
            //orderObj.addError(msg); 
            //if(orderObj.Customer_Phone__c != null)   
            //SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
        }
       } 
       /* if(Trigger.isInsert)
        {
          //  List<Contact> cList = [select LastName, Name, Phone from Contact where Id =: orderObj.Customer_Contact__c];
           
            // if(cList.size()>0)
            // {  
                // Contact c = cList[0];
                 String message = 'Your LOCTITE eStore order id is '+orderObj.Order_Number__c+'. To track your order visit www.tryloctite.in. For queries, reach us on 18001801080.';
                    if(orderObj.CustomerName__c != '')
                       msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
                    else
                       msg = 'Hi, '+message;
            
                   //if(orderObj.Customer_Phone__c != null)   
                   // SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
                        
             // }   
             
          }*/
        
         
        if(Trigger.isupdate )
        {
           //System.debug('Industry Buyinng API');
          if(orderObj.PlaceEmail__c == false  && orderObj.Payment_Status__c == 'Order Placed')
          IndustryBuying_Helper.OrderPlace(orderObj);  
        }
       
     } 
    }
    
    
    
}