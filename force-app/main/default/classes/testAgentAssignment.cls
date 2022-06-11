@isTest
public class testAgentAssignment 
{
		static testmethod void testmethod1()
        {
           Contact cnt=new Contact();
           cnt.LastName='test123';
           cnt.email = 'test@testemail.com';
           Insert cnt;
           Profile p = [SELECT Id FROM Profile WHERE Name='CC Agents'];  
           User u = new User(Alias ='abct1', Email='abc@testorg.com', 
           EmailEncodingKey='UTF-8', LastName='abc', LanguageLocaleKey='en_US', 
           LocaleSidKey='en_US',ProfileId=p.Id, 
           TimeZoneSidKey='America/Los_Angeles', UserName='abc654123@testq.com');
		   Insert u;
           User u1 = new User(Alias = 't', Email='a@t.com', 
           EmailEncodingKey='UTF-8', LastName='rtesUser', LanguageLocaleKey='en_US', 
           LocaleSidKey='en_US', ProfileId = p.Id, 
           TimeZoneSidKey='America/Los_Angeles', UserName='pqr1235@testm.com');
		   Insert u1;
           Lead lObj=new Lead();
           lObj.LastName='demo';
           lObj.Company='Nano';
           lObj.OwnerId=u.id;
           Insert lObj;
           Lead lObj1=new Lead();
           lObj1.LastName='demo';
           lObj1.Company='Nano';
           lObj1.pi__created_date__c=Date.newInstance(2020,08,15);
           lObj1.Prospect_Interest_Type__c='Sample Requested';
           lObj1.pi__campaign__c = 'Send Sample'; 
           Insert lObj1;
           Lead lObj2=new Lead();
           lObj2.LastName='demo';
           lObj2.Company='Nano';
           //lobj2.Indiamart_ID__c='1235124';
           lObj2.pi__created_date__c=Date.newInstance(2020,08,15);
           lobj2.Prospect_Interest_Type__c='GM Design Guide';
           lobj2.CC_Qualification__c = 'Yes';
           Insert lObj2;
           Lead lObj3=new Lead();
           lObj3.LastName='demo';
           lObj3.Company='Nano';
           //lobj2.Indiamart_ID__c='1235124';
           lObj3.pi__created_date__c=Date.newInstance(2020,08,15);
           lObj3.Prospect_Interest_Type__c='Webinar';
           lObj3.Flag_Webinar__c = true;
           lObj3.CC_Qualification__c = 'Yes';
           Insert lObj3;
           Test.startTest();
           agentAssignment ag1 = new agentAssignment();
           String sch = '0 0 23 * * ?';
           system.schedule('Test Agent Assignment',sch,ag1);  
           Test.stopTest();
        }
}