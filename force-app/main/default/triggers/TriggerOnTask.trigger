trigger TriggerOnTask on Task (before insert,before update) 
{
    /*List<ID> whatIDList = new List<ID>();
    for(Task t:trigger.new)
    {
        if(t.Status == 'Completed' && t.Subject == 'Qualify Sampling')
        {
           whatIDList.add(t.WhatID);       
        }       
    }
    Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([Select ID From Opportunity Where (ID IN : whatIDList AND Market_Segment__c = Null AND Amount = Null AND RecurringBusiness__c = Null)]);
    for(Task t:trigger.new)
    {
        if(opportunityMap.containsKey(t.WhatId) && t.Subject == 'Qualify Sampling')
        {
            t.adderror('Please fill market segment,amount,type of business On Project to complete the task');
        }
    }*/
}