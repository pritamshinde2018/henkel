@isTest
public class Testreport_dailyReports {
    public testmethod static void dailyreport()
    {
        Account acc = new Account(Name = 'TestAccount');
        Lead l = new lead(LastName = 'Test1' ,Company = 'TestCompany',CC_Status__c = NULL,Which_product_sent__c = 'LOCTITE Threadlocker 243',What_is_the_purpose_use__c = 'Maintenance of Machinery or Facility',Number_of_Employees_Custom__c = '0-20');
        Contact con = new Contact(Lastname = 'Test1',CC_Status__c = NULL,Number_of_Employees_Custom__c = '0-20');
        Opportunity opp = new Opportunity(Name = 'New opportunity',StageName = 'Sample Sent/Inquire Received',First_Order_Supply_Date__c = Date.newInstance(2018, 12, 22) , AccountID = acc.ID,CloseDate = Date.newInstance(2018, 12, 28));
        insert acc;
        insert con;
        insert l;
        insert opp;
        report_dailyReports repobj =  new report_dailyReports();
        
        
        
    }
}