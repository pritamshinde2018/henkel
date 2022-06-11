@isTest(SeeAllData=true)
public class Testclass_AftershipTracking {
 
   
        
        /*Account a=new Account();
        RecordType rt= [SELECT Id, Name FROM RecordType where Name='Customers' Limit 1];
        a.RecordTypeId= rt.Id;
        a.Name='Test Account';
        insert a; 
         
         Contact c = new Contact();
         c.LastName ='test';
         insert c;
         
           Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.AccountId = a.Id;
        // opp.Courier_Company__c = 'India Post';
         opp.Waybill_No__c ='ED757670038IN';
        insert opp;*/
        
             
       
    
 
     @isTest static void  testschedule() 
     {
         Test.StartTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2()); 
        AftershipTrackingAPI exp = new AftershipTrackingAPI();
         String sch = '0 05 11 * * ?';
        system.schedule('Report test',sch,exp);
        Test.stopTest();
    }

}