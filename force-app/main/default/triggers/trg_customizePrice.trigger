/*
 * test class name : test_trg_customizePrice
 * handler : CustomizePrizeHandlr
*/
trigger trg_customizePrice on Customized_Price__c (before insert,after Update,before update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsCustomizedPricetriggerActivated__c)
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
        for(Customized_Price__c q :trigger.new)
           {
              String pincode;
              if(q.Contact_Name__c !=null)
              {
                pincode=q.Contact_Pincode__c;
                
              }
              else if(q.Lead_Name__c!=null)
              {
                 pincode=q.lead_pincode__c; 
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
    if(trigger.isAfter && trigger.isUpdate && RequesttoCallbackHandlr.selfupdatetriggerFlag)
    {
        List<Customized_Price__c> CustomizePriceList=new List<Customized_Price__c>();
            for(Customized_Price__c q : trigger.new)
            {
                if(q.CC_Status__c != trigger.oldmap.get(q.Id).CC_Status__c && q.CC_Status__c=='mql')
                {
                    CustomizePriceList.add(q);
                }
            }
            if(CustomizePriceList.size()>0)
            CustomizePrizeHandlr.trg_Customizeprice(CustomizePriceList,trigger.oldMap,userpincodeMap);
        } 
    }
	
}