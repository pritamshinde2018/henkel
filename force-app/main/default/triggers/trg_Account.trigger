/*
*test Class :  test_trg_Account
*/
trigger trg_Account on Account (before insert,before Update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    
    if(mc.trg_Account__c)
    {
        if(checkRecursive.Leadflag)
        {
            Map<String,Industry_Code_Values__mdt > industryCodeMap=new Map<String,Industry_Code_Values__mdt >();
            
            For(Industry_Code_Values__mdt industrycodeObj :[Select id,Industry__c,label,code__c,Internal_Code__c from Industry_Code_Values__mdt])
            {
                industryCodeMap.put(industrycodeObj.Industry__c,industrycodeObj);
                
            }
            if(trigger.isBefore)
            {
                for(Account acc : trigger.new)
                {
                    if(acc.Industry!=null && industryCodeMap.containsKey(acc.Industry))
                    {
                        acc.Industry_Code__c=industryCodeMap.get(acc.Industry).code__c;
                        acc.Internal_Code_ace__c=industryCodeMap.get(acc.Industry).Internal_Code__c;
                    }
                    
                    else
                        acc.Industry_Code__c='NA'; 
                }
            }
        	checkRecursive.Leadflag = false;
        }
    }
}