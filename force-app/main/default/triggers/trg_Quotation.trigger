trigger trg_Quotation on Quotation__c (before insert,After Update,before update) 
{
   EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsQuotationTrgActivated__c)
    {
      	List<User> userList=[Select id,Pin_codes__c,profileId,UserRoleId from user where UserRole.name='Inside Sales Team'];
    Map<String,User> userpincodeMap=new Map<String,User>();
    List<String> pincodeList;
    for(User u  : userList)
    {
        String pincodes=u.Pin_codes__c;
        pincodeList=new List<String>();
        if(pincodes!=null && pincodes!='')
        pincodeList=pincodes.split(',');
		for(String str :pincodeList)
        {
          userpincodeMap.put(str,u);  
        }
        
    }
    
	if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate ))
        {
           for(Quotation__c q :trigger.new)
           {
              String pincode;
              
              if(q.Customer_Contact__c!=null)
              {
                  
                pincode=q.Contact_Pincode__c;
                
              }
              else if(q.Lead_Name__c!=null)
              {
                  
                 pincode=q.Lead_Pincode__c;
                  
              }
             if(pincode!=null && pincode!='')
              {
                 if(userpincodeMap.containsKey(pincode)) 
                 {
                   q.OwnerId=userpincodeMap.get(pincode).id;
                 }
              }
              
           }
         }
        System.debug('QuotationTriggerHandlr.selfupdatetriggerFlag----	'+QuotationTriggerHandlr.selfupdatetriggerFlag);
        if(trigger.isAfter && trigger.isUpdate && QuotationTriggerHandlr.selfupdatetriggerFlag)
        {
            List<Quotation__c> quotatinoList=new List<Quotation__c>();
            for(Quotation__c q : trigger.new)
            {
                if(q.CC_Status__c != trigger.oldmap.get(q.Id).CC_Status__c && q.CC_Status__c=='mql')
                {
                    quotatinoList.add(q);
                }
            }
            if(quotatinoList.size()>0)
            QuotationTriggerHandlr.trg_Quotation(quotatinoList,trigger.oldMap,userpincodeMap);
        }  
    }
    
    
}