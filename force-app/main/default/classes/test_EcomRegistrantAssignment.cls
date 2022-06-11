@isTest
public class test_EcomRegistrantAssignment 
{
    @isTest
	public static void testMethod1()
    {
        Contact cnt=new Contact();
        cnt.FirstName='testfirst';
        cnt.LastName='testLast';
        Datetime dt=System.today();
       Datetime dt2=dt.addHours(4);
        cnt.CreatedDate=dt2;
        cnt.MailingPostalCode='400001';
        cnt.Ecom_Registration__c=true;
        Insert cnt;
        System.debug('cnt---- '+cnt.id);
        Contact cnt1=[Select id,number_of_minutes_from_Creation__c from contact where id= : cnt.Id];
        System.debug('cnt.creation---- '+cnt1.number_of_minutes_from_Creation__c);
        
        /*Opportunity opp=new Opportunity();
        opp.name='test Opportunity';
        opp.Contact2__c=cnt.Id;
        opp.StageName='Sample Sent/Inquiry Received';
        opp.CloseDate=system.today();
        Insert opp;*/
        
        Test.startTest();
        EcomRegistrantsAssignments ecom = new EcomRegistrantsAssignments();
        String sch = '0 0 23 * * ?';
        system.schedule('EcomRegistrantsAssignments --',sch,ecom);
        Test.stopTest();
        
    }
}