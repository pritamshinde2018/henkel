trigger trgOnLead_BeforeUpdateInsert on Lead (before insert, before update) 
{
    Id lowAgentId;
    Integer count=0;
    for(Call_Center_Agents__c agentObj : [Select id,name,(Select id,name  from Leads__r) from Call_Center_Agents__c])
    {
        if(agentObj.Leads__r.size()==0)
        {
            lowAgentId = agentObj.id;
            break;
        }
        else if( count==0 ||count >= agentObj.Leads__r.size())
        {
            lowAgentId = agentObj.id;
            count = agentObj.Leads__r.size();
        }
    }
    for(Lead l: trigger.new)
    {
        if((l.pi__score__c < 75 || l.pi__score__c == null) && l.CC_Status__c == null && l.Call_Center_Agents__c == null)
        {
            l.Call_Center_Agents__c=lowAgentID;        
        }
    }
}