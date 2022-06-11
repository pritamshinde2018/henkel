@isTest
public class testMapLeadwithContact {
    
     @isTest
    public static void testPopulateBlueDartInfo(){
        
        Account acc = New Account();
        acc.Name = 'testaccount';
        
        insert acc;
        
        Contact cnt=new Contact();
        cnt.lastname='testContact';
        cnt.AccountId=acc.id;
        insert cnt;
        
        contact cnt1=[Select id,Contact_Sr_No__c from contact where id=: cnt.Id];
        system.debug('cnt1---- '+cnt1.Contact_Sr_No__c);
        
        Lead l=new Lead();
        l.LastName='test';
        l.Company='testCompany';
        l.Contact_Sr_No__c=cnt1.Contact_Sr_No__c;
        
        insert l;
        
        Database.executeBatch(new mapLeadswithContacts());
    }

}