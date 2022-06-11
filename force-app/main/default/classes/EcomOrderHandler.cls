public class EcomOrderHandler {
    
    public static void order_owner_update(List<Order_Information__c> neworderlist,Map<Id,Order_Information__c> oldmaporders,Boolean isupdate)
    {
        List<User> userList=[Select id,Pin_codes__c,profileId,UserRoleId from user where UserRole.name='Inside Sales Team'];
        Map<String,id> userpincodeMap=new Map<String,id>();
        List<String> pincodeList;
        for(User u  : userList)
        {
            String pincodes=u.Pin_codes__c;
            pincodeList=new List<String>();
            if(pincodes!=null && pincodes!='')
                pincodeList=pincodes.split(',');
            for(String str :pincodeList)
            {
                userpincodeMap.put(str,u.id);  
            }
            
        }
        for(Order_Information__c ord:neworderlist)
        {
            if(ord.Payment_Status__c=='RTO delivered' || ord.Payment_Status__c=='RTO' || ord.Payment_Status__c=='Returned' || ord.Payment_Status__c=='Shipped & Returned' || ord.Payment_Status__c=='Cancelled')
            {
                if(userpincodeMap.containsKey(ord.Shipping_Pincode__c) && ord.Shipping_Pincode__c!=NULL)
                {
                    Ord.OwnerId=userpincodeMap.get(ord.Shipping_Pincode__c);
                }
                
            }
            if(ord.Payment_Status__c!=NUll && oldmaporders.get(ord.id).Payment_Status__c=='booked' && ord.Payment_Status__c=='Order Placed')
            {
                Ord.OwnerId=label.Default_IST;
            }
        }
        
        
    }
  public static void order_eligible_distributor(List<Order_Information__c> EcomPincode,Boolean isinsert)
    {
        Map<String,Distributor_Pincode_Mapping__c> DistributorMap=new Map<String,Distributor_Pincode_Mapping__c>();
        
        set<String> pincode = new set<String>();
        
        for(Order_Information__c Ecom : EcomPincode)
        {
            if(Ecom.Billing_Pincode__c != null)
            {
                pincode.add(Ecom.Billing_Pincode__c);
            }
        }
        
        if(pincode.size() > 0)
        {
            for(Distributor_Pincode_Mapping__c d: [Select Id,Distributor_Name__c,Pincode__c From Distributor_Pincode_Mapping__c where Pincode__c=: pincode])
            {
                DistributorMap.put(d.Pincode__c,d);
            }
        }
        
        for(Order_Information__c Ecom : EcomPincode)
        {
            if(DistributorMap.ContainsKey(Ecom.Billing_Pincode__c))
            {
                System.debug('In Eligible Code Handler ');
                Ecom.Eligible_Distributor__c=DistributorMap.get(Ecom.Billing_Pincode__c).Distributor_Name__c;
                
            }
        }
        
        
    }
    
    public static void cta_ordeStatus_update(List<Order_Information__c> newOrderList,Map<id,Order_Information__c> oldmap,string eventtype)
    {
        Set<Id> ctaId = new Set<Id>();
        Set<Id> opptyId = new Set<Id>();
        List<Cta__c> ctalst = new List<Cta__c>();
        List<Opportunity> oppty = new List<Opportunity>();
        
        for(Order_Information__c order : newOrderList)
        {		
            System.debug('Order information in trigger :');
            if(order.Payment_Status__c != oldmap.get(order.Id).Payment_Status__c && eventtype == 'update')
            {
                opptyId.add(Order.Project__c);
            }
            else
            {
                opptyId.add(Order.Project__c);
            }
        }
        
        if(opptyId.size() > 0)
        {
            oppty = [Select id, CTA__c from Opportunity where id =: opptyId];
        }
        
        for(Opportunity opp : oppty)
        {
            ctaId.add(opp.CTA__c);
        }
        
        if(ctaId.size() > 0)
        {
            ctalst = [Select id,Order_Status__c  from CTA__c where id in : ctaId];
        }
        
        for(Cta__c cta : ctalst)
        {
            System.debug('Order information  cta update in trigger :');
            cta.Order_Status__c = newOrderList[0].Payment_Status__c;
        }
        
        try
        {
            upsert ctalst;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getCause());
        }
    }
}