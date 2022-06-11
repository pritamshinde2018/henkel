@isTest
private class TriggerOnTaskTest 
{
    private static testmethod void TestTask()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.trg_OnTaskBeforeUpdate__c=true;
        insert mc;
        Account acct = new Account(Name='Test Account');
        insert acct;
        Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                          StageName='Prospecting',
                                          CloseDate=System.today().addMonths(1),
                                          AccountId=acct.Id);
        insert opp;
        Task t = new Task(Subject='Test trigger',Status='Completed');
        insert t;
        List<Task> tList=[Select id,subject from Task where subject='Test trigger'];
        tList[0].subject='Test';
        update tList;
 	}
}