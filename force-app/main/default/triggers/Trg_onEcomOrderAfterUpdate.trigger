trigger Trg_onEcomOrderAfterUpdate on Order_Information__c (before update,before insert, after update, after insert)
{
    
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    /*Map<String,Distributor_Pincode_Mapping__c> DistributorMap=new Map<String,Distributor_Pincode_Mapping__c>();
    for(Distributor_Pincode_Mapping__c d: [Select Id,Distributor_Name__c,Pincode__c From Distributor_Pincode_Mapping__c])
    {
        DistributorMap.put(d.Pincode__c,d);
    }*/
    if(mc.IsneworderTrgActivated__c)
    {
        if(trigger.isbefore)
        {
            if(trigger.isupdate)
            {
                EcomOrderHandler.order_owner_update(trigger.new,trigger.oldmap,true);
            }
            if(trigger.isinsert)
            {
                
                EcomOrderHandler.order_eligible_distributor(trigger.new,true);
                
                
                
                /*     For(Order_Information__c Ecom : trigger.new)
{

if(DistributorMap.containsKey(Ecom.Billing_Pincode__c) && Ecom.Billing_Pincode__c!=Null)
{

Ecom.Eligible_Distributor__c=DistributorMap.get(Ecom.Billing_Pincode__c).Distributor_Name__c;

}
} */
                
            }
        } 
        
        if(trigger.isAfter && trigger.isInsert){
           EcomOrderHandler.cta_ordeStatus_update(trigger.new,trigger.newmap,'insert');
        }
        if(trigger.isAfter && trigger.isUpdate){
           EcomOrderHandler.cta_ordeStatus_update(trigger.new,trigger.oldmap,'update');
        }
    }    
}