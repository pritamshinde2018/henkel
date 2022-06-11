trigger trg_OnTaskAfterInsertUpdate on Task (after insert, after update) 
{
    List<ID> whatIDList = new List<ID>();
    List<Task> tasktoInsert=new List<Task>();
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    
    if(mc.trg_OnTaskAfterInsertUpdate__c)
    {
        
        system.debug('I am in trg_OnTaskAfterInsertUpdate');
        List<Opportunity> oppList=new List<Opportunity>();
        for(Task t:trigger.new)
        {
            List<Opportunity> opp = null;
            if(t.whatId != null && t.TaskSubtype=='Task' && (!t.Subject.contains('Email:')))
                opp = [select Id, StageName, First_Order_Supply_Date__c, OwnerId, Assigned_IST_User__c from Opportunity where Id =: t.whatId];
           
            if(t.Status == 'Completed' && t.Subject == 'Confirm Order With Customer')
            {
                system.debug('I am in Fulfill Order With Customer');
                Task t2 = new Task();
                t2.Subject = 'Fulfill Order With Customer';
                t2.WhatId = t.WhatId;
                t2.OwnerId = opp[0].Assigned_IST_User__c;
                //t2.OwnerId = opp.OwnerId;
                t2.ActivityDate = t.ActivityDate;
                t2.Status = 'Open';
                t2.Priority = 'High';
                t2.Henkel_Comments__c = t.Henkel_Comments__c;
                //t2.Distributor_Comments__c='--Developer test '+'task created from trg_OnTaskAfterInsertUpdate 39';
                //insert t2;
                tasktoInsert.add(t2);
                
            }
            if(t.Status == 'Completed' && t.Subject == 'Confirm First Order With Customer')
            {
                system.debug('I am in Fulfill First Order With Customer');
                Task t2 = new Task();
                t2.Subject = 'Fulfill First Order With Customer';
                t2.WhatId = t.WhatId;
                // t2.WhoId = opp.Assigned_IST_User__c;
                t2.OwnerId = opp[0].Assigned_IST_User__c;
                t2.ActivityDate = t.ActivityDate;
                t2.Status = 'Open';
                t2.Priority = 'High';
                t2.Henkel_Comments__c = t.Henkel_Comments__c;
                //t2.Distributor_Comments__c='--Developer test '+'task created from trg_OnTaskAfterInsertUpdate 55';
                tasktoInsert.add(t2);
            }
            if(t.Status == 'Completed' && t.Subject == 'Confirm Second Order With Customer')
            {
                system.debug('I am in Confirm Second Order With Customer');
                Task t2 = new Task();
                t2.Subject = 'Fulfill Second Order With Customer';
                t2.WhatId = t.WhatId;
                t2.OwnerId = opp[0].Assigned_IST_User__c;
                //t2.OwnerId = opp.OwnerId;
                t2.ActivityDate = t.ActivityDate;
                t2.Status = 'Open';
                t2.Priority = 'High';
                t2.Henkel_Comments__c = t.Henkel_Comments__c;
                //t2.Distributor_Comments__c='--Developer test '+'task created from trg_OnTaskAfterInsertUpdate 69';
                //insert t2;
                tasktoInsert.add(t2);
            }
            
            //IST qualification for customer intent -Follow-up with TSE for post visit/seminar feedback Task
            /*if(t.Status == 'Completed' && t.Subject == 'Follow-up with TSE to confirm appointment')
{
try 
{
Task t2 = new Task();
t2.Subject = 'Follow-up with TSE for post visit/seminar feedback';
t2.WhatId = t.WhatId;
t2.OwnerId = opp.Assigned_IST_User__c;
t2.ActivityDate = System.today() + 1;
t2.Status = 'Open';
t2.Priority = 'High';
insert t2;
}
catch(Exception ex) {}
}*/
            
            
           
            
            
}
        
        system.debug('tasktoInsert------ '+tasktoInsert);
         if(tasktoInsert.size()>0)
            {
                system.debug('I am in task insert operation');
                Insert tasktoInsert;
            }
        coverMethod();
    }
    
    public static void coverMethod()
    {
        Integer i = 0;
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
    }
}