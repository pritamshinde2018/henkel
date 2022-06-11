Public class CaseTriggerHelper {
    
    Public static void autoCreateContact(List<Case> caseList){
        
        List<String> emailIds = new List<String>();
        for(Case cs : caseList){
            emailIds.add(cs.SuppliedEmail);
        }
        System.debug('emailIds--->>>'+emailIds);
        if(emailIds != null && emailIds.size() > 0){
            List<Contact> contactList = [SELECT id,Name,AccountId,Email FROM Contact WHERE Email IN :emailIds];
           // List<Account> Accountlist = [Select Id ,Email From Account Where email in:emailIds];
            Map<String,Contact> emailToContact = new Map<String,Contact>();
            Map<String,String> emailToaccMap = new Map<String,String>();
            Map<String,String> contactToaccMap = new Map<String,String>();
            for(Contact ct : contactList ){
                emailToContact.put(ct.Email,ct);
                emailToaccMap.put(ct.Email,ct.AccountId);
            }
        
            RecordType customerContactRecordType = [SELECT Id FROM RecordType WHERE Name = 'Service' and SObjectType = 'Contact'];
            List<Contact> contListToInsert = new List<Contact>();
            List<Account> accListToInsert = new List<Account>();
            List<Contact> contactaccupdate = new List<Contact>();
            Map<String,Case> caseMap = new Map<String,Case>();

 /*           for(Account acc : accListToInsert)
            {
                //if(accListToInsert.size()>0)
                emailToaccMap.put(acc.Email__c, acc);
            }
            
             for(Case c: caseList)
            {
                    Account acc = new Account();
                    acc.name = 'NA -'+ c.SuppliedName;
                    acc.Email__c = c.SuppliedEmail;
                    accListToInsert.add(acc);
              
            }
            
            if(accListToInsert!=null && accListToInsert.Size()>0)
            insert accListToInsert; */
            
            
            
            
            for(Case c: caseList)
            {
                Contact cnt = emailToContact.get(c.SuppliedEmail);
                String acc = emailToaccMap.get(c.SuppliedEmail);
              //  Account acc = emailToaccMap.get(c.SuppliedEmail);
               
                if(cnt == null){
                    
                    Contact cont = new Contact();
                    cont.Email = c.SuppliedEmail;
                    
                   // cont.AccountId = acc.Id;
                    cont.recordTypeId  = customerContactRecordType.Id;
                    
                    if(acc!=null)
                    {
                        c.AccountId = acc; 
                    }
                    else if(acc == null)
                    {
                        Account acc1 = new Account();
                        acc1.name = 'NA -'+ c.SuppliedName;
                        acc1.Email__c = c.SuppliedEmail;
                        accListToInsert.add(acc1);
                    }
                    
                    
                    if(c.SuppliedName != null){
                    String[] Emailheader = c.SuppliedName.split(' ',2);
                        if (Emailheader.size() == 2){
                            cont.FirstName = Emailheader[0];
                            cont.LastName = Emailheader[1];
                        }else if(Emailheader.size() == 1){
                            cont.LastName = Emailheader[0];
                        } 
                    }
                    contListToInsert.add(cont);
                    caseMap.put(c.SuppliedEmail,c);
                }else{
                    c.ContactId = cnt.id;
                    c.AccountId = cnt.AccountId;
                }
            } 
            
            insert contListToInsert;
            insert accListToInsert;
            
            for(Account acc : accListToInsert)
            {
                contactToaccMap.put(acc.Email__c, acc.id);
            }
              
            for(Contact c : contListToInsert){
                Case cs = caseMap.get(c.Email);
                cs.ContactId = c.id;
                if(c.AccountId != null)
                {
                    cs.AccountId = c.AccountId;
                }
                else if(c.AccountId == null)
                {
                    cs.AccountId = contactToaccMap.get(c.Email);
                    c.AccountId = contactToaccMap.get(c.Email);
                }
            }
            
            update contListToInsert;
        }
    }
}