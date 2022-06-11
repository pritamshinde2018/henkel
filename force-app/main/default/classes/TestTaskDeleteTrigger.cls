@isTest
public class TestTaskDeleteTrigger{
    @isTest
    public static void testTaskDeleteTrigger(){
        EcomAPI__c mc =new EcomAPI__c();
       	mc.trg_OnTaskAfterInsertUpdate__c=true;
        mc.trg_OnTaskBeforeUpdate__c=true;
        Insert mc;
        
       /*EcomAPI__c mc1 =new EcomAPI__c();
       	
        Insert mc1;*/
        
        
        
        User u = [SELECT id FROM User Where isActive = true  Limit 1];
        Test.startTest();
            Task t = new Task(Subject = 'call',Status='open',OwnerId = u.id);
            insert t;
        
        t.status='Completed';
        update t;
           // Delete t;
        Test.stopTest();
    }
}