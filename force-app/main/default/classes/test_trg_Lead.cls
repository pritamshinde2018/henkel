@isTest
public class test_trg_Lead 
{
    /*@isTest
	public static void test_method1()
    {
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Prospect_Interest_Type__c = 'Sample Requested';
        l1.LeadSource = 'Facebook';
        l1.Postalcode='411011';
        l1.Number_of_Employees_Custom__c='0-20';
        l1.Industry='Chemical';
        l1.pi__score__c=50;
        l1.Lead_classification_basis_value__c='A';
        insert l1;
        
        l1.pi__score__c=80;
        l1.Lead_classification_basis_value__c='C';
        update l1;
        lead l2 = new lead();
        l2.lastname = 'Unknown';
        l2.Company = 'Unknown';
        l2.email = 'testunknown@gmail.com';
        l2.Phone = '8974587878';
        l2.Prospect_Interest_Type__c = 'Sample Requested';
        l2.LeadSource = 'Facebook';
        l2.Postalcode='411011';
        l2.Number_of_Employees_Custom__c='0-20';
        l2.Industry='Chemical';
        l2.pi__score__c=20;
        l2.Lead_classification_basis_value__c='B';
        insert l2;
        
        l2.Lead_classification_basis_value__c='A';
        l2.pi__score__c=80;
        update l2;
        
        lead l3 = new lead();
        l3.lastname = 'Unknown';
        l3.Company = 'Unknown';
        l3.email = 'testunknown@gmail.com';
        l3.Phone = '8974587878';
        l3.Prospect_Interest_Type__c = 'Sample Requested';
        l3.LeadSource = 'Facebook';
        l3.Postalcode='411011';
        l3.Number_of_Employees_Custom__c='0-20';
        l3.Industry='Chemical';
        l3.pi__score__c=20;
        l3.Lead_classification_basis_value__c='C';
        insert l3;
        
        l3.Lead_classification_basis_value__c='D';
        l3.pi__score__c=40;
        update l3;
        
        lead l4 = new lead();
        l4.lastname = 'Unknown';
        l4.Company = 'Unknown';
        l4.email = 'testunknown@gmail.com';
        l4.Phone = '8974587878';
        l4.Prospect_Interest_Type__c = 'Sample Requested';
        l4.LeadSource = 'Facebook';
        l4.Postalcode='411011';
        l4.Number_of_Employees_Custom__c='0-20';
        l4.Industry='Chemical';
        l4.pi__score__c=20;
        l4.Lead_classification_basis_value__c='D';
        insert l4;
        
        l4.Lead_classification_basis_value__c='C';
        l4.pi__score__c=40;
        update l4;
        
        lead l5 = new lead();
        l5.lastname = 'Unknown';
        l5.Company = 'Unknown';
        l5.email = 'testunknown@gmail.com';
        l5.Phone = '8974587878';
        l5.Prospect_Interest_Type__c = 'Sample Requested';
        l5.LeadSource = 'Facebook';
        l5.Postalcode='411011';
        l5.Number_of_Employees_Custom__c='0-20';
        l5.Industry='Chemical';
        l5.pi__score__c=70;
        l5.Lead_classification_basis_value__c='C';
        insert l5;
        
        l5.Lead_classification_basis_value__c='D';
        l5.pi__score__c=100;
        update l5;
        
        lead l6 = new lead();
        l6.lastname = 'Unknown';
        l6.Company = 'Unknown';
        l6.email = 'testunknown@gmail.com';
        l6.Phone = '8974587878';
        l6.Prospect_Interest_Type__c = 'Sample Requested';
        l6.LeadSource = 'Facebook';
        l6.Postalcode='411011';
        l6.Number_of_Employees_Custom__c='0-20';
        l6.Industry='Chemical';
        l6.pi__score__c=20;
        l6.Lead_classification_basis_value__c='A';
        insert l6;
        
        l6.Lead_classification_basis_value__c='B';
        l6.pi__score__c=80;
        update l6;
    }*/
    
    @isTest
    public static void testLeadTrigger2()
    {
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
         mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        List<Group> g = [Select id from group where name='SalesTeam'];
        System.debug('g '+g);
        List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.LeadSource = 'IndiaMart';
        l1.Postalcode='411011';
        l1.Indiamart_ID__c = '315380153';
        l1.Indiamart_QTYPE__c = 'PNS';
        l1.Subject__c = 'Buyer Call';
        l1.QUERY_MODID__c = 'DIRECT';
        l1.Date_Of_Enquiry__c = '26 Jul 2021';
        l1.Time_Of_Enquiry__c = '26-Jul-2021 02:19:28 PM';
        insert l1; 
        
        lead l2 = new lead();
        l2.lastname = 'Unknown1';
        l2.Company = 'Unknown1';
        l2.email = 'testunknown1@gmail.com';
        l2.Phone = '8974587877';
        l2.Flag_Webinar__c = true;
        l2.LeadSource = 'tradeindia';
        l2.Ecom_Source__c = 'DialB2B';
        l2.Postalcode='411011';
        l2.Indiamart_ID__c = '315380154';
        l2.Indiamart_QTYPE__c = 'PNS';
        l2.Date_Of_Enquiry__c = '26 Jul 2021';
        l2.Time_Of_Enquiry__c = '26-Jul-2021 02:19:28 PM';
        insert l2; 
    }
}