@isTest
public class Test_trg_onOrder_Attachment {
  @isTest
    Public static void test_trg_onOrder_Attachment1()
    {
        
        EcomAPI__c e=new EcomAPI__c();
        e.trg_onOrder_Attachment__c=true;
        insert e;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );    
        
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 pr= new Product2();
        pr.Name='Test Product';
        pr.IDH__c='000012';
        pr.DP__c=25000;
        pr.isActive = true;
        insert pr;
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = pr.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        
        
        Account a=new Account();
        RecordType rt= [SELECT Id, Name FROM RecordType where Name='Customers' Limit 1];
        a.RecordTypeId= rt.Id;
        a.Name='Test Account';
        insert a; 
        
        
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.AccountId = a.Id;
        insert opp;
        
        
        
        
        Order o=new Order();
        o.AccountId=a.Id;	
        o.OpportunityId=opp.Id;
        o.Status='Draft';
        o.EffectiveDate=Date.today();
        o.Pricebook2Id=pricebookId;
        insert o;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;  
        
         ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
         ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=o.id;
       contentlink.ShareType= 'I';
        contentlink.LinkedEntityId = o.Id; 
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;

        
        OrderItem op=new OrderItem();
        op.Product2Id=pr.Id;
        op.Quantity=1;
        op.UnitPrice=1;
        op.OrderId=o.Id;
        op.PricebookEntryId=pbEntry.id;
        
        insert op;
         Test.startTest();
        o.Status='Activated';
         update o;
        
        Test.stopTest();
    
    }
    
}