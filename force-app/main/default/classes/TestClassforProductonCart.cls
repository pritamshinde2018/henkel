@isTest
public class TestClassforProductonCart 
{
	public static testmethod void method1()
    {
        Products_In_Cart p =new Products_In_Cart();
		database.executeBatch(p);
    }
}