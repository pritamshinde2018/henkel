@isTest
public class testProjectSourceMappingTrigger 
{
    @isTest
	public static void testMethod1()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.ProjectSourceMappingTrigger__c=true;
        Insert mc;
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Actual_Closing_date__c=System.today(),Prospect_Interest_Type__c='E-Commerce',Contact2__c = c.id,AccountId = acc.id,StageName = 'Maintaining/Closing',CloseDate = System.today(),Name='test');
        insert opp;
        Project_Source_Mapping__c pr=new Project_Source_Mapping__c();
        pr.Name='E-Commerce(Stage100 )';
        pr.Priority__c='01';
        Insert pr;
        pr.Priority__c='02';
        update pr;
    }
}