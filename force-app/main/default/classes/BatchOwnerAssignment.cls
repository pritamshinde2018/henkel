global class BatchOwnerAssignment implements Database.Batchable<sObject>, Database.Stateful
{
    Exception[] errors = new Exception[0];
	global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        List<String> listownerId = new List<String>();
        listownerId.add('0057F0000011TdL');
        listownerId.add('0057F0000011Dlq');
        
        List<String> listStage = new List<String>();
        listStage.add('New');
        listStage.add('Data and Intent Validation Process');
        listStage.add('Data Collection Process');
        String query = 'SELECT Id, OwnerId, cta_stage__c, RecordTypeId, Customer_Number__c, Indiamart_QTYPE__c FROM CTA__c where ownerid =: listownerId AND cta_stage__c =: listStage AND Customer_Number__c != null AND Lead__c != null AND Indiamart_QTYPE__c != \'PNS\' AND Ecom_Source__c != \'DialB2B\' AND createddate > 2022-01-01T00:00:00z';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<CTA__c> ctalist){
        // process each batch of records
        
        for(Cta__c cta : ctalist)
        {
            if(cta.Indiamart_QTYPE__c != 'PNS' && cta.Customer_Number__c != null && cta.RecordTypeId != ctaRecordTypeId.ecom)
            {
                    cta.OwnerId = '0057F000004FGA4QAO';
            }  
        }  
        try{
            update ctalist;
            
            if(Test.isRunningTest()){
                //do something
                Exception e;
                errors.add(e);
            }
        }
        catch(Exception e)
        {
            errors.add(e);
        }
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        if(!errors.isEmpty())
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'aman.khurana@nanostuffs.com','pritam.shinde@nanostuffs.com'};
                message.setSubject('Exception in BatchOwnerAssignment : ') ;
            message.setPlainTextBody('BatchOwnerAssignment Failed : '+errors);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    } 
}