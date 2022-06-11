@isTest
public class testApplicationComponent 
{
     @isTest
     public static void testmethod1()
     {
         Contact cnt=new Contact();
         cnt.lastname='test';
         cnt.Industry__c='testindustry';
         insert cnt;
         
         Application_Potential__c app=new Application_Potential__c();
         app.Cleaners__c=12;
         app.Industry__c='testindustry';
         app.Equipment__c=10;
         app.Functional_Coatings__c=20;
         app.Instant_Adhesives__c=2;
         app.Machinery_Adhesives__c=6;
         app.Potting_Impregnation__c=3;
         app.Sealing__c=10;
         app.Structural_Bonding__c=45;
         app.Protective_Coatings__c=0;
         app.TYPICAL_DEVICES__c='test record';   
         insert app;
        // applicationPotentialcontroller.wrapperClassforCoverageReport wrp=new applicationPotentialcontroller.wrapperClassforCoverageReport();
         applicationPotentialcontroller.getapplicationPotential(cnt.Id,'Contact');
             
             
     }
}