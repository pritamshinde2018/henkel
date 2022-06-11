@isTest
public class test_trg_Account 
{
    @istest
	public static void testMethod1()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.trg_Account__c=True;
        Insert mc;
        Account acc = New Account();
        acc.Name='TestIndustryCode1';
        acc.Industry='BANKING';
        Insert acc;
       // System.assertEquals(NULL,acc.Industry_Code__c);
        
    }
    public static void testMethod2()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.trg_Account__c=True;
        Insert mc;
        Account acc = New Account();
        acc.Name='TestIndustryCode1';
        //acc.Industry='BANKING';
        Insert acc;
        
    }
}