@isTest
public class Test_CaseTrigger 
{
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
    
     @isTest
    public static void testMethod2()
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
        Lead ld = new Lead();
        ld.Email = 'Test@demo.com';
        ld.LastName = 'test';
        ld.Company = 'demo';
        insert ld;
        
        Case cs = new Case();
        
        cs.SuppliedName = 'test_demo';
        cs.SuppliedEmail = 'Test@demo.com';
        //cs.ContactId = con.Id;
        cs.Origin = 'Email';
        cs.Status = 'open';
        cs.Enquiry_Type__c = 'Product/Tech Enquiry';
        
       // cs.Prospect_Interest_Type__c = 'Mail enquiry';
        
        cs.SlaStartDate = system.now() - 5;
        insert cs;
        cs.Company__c = 'demo';
        cs.Phone__c = '9898181818';
        cs.Industry__c = '2-wheeler repair';
        cs.No_of_Employees__c = '0-20';
        cs.Pin_code__c = 411046;
        cs.Prospect_Interest_Type__c = 'Mail enquiry';
        update cs;
        
        //ApexPages.currentPage().getParameters().put('myparam',',demo,9898181818,2-wheeler repair,0-20,411046,Mail enquiry,'+cs.id);
        //AssignToCreateLeadForISTTeam leadCreate = new AssignToCreateLeadForISTTeam();
        AssignToCreateLeadForISTTeam.CreateLeadAndAssign(cs.Id);
    }
    
}