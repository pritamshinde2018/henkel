@isTest
public class TestEcomContactAssignment {
 @isTest
    public static void testcontactassignment()
    {
        Contact c = new Contact();
        c.LastName = 'TestEcomAssignement';
        insert c;
        
        Contact c2 = new Contact();
        c2.LastName = 'TestEcomAssignement2';
        insert c2;
        
        Test.startTest();
        EcomContactAssignment ecom = new EcomContactAssignment();
        String sch = '0 0 23 * * ?';
        system.schedule('ecomOrdersAssignment --',sch,ecom);
        Test.stopTest();
    }
}