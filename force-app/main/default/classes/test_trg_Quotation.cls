@istest
public class test_trg_Quotation {
    
    @istest
    public static void testQuotemethod()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsQuotationTrgActivated__c=true;
        insert mc;
        
        Quotation__c q=new Quotation__c();
        //q.CC_Status__c='';
        q.Approver_Email__c='ram@test.com';
        q.Comments__c='dfgd';
        q.Total_Price__c=120.00;
        insert q;
       
        contact con=new contact();
        con.LastName='Shinde';
        con.MailingPostalCode='400001';
        con.Prospect_Interest_Type__c='Quotation';
        insert con;
         q.Customer_Contact__c=con.id;
        update q;
        
        Product__c pr=new Product__c();
        pr.SKU__c='AD.GA.195902';
        pr.Quotation__c=q.id;
        pr.Quantity__c='10';
        insert pr;
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',IB_SKU__c='AD.GA.195902',IDH__c='AD.GA.195902',isactive=true);
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        	PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
          
        );
        Insert pbe;
          q.CC_Status__c='mql';
        // q.Contact_Pincode__c='343';
        update q;
       
    }
     @istest
    public static void testQuotemethodtwo()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsQuotationTrgActivated__c=true;
        insert mc;
        
        Quotation__c q=new Quotation__c();
        //q.CC_Status__c='';
        q.Approver_Email__c='ram@test.com';
        q.Comments__c='dfgd';
        q.Total_Price__c=120.00;
        insert q;
       
        lead le=new lead();
        le.LastName='Shinde';
        le.PostalCode='400001';
        le.Prospect_Interest_Type__c='Quotation';
        le.Company='Nanostuffs';
        insert le;
         q.Lead_Name__c=le.id;
        update q;
        Product__c pr=new Product__c();
        pr.SKU__c='AD.GA.195902';
        pr.Quotation__c=q.id;
        pr.Quantity__c='10';
        insert pr;
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',IB_SKU__c='AD.GA.195902',IDH__c='AD.GA.195902',isactive=true);
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
          
        );
        Insert pbe;
        
        
        
        Opportunity opp=new Opportunity();
        opp.name='test';
        opp.amount=100;
        opp.CloseDate=system.today();
        opp.StageName='closed Won';
        Insert opp;
        
        OpportunityLineItem oppl =new OpportunityLineItem();
        oppl.UnitPrice=10;
        oppl.Product2Id=pro.id;
        oppl.OpportunityId=opp.id;
        oppl.PricebookEntryId=pbe.id;
        oppl.Quantity=5;
        insert oppl;
        
        
          q.CC_Status__c='mql';
        // q.Contact_Pincode__c='343';
        update q;
       
    }
}