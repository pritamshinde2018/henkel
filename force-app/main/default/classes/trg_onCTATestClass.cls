@isTest
public class trg_onCTATestClass 
{
    /*@isTest
    public static void testMethod1()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='Qualified';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        
        
        Insert cta;
        
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Potential',CloseDate = System.today(),Name='test',CTA__c=cta.id);
        insert opp;
        
        cta.Ecoomerce_Qualification__c='One time eCommerce';
        update cta;
        /*cta.Ecoomerce_Qualification__c='Additional opportunity';
update cta;
cta.Ecoomerce_Qualification__c='More value for the same products'; 
update cta;
cta.Ecoomerce_Qualification__c='More value for the same products + Additional opportunity'; 
update cta;
        
    }*/
    
    /*@isTest
    public static void testMethod2()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='Qualified';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        
        
        Insert cta;
        
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Potential',CloseDate = System.today(),Name='test',CTA__c=cta.id);
        insert opp;
        
        cta.Ecoomerce_Qualification__c='Additional opportunity';
        update cta;
        /*cta.Ecoomerce_Qualification__c='More value for the same products'; 
update cta;
cta.Ecoomerce_Qualification__c='More value for the same products + Additional opportunity'; 
update cta;
        
    }
    @isTest
    public static void testMethod3()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='Qualified';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        
        
        Insert cta;
        
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Potential',CloseDate = System.today(),Name='test',CTA__c=cta.id);
        insert opp;
        
        cta.Ecoomerce_Qualification__c='Additional opportunity';
update cta;
        cta.Ecoomerce_Qualification__c='More value for the same products'; 
        update cta;
        cta.Ecoomerce_Qualification__c='More value for the same products + Additional opportunity'; 
        update cta;
        
    //}*/
    
    

	@isTest
    public static void testMethod4()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        /*Lead ld2=new lead(LastName='test',Pi__Score__c =5,Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld2;
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='Qualified';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        cta.Lead__c=ld2.id;
        cta.Order_Status__c = 'delivered';
        
        
        Insert cta;
        
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Potential',CloseDate = System.today(),Name='test',CTA__c=cta.id);
        insert opp;
        
        
        cta.Ecoomerce_Qualification__c='More value for the same products'; 
update cta;
        cta.Ecoomerce_Qualification__c='More value for the same products + Additional opportunity'; 
        update cta;*/
        
        
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.Prospect_Interest_Type__c = 'Request a callback';
        l1.Request_Callback_Product__c='loctite';
        //l1.LeadSource = 'Facebook';
        //l1.OwnerId ='0057F000005SHEvQAO';
        
        insert l1;
        
        l1.OwnerId ='0057F000005SHEvQAO';
        update l1;
        
        CTA__c cta1 = new CTA__c();
        cta1.Application__c='test';
       cta1.RecordTypeId = ctaRecordTypeId.demo;
        cta1.What_was_the_initial_enquiry__c='test';
        cta1.Lead__c=l1.id;
        insert cta1;
        
    }
    
  
    /*public static void testMethod5()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        Lead ld2=new lead(LastName='test',Pi__Score__c =5,Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld2;
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='Qualified';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        cta.Lead__c=ld2.Id;
        Insert cta;
        
        //cta.CTA_stage__c='';
        //update cta;
        
        
        
        /*Account acc = new Account(name='test1',Industry='Banking');
insert acc;
Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
insert c;
Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'Potential',CloseDate = System.today(),Name='test',CTA__c=cta.id);
insert opp;

cta.Ecoomerce_Qualification__c='One time eCommerce';
update cta;
        cta.Ecoomerce_Qualification__c='Additional opportunity';
update cta;
cta.Ecoomerce_Qualification__c='More value for the same products'; 
update cta;
cta.Ecoomerce_Qualification__c='More value for the same products + Additional opportunity'; 
update cta;
        
    }*/
    
    @isTest
    public static void testMethod6()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        Lead ld2=new lead(LastName='test',Pi__Score__c =5,Prospect_Interest_Type__c = 'Sample Requested',Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld2;
        
        Lead ld3=new lead(LastName='test',Pi__Score__c =5,Prospect_Interest_Type__c = 'Contact us',Pincode_Status__c='1',company='tst cmp1',Email='ramji1.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld3;
        
        Lead ld4=new lead(LastName='test',Pi__Score__c =5,Prospect_Interest_Type__c = 'Webinar',Pincode_Status__c='1',company='tst cmp1',Email='ramji2.shinde2@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld4;
        
        Lead ld5=new lead(LastName='test',Pi__Score__c =5,LeadSource  = 'IndiaMart',Pincode_Status__c='1',company='tst cmp1',Email='ramji1.shinde3@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld5;
        
        /*Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110002', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        
        Id ecomId=Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('eCommerce').getRecordTypeId();
        CTA__c cta=new CTA__c();
        cta.Application__c='test';
        cta.RecordTypeId=ecomId;
        cta.CTA_stage__c='new';
        cta.New_Existing__c='Existing customer & new application';
        cta.What_was_the_initial_enquiry__c='test';
        cta.Expected_close_date__c=system.today();
        //cta.Lead__c=ld2.Id;
        cta.Customer_Contact__c=c.id;
        Insert cta;
        
        cta.CTA_stage__c='Qualified';
        update cta;     */   
    }
    
    @isTest
    public static void testMethod7()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.CTA_trigger__c=true;
        Insert mc;
        
        /*Case cs = new Case();
        
        cs.SuppliedName = 'test_demo';
        cs.SuppliedEmail = 'Test@demo.com';
        //cs.ContactId = con.Id;
        cs.Origin = 'Email';
        cs.Status = 'open';
        cs.Enquiry_Type__c = 'Product/Tech Enquiry';
        
       // cs.Prospect_Interest_Type__c = 'Mail enquiry';
        
        cs.SlaStartDate = system.now() - 5;
        insert cs;
        cs.Company__c = 'demo';
        cs.Phone__c = '9898181818';
        cs.Industry__c = '2-wheeler repair';
        cs.No_of_Employees__c = '0-20';
        cs.Pin_code__c = 411046;
        cs.Prospect_Interest_Type__c = 'Mail enquiry';
        update cs;
 
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=cs.id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:cs.id];
    	System.assertEquals(1, attachments.size());
*/        
        //AssignToCreateLeadForISTTeam.CreateLeadAndAssign(cs.Id);
    }
    
}