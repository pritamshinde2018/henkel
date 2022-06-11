@isTest
private class MilestoneTest {
    
    static testMethod void TestCompleteMilestoneCase(){
        
        List<Account> acts = new List<Account>();
        Account myAcc = new Account(Name='TestAct', phone='1001231234');
        acts.add(myAcc);
        
        Account busAcc = new Account(Name = 'TestForMS', phone='4567890999');
        acts.add(busAcc);
        insert acts;
        Contact cont = new Contact(FirstName = 'Test', LastName = 'LastName', phone='4567890999', accountid = busAcc.id);
        insert(cont);
        
        Id contactId = cont.Id;
        
        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=busAcc.Id,SlaProcessId='5527F0000009HzDQAU');
        insert entl;
        
        String entlId;
        if (entl != null)
            entlId = entl.Id; 
        Case cs = new Case();
        cs.SuppliedName = 'test_demo';
        cs.SuppliedEmail = 'Test@demo.com';
       // cs.ContactId = cont.Id;
        cs.Origin = 'Email';
        cs.Status = 'Closed';
        cs.Enquiry_Type__c = 'Product/Tech Enquiry';
      //  cs.EntitlementId=entl.id;
       
        
//        cs.SlaStartDate = system.now() - 5;
        insert cs;
        List<Case> cases = new List<Case>{};
            if (entlId != null){
                Case c = new Case(Subject = 'Test Case with Entitlement ', 
                                  EntitlementId = entlId, ContactId = contactId);
                cases.add(c);
            }
        if (cases.isEmpty()==false){
            insert cases;
            List<Id> caseIds = new List<Id>();
            for (Case cL : cases){
                caseIds.add(cL.Id);
            }
            milestoneUtils.completeMilestone(caseIds, 'Resolution Time', System.now());
        }
    } 
    
   /* static testMethod void testCompleteMilestoneViaCase(){
        
        List<Account> acts = new List<Account>();
        Account myAcc = new Account(Name='TestAct', phone='1001231234');
        acts.add(myAcc);
        
        Account busAcc = new Account(Name = 'TestForMS', phone='4567890999');
        acts.add(busAcc);
        insert acts;
        Contact cont = new Contact(FirstName = 'Test', LastName = 'LastName', phone='4567890999', accountid = busAcc.id);
        insert(cont);
        
        Id contactId = cont.Id;
        
        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=busAcc.Id);
        insert entl;
        
        String entlId;
        if (entl != null)
            entlId = entl.Id; 
        
        List<Case> cases = new List<Case>{};
            for(Integer i = 0; i < 1; i++){
                Case c = new Case(Subject = 'Test Case ' + i);
                cases.add(c);
                if (entlId != null){
                    c = new Case(Subject = 'Test Case with Entitlement ' + i, 
                                 EntitlementId = entlId);
                    cases.add(c);
                }
            }
    } */
    @isTest
    public static void testMethod1()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsecomordertrgActivated__c=true;
        insert mc;
        
        /*Account acc = new Account();
        acc.Name = 'test';
        acc.Email__c = 'Test@demo.com';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.Email = acc.Email__c;
        con.AccountId = acc.id;
        insert con;*/
        
        Case cs = new Case();
        cs.Company__c = 'demo';
        cs.SuppliedName = 'test_demo';
        cs.SuppliedEmail = 'Test@demo.com';
        //cs.ContactId = con.Id;
        cs.Origin = 'Email';
        cs.Status = 'open';
        cs.Enquiry_Type__c = 'Product/Tech Enquiry';
        cs.Phone__c = '9898181818';
        cs.Industry__c = '2-wheeler repair';
       // cs.Prospect_Interest_Type__c = 'Mail enquiry';
        cs.No_of_Employees__c = '0-20';
        cs.Pin_code__c = 411046;
        cs.SlaStartDate = system.now() - 5;
        insert cs;
        cs.Status = 'Closed';
        update cs;
        
    }
}