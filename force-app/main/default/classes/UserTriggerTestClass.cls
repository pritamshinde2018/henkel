@isTest
public class UserTriggerTestClass {
    
    public static testmethod void TestOppoffer()
    {
        Account a= new Account(Name = 'Test Account'); 
        insert a;
        
        Contact c= new Contact(LastName = 'Test Contact',mailingPostalCode = '111111',MailingStreet = 'TestStreet',
                               MailingCity='TestCity',MailingState='TestState',MailingCountry='TestCountry');
        insert c;
        
        Opportunity op = new Opportunity(Name = 'Test opp',AccountID = a.id,Contact2__c = c.id,
                                         CloseDate = system.today(),stageName='New',Pincode_Status__c = '2');
        insert op;
        
        Opportunity op1 = new Opportunity(Name = 'Test opp1',AccountID = a.id,Contact2__c = c.id,
                                          CloseDate = system.today(),stageName='New',Pincode_Status__c = '2');
        insert op1;
        
        Offer__c offer = new Offer__c(First_Name__c = 'Test',Pincode_Status__c = '2',Customer_Contact__c = c.id);
        insert offer;
        
        Offer__c offer1 = new Offer__c(First_Name__c = 'Test1',Pincode_Status__c = '2',Customer_Contact__c = c.id);
        insert offer1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='test@User.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testHenkal@Henkal.com',Pin_codes__c= '1111111');
        insert u;
        
        u.Pin_codes__c = '1111111 123445 234123';
        update u;
    }
}