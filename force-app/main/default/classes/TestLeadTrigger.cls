@isTest
public class 
TestLeadTrigger
{
    /*@isTest
    public static void testLeadTrigger(){
        test.startTest();
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
        mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        //Create Parent Group
        Group grp = new Group();
        grp.name = 'IST ';
        grp.Type = 'Regular'; 
        //Insert grp; 
       Lead ld = new Lead(Type_of_Enquiry__c='request_a_visit',Lastname = 'test name',Pi__Score__c = 76,company='tst cmp',street = 'street1',PostalCode = '113020',Country = 'India',Prospect_Interest_Type__c='Sample Requested',Email='ajinkya.wankhede@nanostuffs.com',Pincode_Status__c='1');
        insert ld;
        Lead ld1 = new Lead(Type_of_Enquiry__c='general_inquiry',Lastname = 'test name',Pi__Score__c = 80,Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Prospect_Interest_Type__c='Offer');
        insert ld1;
        Lead ld2=new lead(LastName='test',Pi__Score__c =5,Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id_1__c='111',phone='9766924768',Is_Webinar_Attended1__c=false );
        insert ld2;
        Lead ld3=new lead(LastName='test',Pi__Score__c =5,Pincode_Status__c='1',company='tst cmp1',Email='ramji.shinde@nanostuffs.com',street = 'street2',PostalCode = '110021',Country = 'India',Email_Encrypted__c='hfghfghf',Webinar_Id__c='1614',phone='9766924768',Webinar_Name__c='dfff');
        
        insert ld3;
        
        WebinarNurturingSMSthreedaybefore ag1 = new WebinarNurturingSMSthreedaybefore();
        WebinarNurturingSMS web1 = new WebinarNurturingSMS();
        String sch = '0 0 23 * * ?';
        string msg='fgfgd dfg dfg ';
        
        lead l= [select id,Phone,Webinar_Name1__c,Webinar_Machine1__c,Email_Encrypted__c from lead where  Webinar_Id_1__c!=NUll and Email_Encrypted__c !=NULL and IsConverted!=TRUE and id=:ld2.ID];
        lead ll= [select id,Phone,Webinar_Id__c,Webinar_Name1__c,Webinar_Machine1__c,Reminder_SMS1__c,Email_Encrypted__c from lead where  Webinar_Id__c LIKE '1614' and IsConverted!=TRUE and id=:ld3.id]; 
        lead le= [select id, Phone, Webinar_Name1__c, Webinar_Machine1__c, Couldnt_Attend_SMS__c, Email_Encrypted__c from lead where Webinar_Id_1__c!=NUll and Email_Encrypted__c !=NULL and IsConverted!=TRUE and  Couldnt_Attend_SMS__c!=true and Is_Webinar_Attended1__c!=true  and id=:ld2.ID];
        
        system.schedule('Test Agent Assignment',sch,ag1); 
        system.schedule('Test Agent Assignment1',sch,web1);
        SendSMS_Helper.sendSMSMessage(l.Phone,msg);
        SendSMS_Helper.sendSMSMessage(ll.phone, msg);
        SendSMS_Helper.callapi(le.Phone,msg);
        contact c=new contact();
        c.LastName='test';
        c.MobilePhone='8765432345';
        c.Phone='8765456789';
        //c.Company__c='test';
        c.email='ramshinde123@gmail.com';
        //Contact cntObj=new Contact();
        c.Offer_Product__c='abc';
        c.LastName='testdemo1';
        c.Intends_to_place_an_order_request__c = false;
        c.Intends_to_speak_to_LOCTITE__c = false;
        c.Prospect_Interest_Type__c='Sample Requested';
        c.Offer_Product__c = null;
         insert c;
        SendSMS_Helper.SendResetPwdEmail(c);
      test.stopTest();
    }*/
    /*@isTest
    public static void testLeadTrigger1()
    {
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
         mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        System.debug('testLeadTrigger1');
         contact c=new contact();
        c.LastName='test';
        c.MobilePhone='8765432345';
        c.Phone='8765456789';
        //c.Company__c='test';
        c.email='ramshinde123@gmail.com';
        //Contact cntObj=new Contact();
        c.Offer_Product__c='abc';
        c.LastName='testdemo1';
        c.Intends_to_place_an_order_request__c = false;
        c.Intends_to_speak_to_LOCTITE__c = false;
        c.Prospect_Interest_Type__c='Sample Requested';
        c.Offer_Product__c = null;
        insert c;
        List<Group> g = [Select id from group where name='CC Team'];
    System.debug('g '+g);
    List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
       //webinar lead
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.Prospect_Interest_Type__c = 'Webinar';
        l1.LeadSource = 'Facebook';
        l1.Type_of_Enquiry__c='general_inquiry';
        l1.Postalcode='411011';
        l1.OwnerId =memberList[0].UserOrGroupId;
        insert l1; 
        
        lead l2 = new lead();
        l2.lastname = 'Unknown';
        l2.Company = 'Unknown';
        l2.email = 'testunknown@gmail.com';
        l2.Phone = '8974587878';
        l2.Flag_Webinar__c = true;
        l2.Prospect_Interest_Type__c = 'Webinar';
        l2.Flag_Webinar__c = True;
        l2.Industry='Banking';
        //l2.LeadSource = 'Facebook';
        l2.PostalCode='411011';
        l2.OwnerId =memberList[0].UserOrGroupId;
        insert l2; 
        
         lead le = new lead();
        le.lastname = 'Unknown';
        le.Company = 'Unknown';
        le.email = 'testunknown@gmail.com';
        le.Phone = '8974587878'; 
        le.LeadSource = 'Facebook';
        le.OwnerId =memberList[0].UserOrGroupId;
        insert le;
        
        le.Flag_Webinar__c = true;
        le.Prospect_Interest_Type__c = 'Webinar';
        update le;        
        //indiamart lead
        lead l3 = new lead();
        l3.lastname = 'test';
        l3.company = 'testcomp';
        l3.City='Navi Mumbai';
        l3.email = 'testcomp@indi.com';
        l3.phone = '8974511221';
        l3.LeadSource = 'Indiamart';
        l3.Indiamart_QTYPE__c='Buy Leads';
        l3.Indiamart_ID__c = '14789654000';
        insert l3;
    }*/
    
   
    
    @isTest
    public static void testLeadTrigger5()
    {
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
         mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        List<String> l2 = new List<String>();
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.Prospect_Interest_Type__c = 'Request a callback';
        l1.Request_Callback_Product__c='loctite';
        //l1.LeadSource = 'Facebook';
        //l1.OwnerId =memberList[0].UserOrGroupId;
        
        insert l1;
        
        l2.add(l1.Id);
        
        CTA__c cta = new CTA__c();
        
        cta = [select id from cta__c where lead__c =: l2[0] limit 1];

        leadControlleronCTA.insertLead(cta.id);
    }
    @isTest
    public static void testLeadTrigger4()
    {
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
         mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        List<Group> g = [Select id from group where name='SalesTeam'];
        System.debug('g '+g);
        List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.LeadSource = 'IndiaMart';
        l1.Postalcode='411011';
        l1.Indiamart_ID__c = '315380153';
        l1.Indiamart_QTYPE__c = 'PNS';
        l1.Subject__c = 'Buyer Call';
        l1.QUERY_MODID__c = 'DIRECT';
        l1.Date_Of_Enquiry__c = '26 Jul 2021';
        l1.Time_Of_Enquiry__c = '26-Jul-2021 02:19:28 PM';
        insert l1; 
    }
    @isTest
    public static void testLeadTrigger3()
    {
        EcomAPI__c mc =new EcomAPI__c();
        mc.IsLeadTriggerActivated__c=false;
         mc.IsnewLeadtrgActivated__c=true;
        Insert mc;
        System.debug('testLeadTrigger1');
        contact c=new contact();
        c.LastName='test';
        c.MobilePhone='8765432345';
        c.Phone='8765456789';
        //c.Company__c='test';
        c.email='ramshinde123@gmail.com';
        //Contact cntObj=new Contact();
        c.Offer_Product__c='abc';
        c.LastName='testdemo1';
        c.Intends_to_place_an_order_request__c = false;
        c.Intends_to_speak_to_LOCTITE__c = false;
        c.Prospect_Interest_Type__c='Sample Requested';
        c.Offer_Product__c = null;
        insert c;
        List<Group> g = [Select id from group where name='CC Team'];
    System.debug('g '+g);
    List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
       //webinar lead
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Flag_Webinar__c = true;
        l1.Prospect_Interest_Type__c = 'Request a callback';
        l1.Request_Callback_Product__c='loctite';
        l1.LeadSource = 'Facebook';
        l1.OwnerId =memberList[0].UserOrGroupId;
        
        insert l1;
        
        l1.Request_Callback_Product__c='loctite12';
        update l1;
        
        /*lead l12 = new lead();
        l12.lastname = 'Unknown';
        l12.Company = 'Unknown';
        l12.email = 'testunknown@gmail.com';
        l12.Phone = '8974587878';
        l12.Flag_Webinar__c = true;
        l12.Prospect_Interest_Type__c = 'Refer to Friend';
        l12.Refer_A_Friend_Product__c='loctite';
        l12.LeadSource = 'Facebook';
        l12.OwnerId =memberList[0].UserOrGroupId;
        insert l12;
        
        l12.Refer_A_Friend_Product__c='loctite12';
        update l12;
        
    lead l2 = new lead();
        l2.lastname = 'Unknown';
        l2.Company = 'Unknown';
        l2.email = 'testunknown@gmail.com';
        l2.Phone = '8974587878';
        l2.Flag_Webinar__c = true;
        l2.Prospect_Interest_Type__c = 'Customized Price';
        l2.Customized_Price_Product__c='Loctite';
        //l2.LeadSource = 'Facebook';
        l2.OwnerId =memberList[0].UserOrGroupId;
        insert l2; 
        
         l2.Customized_Price_Product__c='Loctite12';
        update l2;
        lead le = new lead();
        le.lastname = 'Unknown';
        le.Company = 'Unknown';
        le.email = 'testunknown@gmail.com';
        le.Phone = '8974587878'; 
        le.LeadSource = 'Facebook';
        le.OwnerId =memberList[0].UserOrGroupId;
        insert le;
        
       le.Flag_Webinar__c = true;
        le.Prospect_Interest_Type__c = 'Quotation';
        update le;    
        //indiamart leadjavascript:void(0);
        /*lead l3 = new lead();
        l3.lastname = 'test';
        l3.company = 'testcomp';
        l3.City='Navi Mumbai';
        l3.email = 'testcomp@indi.com';
        l3.phone = '8974511221';
        l3.LeadSource = 'Indiamart';
        l3.Indiamart_QTYPE__c='Buy Leads';
        l3.Indiamart_ID__c = '14789654000';
        insert l3;*/
        /*lead l9 = new lead();
        l9.lastname = 'test hdshsjdh';
        l9.company = 'testcompgghf';
        l9.City='Navi Mumbaigg';
        l9.email = 'testcomp00@indi.com';
        l9.phone = '8974511220';
        l9.LeadSource = 'Indiamart';
        l9.Indiamart_QTYPE__c='Contact Suppliers';
        l9.Indiamart_ID__c = '1478965400036';
        insert l9;*/
    }
    
    //@isTest
  /*public static void test_method1()
    {
        lead l1 = new lead();
        l1.lastname = 'Unknown';
        l1.Company = 'Unknown';
        l1.email = 'testunknown@gmail.com';
        l1.Phone = '8974587878';
        l1.Prospect_Interest_Type__c = 'Sample Requested';
        l1.LeadSource = 'Facebook';
        l1.Postalcode='411011';
        l1.Number_of_Employees_Custom__c='0-20';
        l1.Industry='Chemical';
        l1.pi__score__c=50;
        l1.Lead_classification_basis_value__c='A';
        insert l1;
        
        l1.pi__score__c=80;
        l1.Lead_classification_basis_value__c='C';
        update l1;
        lead l2 = new lead();
        l2.lastname = 'Unknown';
        l2.Company = 'Unknown';
        l2.email = 'testunknown@gmail.com';
        l2.Phone = '8974587878';
        l2.Prospect_Interest_Type__c = 'Sample Requested';
        l2.LeadSource = 'Facebook';
        l2.Postalcode='411011';
        l2.Number_of_Employees_Custom__c='0-20';
        l2.Industry='Chemical';
        l2.pi__score__c=20;
        l2.Lead_classification_basis_value__c='B';
        insert l2;
        
        l2.Lead_classification_basis_value__c='A';
        l2.pi__score__c=80;
        update l2;
        
        lead l3 = new lead();
        l3.lastname = 'Unknown';
        l3.Company = 'Unknown';
        l3.email = 'testunknown@gmail.com';
        l3.Phone = '8974587878';
        l3.Prospect_Interest_Type__c = 'Sample Requested';
        l3.LeadSource = 'Facebook';
        l3.Postalcode='411011';
        l3.Number_of_Employees_Custom__c='0-20';
        l3.Industry='Chemical';
        l3.pi__score__c=20;
        l3.Lead_classification_basis_value__c='C';
        insert l3;
        
        l3.Lead_classification_basis_value__c='D';
        l3.pi__score__c=40;
        update l3;
        
        lead l4 = new lead();
        l4.lastname = 'Unknown';
        l4.Company = 'Unknown';
        l4.email = 'testunknown@gmail.com';
        l4.Phone = '8974587878';
        l4.Prospect_Interest_Type__c = 'Sample Requested';
        l4.LeadSource = 'Facebook';
        l4.Postalcode='411011';
        l4.Number_of_Employees_Custom__c='0-20';
        l4.Industry='Chemical';
        l4.pi__score__c=20;
        l4.Lead_classification_basis_value__c='D';
        insert l4;
        
        l4.Lead_classification_basis_value__c='C';
        l4.pi__score__c=40;
        update l4;
        
        lead l5 = new lead();
        l5.lastname = 'Unknown';
        l5.Company = 'Unknown';
        l5.email = 'testunknown@gmail.com';
        l5.Phone = '8974587878';
        l5.Prospect_Interest_Type__c = 'Sample Requested';
        l5.LeadSource = 'Facebook';
        l5.Postalcode='411011';
        l5.Number_of_Employees_Custom__c='0-20';
        l5.Industry='Chemical';
        l5.pi__score__c=70;
        l5.Lead_classification_basis_value__c='C';
        insert l5;
        
        l5.Lead_classification_basis_value__c='D';
        l5.pi__score__c=100;
        update l5;
        
        lead l6 = new lead();
        l6.lastname = 'Unknown';
        l6.Company = 'Unknown';
        l6.email = 'testunknown@gmail.com';
        l6.Phone = '8974587878';
        l6.Prospect_Interest_Type__c = 'Sample Requested';
        l6.LeadSource = 'Facebook';
        l6.Postalcode='411011';
        l6.Number_of_Employees_Custom__c='0-20';
        l6.Industry='Chemical';
        l6.pi__score__c=20;
        l6.Lead_classification_basis_value__c='A';
        insert l6;
        
        l6.Lead_classification_basis_value__c='B';
        l6.pi__score__c=80;
        update l6;
    }*/
}