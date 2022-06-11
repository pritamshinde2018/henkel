trigger trg_onOrder_Attachment on Order (before update,after insert) {
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.trg_onOrder_Attachment__c	)
    {
        if(trigger.isbefore && trigger.isupdate)
        {
            List<Order> ord = New List<Order>();
            Map<Id,Order> addErrorMap= new Map<Id,Order>();
            for(Order o:[Select Id,Status,(Select Id, ContentDocumentID, LinkedEntityid, ShareType, Visibility From ContentDocumentLinks) FROM Order where id in  :trigger.new])
            {
                System.debug('o.ContentDocumentLinks.size() '+o.ContentDocumentLinks.size());
                if(o.ContentDocumentLinks.size()==0 && o.Status!='Activated'){
                    addErrorMap.put(o.Id,o);
                    System.debug('***********************'+o.Status);
                }
            }  
            for(Order o:Trigger.new){
                if(addErrorMap.containsKey(o.Id)){
                    o.addError('You need to upload the invoice copy and add products in the related tabs of this Order to change Status to Activate');       
                }               
            }	
        }
        
        if(trigger.isAfter && trigger.isinsert)
        {
            set<String> oppty = new Set<String>();
            
            Set<String> setLead = New Set<String>();
            
            List<Lead> lead = new List<Lead>();
            
            System.debug('After trigger.isinsert');
            
            for(Order order : trigger.new)
            {
                oppty.add(order.OpportunityId);
            }
            
            For(Opportunity opp : [Select id,CTA__r.Lead__c from Opportunity where id in: oppty])
            {
                setLead.add(opp.CTA__r.Lead__c);
            }
            
            lead = [Select id, Customer_creation_date__c from Lead where id in : setLead];
            
            for(Lead rec : lead)
            {
                if(rec.Customer_creation_date__c == null)
                {
                    rec.Customer_creation_date__c = System.now();
                }
            }
            
            try
            {
                update lead;
            }
            catch(Exception e)
            {
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                System.debug(e.getCause());
            }
        }
    }
}