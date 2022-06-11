@isTest(SeeAllData=true)
public class TestClass {
    @isTest static void testFunction()
    {
        Test.startTest();
        Secondary_Sales_Data__c c = new Secondary_Sales_Data__c();    
        
        c.Dec_19__c = 1000;        
        c.Sales_Data__c = 'Value';
        c.Quantity__c = 1;
        insert c;
        c.Sales_Data__c = 'Quantity';
      //  c.Sep_18__c = 2000;
        update c;
       
        Test.stopTest();
        
    }
    
}