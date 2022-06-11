/*
 * test Class for : trg_customizePrice
*/
@istest
public class test_trg_customizePrice {
    @istest
    public static void testcustomizePricemethod()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsCustomizedPricetriggerActivated__c=true;
        insert mc;
        Customized_Price__c q=new Customized_Price__c();
        //q.CC_Status__c='';
       // q.Name='ram@test.com';
       // q.SKU='dfgd';
       // q.Total_Price__c='120';
        q.SKU__c='AD.GA.195902';
        insert q;
       
        contact con=new contact();
        con.LastName='Shinde';
        con.MailingPostalCode='400001';
        con.Prospect_Interest_Type__c='Quotation';
        insert con;
         q.Contact_Name__c=con.id;
        update q;
        
        
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
        //update q;
       
    }
     @istest
    public static void testcustomizePricemethodtwo()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsCustomizedPricetriggerActivated__c=true;
        insert mc;
      Customized_Price__c q=new Customized_Price__c();
        //q.CC_Status__c='';
       // q.Name='ram@test.com';
       // q.SKU='dfgd';
       // q.Total_Price__c='120';
        q.SKU__c='AD.GA.195902';
        insert q;
       
        lead le=new lead();
        le.LastName='Shinde';
        le.PostalCode='400001';
        le.Prospect_Interest_Type__c='Quotation';
        le.Company='Nanostuffs';
        insert le;
         q.Lead_Name__c=le.id;
        update q;
        
        Quotation__c quote=new Quotation__c();
        quote.Lead_Name__c=le.id;
        Insert quote;
        
        Refer_Friend__c r=new Refer_Friend__c();
        r.Lead_Name__c=le.Id;
        Insert r;
        
        Request__c req=new Request__c();
        req.Lead_Name__c=le.id;
        Insert req;
        
        
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


}