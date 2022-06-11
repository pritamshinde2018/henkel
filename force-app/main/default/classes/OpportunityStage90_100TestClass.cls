@isTest
public class OpportunityStage90_100TestClass {
    
    public static TestMethod void TestStageName()
    {
        Account a = new Account(Name = 'Test Account Joe ');
        
        insert a;
        
        Opportunity opp = new Opportunity(Name='TestOpportunity',AccountId=a.Id,StageName='First order Supply',CloseDate=date.parse('06/09/2018'),First_Order_Supply_Date__c=date.parse('08/09/2018'));
        insert opp;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='test@User.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testHenkal@Henkal.com',Pin_codes__c= '1111111');
        insert u;
        
        Task t = new Task(Subject='Test Trigger',WhatId=opp.Id,status='Open',Priority='High',OwnerId = u.Id);
        insert t;
        
        t.Description = 'testdesc';
        update t;
        
        opp.StageName = 'Maintaining/Closing';
        opp.MS__c = 'GM';
        opp.RecurringBusiness__c = 'One Time';
        Database.SaveResult result = Database.update(opp, false);
        //System.assertEquals('This Project has open Tasks, you need to complete all of them before changing the Stage.',result.getErrors()[0].getMessage());
    }
}