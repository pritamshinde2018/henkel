@isTest(seeAllData = false)
public class TestPopulateBlueDartInfo{
    @isTest
    public static void testPopulateBlueDartInfo(){
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalCode = '110002', MailingCountry='India',AccountId=acc.id);
        c.Waybill_No__c = '40021792694';
        insert c;
        Opportunity opp = new Opportunity(stageName = 'Sample Sent',CloseDate = System.today()+1,Name = 'test',Contact2__c = c.id,AccountId = acc.id,Prospect_Interest_Type__c='Sample Requested',Pincode_Status__c = '1');
        opp.AccountId = acc.id;
        opp.Waybill_No__c = '40021792694';
        insert opp;
        
        Lead led=new Lead();
        led.lastname='company';
        led.Company='test Company';
        led.Waybill_No__c='6541649';
        insert led;
        
        CTA__c c1 = new CTA__c();
        c1.RecordTypeId=Label.CTA_Sampling_RecordTypeId;
        c1.Waybill_No__c='40031853540';
        c1.Import_throught_dataloader__c=false;
        c1.Sample_Sent_On__c=system.today();
        insert c1;
        
        Test.startTest();
        PopulateBlueDartInfo ctrl = new PopulateBlueDartInfo();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Agent Assignment',sch,ctrl);
        
        PopulateBlueDartInfo_Lead ctrl1 = new PopulateBlueDartInfo_Lead();
        String sch1 = '0 0 23 * * ?';
        system.schedule('Test Agent Assignment1',sch1,ctrl1);
        
        PopulateBlueDartInfo_Contact ctrl2 = new PopulateBlueDartInfo_Contact();
        String sch2 = '0 0 23 * * ?';
        system.schedule('Test Agent Assignment2',sch2,ctrl2);
        
        
        PopulateBlueDartInfo_CTA ctrl3  = new PopulateBlueDartInfo_CTA();
        String sch3 = '0 0 23 * * ?';
        system.schedule('Test Agent Assignment3',sch3,ctrl3);
        Test.stopTest();
    }
}