@isTest
public class testclassforscheduleprodcart 
{
    public static testmethod void  testMethod11()
    {
        Test.startTest();
           scheduleProductOncart ag1 = new scheduleProductOncart();
           String sch = '0 0 23 * * ?';
           system.schedule('Test Agent Assignment',sch,ag1);  
           Test.stopTest();
    }
}