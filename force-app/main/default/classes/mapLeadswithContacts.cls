public class mapLeadswithContacts implements database.Batchable<sObject> 
{
    public database.QueryLocator start(Database.BatchableContext bc)
    {
        return database.getQueryLocator('Select id,Contact_Sr_No__c from Lead where Contact_Sr_No__c!=null and isConverted=false');
    }
    
    public void execute(Database.BatchableContext bc , List<Lead> scope)
    {
      
        Set<string> contactsrnumberset=new Set<String>();
        for(Lead l : scope)
        {
            contactsrnumberset.add(l.Contact_Sr_No__c);
        }
        Map<String,contact> contactMap=new Map<String,Contact>();
       for(Contact cnt : [Select id,accountId,Contact_Sr_No__c from Contact where Contact_Sr_No__c in :contactsrnumberset])
       {
           contactMap.put(cnt.Contact_Sr_No__c,cnt);
       }
        system.debug('contactMap----- '+contactMap);
    List<Database.LeadConvert> convertLeadList=new List<Database.LeadConvert>();
    for(Lead l : scope)
    {
        if(contactMap.containsKey(l.Contact_Sr_No__c) && contactMap.get(l.Contact_Sr_No__c).accountId!=null)
        {
         Database.LeadConvert lc=new Database.LeadConvert();
           
            lc.setLeadId(l.Id);
            lc.setDoNotCreateOpportunity(True);
            lc.setContactId(contactMap.get(l.Contact_Sr_No__c).id);
            lc.setAccountId(contactMap.get(l.Contact_Sr_No__c).accountId);
            lc.setConvertedStatus('Qualified');
            convertLeadList.add(lc);
        }
    }
    List<Database.LeadConvertResult> lcr=Database.convertLead(convertLeadList);
     
    }
    
    public void finish(Database.BatchableContext info)
    {
        
    }
    
}