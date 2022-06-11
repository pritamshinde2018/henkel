public class istUserAssignment 
{
    public static void istUserAssignment(List<Lead> newLead)
    {
        List<Group> g = new List<Group>();
        List<groupMember> memberList = new List<groupMember>();
        List<AggregateResult> lst = new List<AggregateResult>();
        List<Id> lstIds = new List<Id>();
        set<Id> pnsId = new set<Id>();
        String exclude_ist_member = System.Label.Exclude_IST_Member;
        
        for(Lead l : newLead)
        {
            if(l.LeadSource == 'Indiamart' && l.Indiamart_QTYPE__c == 'PNS')
            {
                pnsId.add(l.Id);
            }
            if(l.LeadSource == 'TradeIndia' && l.Ecom_Source__c == 'DialB2B')
            {
                pnsId.add(l.Id);
            }
        }
        
        if(pnsId.size() > 0)
        {
            g = [Select id,name from group where name = 'SalesTeam' limit 1];
        }
        
        if(g.size() > 0)
        {
            memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].id];
        }
        
        for(groupMember grp: memberList)
        {
            if(grp.UserOrGroupId!=exclude_ist_member)
            lstIds.add(grp.UserOrGroupId);
        }
        System.debug('List IDs :'+lstIds);
        if(lstIds.size() > 0)
        {
            lst = [select  OwnerId, count(Id) from Lead where isConverted=false AND (cc_status__c = null OR cc_status__c = 'callback1' OR cc_status__c = 'callback2') AND Indiamart_QTYPE__c = 'PNS' And OwnerId in :lstIds group by OwnerId order by count(Id)];
        }
        
        for(Lead l : newLead)
        {
            if(l.LeadSource == 'Indiamart' && l.Indiamart_QTYPE__c == 'PNS')
            {
                if(lst.size() > 0)
                {
                    for(AggregateResult ar : lst)
                    {
                        l.OwnerId = (Id)ar.get('OwnerId');
                        l.status='Data Collection Process';
                        break;
                    }
                }
                else
                {
                    l.OwnerId = '0057F000004E7ZB';
                     l.status='Data Collection Process';
                }
                          
            }
            else if(l.LeadSource == 'TradeIndia' && l.Ecom_Source__c == 'DialB2B')
            {
                if(lst.size() > 0)
                {
                    for(AggregateResult ar : lst)
                    {
                        l.OwnerId = (Id)ar.get('OwnerId');
                        l.status='Data Collection Process';
                        break;
                    }
                }
                else
                {
                    l.OwnerId = '0057F000004E7ZB';
                     l.status='Data Collection Process';
                }
            }
        }
       
        
    }
}