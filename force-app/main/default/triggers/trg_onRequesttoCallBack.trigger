/*
 * testClass : test_trg_onRequesttoCallBack
*/
trigger trg_onRequesttoCallBack on Request__c (before insert,after update,before update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.IsRequestCallbacktrgActivated__c)
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
           for(Request__c q :trigger.new)
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
            List<Request__c> RequestList=new List<Request__c>();
            for(Request__c q : trigger.new)
            {
                if(q.CC_Status__c != trigger.oldmap.get(q.Id).CC_Status__c && q.CC_Status__c=='mql')
                {
                    RequestList.add(q);
                }
            }
            if(RequestList.size()>0)
            RequesttoCallbackHandlr.trg_RequesttoCallback(RequestList,trigger.oldMap,userpincodeMap);
        } 
    }
	
}