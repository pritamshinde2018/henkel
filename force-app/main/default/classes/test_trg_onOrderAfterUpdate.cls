@isTest
public class test_trg_onOrderAfterUpdate 
{
    @isTest
    public static void testMethos1()
    {
        EcomAPI__c mc=new EcomAPI__c();
        mc.IsecomordertrgActivated__c=true;
        insert mc;
            
		Order_Information__c ord =new Order_Information__c();
    	ord.Name='123456';
       	Insert ord;
        ord.IndustryBuying_Status__c='Confirmed';
        ord.Payment_Status__c ='Order Placed';
        ord.PlaceEmail__c=false;
        update ord;
    }
}