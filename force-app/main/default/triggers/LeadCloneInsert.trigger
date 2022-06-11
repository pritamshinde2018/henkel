trigger LeadCloneInsert on LeadClone__c (after insert) 
{
		System.debug('LeadCloneInsert Fired');
        LeadCloneHandler.ParseData(trigger.new);
    
}