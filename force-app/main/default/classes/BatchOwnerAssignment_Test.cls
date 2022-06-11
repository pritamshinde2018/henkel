@istest
public class BatchOwnerAssignment_Test {
	@istest
    public static void ownerAssignmentTest()
    {
        List<lead> leadList = new List<lead>();
        for(integer i = 0; i < 100; i++)
        {
            Lead l = new Lead();
            l.LastName = 'test Name' + i;
            l.Company = 'demo' + i;
            l.Email = 'test.Name' + i + '@demo.com';
            l.Prospect_Interest_Type__c = 'Sample Requested';
            l.PostalCode = '110001';
            l.Phone = '8454841848';
            leadList.add(l);
        }
        
        insert leadList;
        
        List<cta__c> ctaList = new List<cta__c>();
        ctaList = [SELECT Id, OwnerId, cta_stage__c, RecordTypeId, Customer_Number__c, Indiamart_QTYPE__c,lead__c FROM CTA__c where lead__c =: leadList];
        
        
        for(Cta__c cta : ctaList)
        {
            cta.OwnerId = '0057F0000011TdL';
        }
        update ctaList;
        
        Test.startTest();
        BatchOwnerAssignment bc = new BatchOwnerAssignment();
        database.executeBatch(bc);
        
        ScheduleBatchOwnerAssignment sh1 = new ScheduleBatchOwnerAssignment();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch,sh1);
        Test.stopTest();
        
        List<cta__c> updatedCtaList = new List<cta__c>();
        updatedCtaList = [SELECT Id, OwnerId, cta_stage__c, RecordTypeId, Customer_Number__c, Indiamart_QTYPE__c,lead__c FROM CTA__c where lead__c =: leadList];
        
        integer count = 0;
        for(Cta__c cta : updatedCtaList)
        {
            if(cta.OwnerId != '0057F0000011TdL')
            {
                count = count + 1;
            }
        }
        
        System.assertEquals(100,count);
    }
}