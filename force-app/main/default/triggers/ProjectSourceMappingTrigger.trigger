trigger ProjectSourceMappingTrigger on Project_Source_Mapping__c (before insert,before update) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.ProjectSourceMappingTrigger__c)
    {
        if(trigger.IsBefore && trigger.isInsert)
    {
       Map<String,String> projectsourcePriorityMap=new Map<String,String>();
        for(Project_Source_Mapping__c pr : trigger.new)
        {
           projectsourcePriorityMap.put(pr.name,pr.Priority__c);  
        }
        List<Opportunity> opportunityList=[Select id,Project_source__c,Project_Source_priority__c from Opportunity where Project_source__c in :projectsourcePriorityMap.keyset()];
    	List<Opportunity> OpportunitytoUpdate=new List<Opportunity>();
        for(Opportunity opp : opportunityList)
        {
           if(projectsourcePriorityMap.containskey(opp.Project_source__c))
           {
             opp.Project_Source_priority__c=projectsourcePriorityMap.get(opp.Project_source__c);
             OpportunitytoUpdate.add(opp);
           }
        }
        
        if(OpportunitytoUpdate.size()!=0)
        {
            Update OpportunitytoUpdate;
        }
    }
	if(trigger.IsBefore && trigger.isUpdate)
    {
        Map<String,String> projectsourcePriorityMap=new Map<String,String>();
        for(Project_Source_Mapping__c pr : trigger.new)
        {
           if(trigger.oldMap.get(pr.id).name!=pr.Name)
           {
              projectsourcePriorityMap.put(pr.name,pr.Priority__c); 
           }
        }
        List<Opportunity> opportunityList=[Select id,Project_source__c,Project_Source_priority__c from Opportunity where Project_source__c in :projectsourcePriorityMap.keyset()];
    	List<Opportunity> OpportunitytoUpdate=new List<Opportunity>();
        for(Opportunity opp : opportunityList)
        {
           if(projectsourcePriorityMap.containskey(opp.Project_source__c))
           {
             opp.Project_Source_priority__c=projectsourcePriorityMap.get(opp.Project_source__c);
             OpportunitytoUpdate.add(opp);
           }
        }
        
        if(OpportunitytoUpdate.size()!=0)
        {
            Update OpportunitytoUpdate;
        }
    }
    }
    
}