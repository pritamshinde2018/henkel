trigger OrderConfirmationTrigger on Order_Information__c (before update) 
{
    Set<Id> ecomOrderIds=new Set<Id>();
	For(Order_Information__c ecom : trigger.new)
    {
        if(ecom.Confirmed_Order__c && trigger.oldMap.get(ecom.id).Confirmed_Order__c!=ecom.Confirmed_Order__c)
        {
          ecomOrderIds.add(ecom.id);
        }
    }
    
    if(ecomOrderIds.size()>0)
    {
      OrderConfirmationTriggerHandler.confirmOrder(ecomOrderIds);  
    }
}