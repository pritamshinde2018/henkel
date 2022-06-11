@isTest
public class ecomOrdersAssignmentTestClass 
{
    @IsTest
    public static void testecomassignment(){
        Order_Information__c ord = New Order_Information__c();
        ord.Name = '124654';
        ord.Payment_Status__c='booked';
        ord.CreatedDate=system.today()-2;
        insert ord;
        
        Order_Information__c ord1 = New Order_Information__c();
        ord1.Name = '124654';
        ord1.Payment_Status__c='booked';
        ord1.CreatedDate=system.today()-4;
        insert ord1;
        
        Test.startTest();
        ecomOrdersAssignment ecom = new ecomOrdersAssignment();
        String sch = '0 0 23 * * ?';
        system.schedule('ecomOrdersAssignment --',sch,ecom);
        Test.stopTest();
        
        
        
    }
}