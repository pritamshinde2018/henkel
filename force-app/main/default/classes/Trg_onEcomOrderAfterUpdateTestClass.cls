@isTest
public class Trg_onEcomOrderAfterUpdateTestClass {
 
    @isTest
    public static void testOrderStatusUpdate()
    {
       EcomAPI__c mc =new EcomAPI__c();
       mc.IsneworderTrgActivated__c=true;
       insert mc;
       Order_Information__c ord = New Order_Information__c();
       ord.Name='1234';
       ord.Shipping_Pincode__c='400006';
       ord.Payment_Status__c='Order Placed';
       ord.Billing_Pincode__c='201001';
       insert ord;
       ord.Payment_Status__c='RTO';
       ord.Payment_Status__c='delivered';
       update ord;
    }
}