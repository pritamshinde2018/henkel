@isTest
public class testEcommerceContacts 
{
    @isTest
	public static void testMethod1()
    {
        Contact ct=new Contact();
        ct.LastName='test';
        Insert ct;
        EcommerceContacts.getselectOptions(ct,'Number_of_Employees_Custom__c');
        EcommerceContacts.findselectOptions(ct,'Number_of_Employees_Custom__c');
        EcommerceContacts.selectOptions(ct,'Number_of_Employees_Custom__c');
        EcommerceContacts.selectIndustryOptions();
        EcommerceContacts.fetchAccount(1,5);
        //EcommerceContacts.saveAccount();
   }
}