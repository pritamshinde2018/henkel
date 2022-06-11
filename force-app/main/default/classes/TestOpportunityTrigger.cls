@isTest
public class TestOpportunityTrigger{
    @isTest
    public static void testOpportunityTrigger(){
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.trg_OnProjectBeforeUpdate__c=true;
        Insert mc;
        Test.startTest();
            Account acc = new Account(name='test1',Industry='Banking');
            insert acc;
            Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
            insert c;
            Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Sample Sent/Inquiry Received',CloseDate = System.today(),Name='test');
            insert opp;
        
        List<Opportunity> opp11=[Select id,name from Opportunity where Id=:opp.Id];
        if(opp11.size()>0)
        {
        opp11[0].name='test123';
        update opp11;
        }
        
        Test.stopTest();
    }
}