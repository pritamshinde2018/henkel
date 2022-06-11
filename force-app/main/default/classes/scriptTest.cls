@isTEst
public class scriptTest {

    static testMEthod void getDataTest(){
        Account acc = new Account();
        acc.Name = 'testAccount';      
        insert acc;
        
        
        Contact con = new Contact();
        con.lastName = 'testClassData';
        con.Email = 'testusha@gmail.com';
        con.AccountId = acc.Id;
        con.zipcode__c = '411046';
        
        insert con;

        
        Products_on_Cart__c product = new Products_on_Cart__c();
        product.Name = 'Loctite 577 - 50 ml';
        product.Price__c = '676.00';
        product.Category__c = 'Thread Sealants';
        product.Size__c = '50 ml';
        product.Quanitity__c = '1';
        product.Customer_Contact__c = con.Id;
        product.sku__c = 'AD.TH1.195885';
        product.Active__c = true;
        insert product;

        

        Contact cont = [select Id, Name, AccountId from Contact where Id =: con.Id];
        List<Products_on_Cart__c> pr = [select Id, Customer_Contact__c from Products_on_Cart__c where Customer_Contact__c =: cont.Id];
        
        if(!pr.isEmpty()){
            Opportunity opp = new Opportunity();
            opp.Contact2__c = cont.Id;
            opp.AccountId = cont.AccountId;
            opp.Name = 'DG-AG-SU-Product-Application';
            opp.StageName = 'Sample Sent/Inquiry Received';
            opp.Probability = 15;
            opp.CloseDate = Date.Today().addDays(60);
            opp.Status__c = 'Active';
            opp.Assigned_IST_User__c = '0057F0000011Dlq';
            opp.Flag_Product_Check__c = true;
            opp.Flag_abandoned_cart__c = true;
            insert opp;
        }
        
        Test.startTest();
        script.getData();
        
        
        Test.stopTest();
        
        
        
    }
}