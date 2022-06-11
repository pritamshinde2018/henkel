@isTest
public class testOrderConfirmationtrigger 
{
    @isTest
	public static void testMethod1()
    {
       Test.setMock(HttpCalloutMock.class, new orderConfirmationMockcalloutClass());
       Order_Information__c ord=new Order_Information__c();
       ord.Order_Number__c='107202706';
       ord.Payment_Status__c='Booked';
       Insert ord;
        
       ord.Confirmed_Order__c=true;
       update ord;
    }
}