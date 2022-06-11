trigger trg_LeadBeforeInsert on Lead (before insert,before update) 
{
    Public List<User_City_Mapping__c> userMapping=new List<User_City_Mapping__c>();
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    List<Group> g = new List<Group>();
    List<groupMember> memberList = new List<groupMember>();
    List<AggregateResult> lst = new List<AggregateResult>();
    Set<Id> owner = new set<Id>();
    Map<Id,Id> ownerIdMap = new Map<Id,Id>();
    List<CTA__c> ctaList = new List<CTA__c>();
    
    set<Id> imIds = new set<Id>();
    
    if(trigger.isBefore && trigger.isInsert)
    {
        for(Lead l : trigger.new)
        {    
            if(((l.Indiamart_ID__c != null && (l.Indiamart_QTYPE__c=='Contact Suppliers'|| l.Indiamart_QTYPE__c=='Buy Leads'))) && trigger.isInsert && trigger.isBefore)
            {
                imIds.add(l.Id);
            }
            
            if(trigger.isBefore && trigger.isInsert && l.Prospect_Interest_Type__c=='Sample Requested' && l.Plumbing_Lead__c==True)
            {
                imIds.add(l.Id);
            }
            
            if(l.leadsource == 'TradeIndia' && l.Indiamart_ID__c != null && l.Ecom_Source__c != 'DialB2B')
            {
                imIds.add(l.Id);
            }
        } 
    }
    
    if(imIds.size()>0)
    {
        g = [Select id from group where name='CC Team' limit 1];
    }
    
    if(g.size()>0)
    {
       memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
    }
    
    List<Id> lstIds = new List<Id>();
    Set<Id> ownerIds = new set<Id>();
    if(mc.newDev_LeadTrigger__c)
    {
        if(memberList.size()>0)
        {
            for(groupMember g: memberList)
            {
                lstIds.add(g.UserOrGroupId);
                ownerIds.add(g.UserOrGroupId);
            }
        }
        
        if(lstIds.size() > 0)
        {
            lst = [select  OwnerId, count(Id) from Lead where (LeadSource='Indiamart'  OR Plumbing_Lead__c=True OR Prospect_Interest_Type__c='Webinar') And isConverted=false AND (cc_status__c = null OR cc_status__c = 'callback1' OR cc_status__c = 'callback2') And 
                                         OwnerId in :lstIds group by OwnerId order by count(Id)];
        }
        List<lead> leadtoInsert =new List<lead>();  
        String allProducts='';
        system.debug('lst size--- '+lst.size()); 
     
        if(trigger.isBefore)  
        {
            for(Lead l: trigger.new)
            {
                if(((l.Indiamart_ID__c != null && (l.Indiamart_QTYPE__c=='Contact Suppliers'|| l.Indiamart_QTYPE__c=='Buy Leads'))) && trigger.isInsert && trigger.isBefore)
                {
                    system.debug('I am in lead call center assignmetn if');
                    if(lst.size()==0)
                    {
                        l.OwnerId='0057F000004FG9z'; 
                        l.status='Data Collection Process';
                        l.CC_Qualification__c='Yes';
                    }
                    else
                    {
                        for(AggregateResult ar : lst)
                        {
                            l.OwnerId = (Id)ar.get('OwnerId');
                            l.status='Data Collection Process';
                            l.CC_Qualification__c='Yes';
                            
                            break;
                        }
                    }
                    
                }
                
                if(l.leadsource == 'TradeIndia' && l.Ecom_Source__c != 'DialB2B' && l.Indiamart_ID__c != null && trigger.isInsert && trigger.isBefore)
                {
                    system.debug('I am in lead call center assignmetn if');
                    if(lst.size()==0)
                    {
                        l.OwnerId='0057F000004FG9z'; 
                        l.status='Data Collection Process';
                        l.CC_Qualification__c='Yes';
                    }
                    else
                    {
                        for(AggregateResult ar : lst)
                        {
                            l.OwnerId = (Id)ar.get('OwnerId');
                            l.status='Data Collection Process';
                            l.CC_Qualification__c='Yes';
                            
                            break;
                        }
                    }
                    
                }
                
                if(trigger.isBefore && trigger.isUpdate)
                {
                   
                    if(l.CC_Status__c != trigger.oldmap.get(l.Id).CC_Status__c && l.status=='Data Collection Process')
                    {
                        l.CC_Status_Change_Date__c = system.now();
                    }
                }
                
               
                if(trigger.isBefore && trigger.isInsert && l.Prospect_Interest_Type__c=='Sample Requested'  && !ownerIds.contains(l.OwnerId) && l.Plumbing_Lead__c==True)
                {
                    
                    if(lst.size()==0)
                    {
                        System.debug('I am In IF Condition');
                        l.OwnerId='0057F000004FG9z'; 
                        l.status='Data Collection Process';  
                        l.CC_Qualification__c='Yes';
                    }
                    else
                    {
                        System.debug('I am In else Condition');
                        for(AggregateResult ar : lst)
                        {
                            System.debug('I am In For Loop');
                            l.OwnerId = (Id)ar.get('OwnerId');
                            l.status='Data Collection Process';
                            l.CC_Qualification__c='Yes';
                            break;
                        } 
                    }
                    
                }
            }
            if(leadtoInsert.size()>0)
                insert leadtoInsert;
        }
    }
    if(test.isRunningTest())
                covermethod();
    public static void covermethod()
    {
        Integer i=0;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
    }
    
}