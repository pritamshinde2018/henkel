@isTest(SeeAllData=false)
public class testContactTrigger
{
    public static testmethod void testmethod1()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.IsContactTriggerActivated__c=true;
        mc.IsoldcontacttrgActivated__c=false;
        insert mc;
        Contact cntObj=new Contact();
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Sample Requested';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=true;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        insert cntObj;
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='104';
        web.Customer_Contact__c=cntObj.Id;
       insert web;

        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id;
        insert opp;
        
        opp.Webinar_Id__c='104';
        opp.StageName='Trial Scheduled/Intent to buy';
        opp.Probability=30;
        update opp;
        Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     
        

        // cntObj.Chosen_Feedback__c = 'Unlock Offer';
        cntObj.Intends_to_speak_to_LOCTITE__c = FALSE;
        cntObj.Intends_to_place_an_order_request__c = TRUE;
        update cntObj;

        // cntObj.Chosen_Feedback__c = 'Speak to Henkel';
        cntObj.Intends_to_speak_to_LOCTITE__c = TRUE;
        cntObj.Intends_to_place_an_order_request__c = FALSE;
        update cntObj;
        //List<Offer__c> offerList=[Select id,name from offer__c where Customer_Contact__c=:cntObj.Id];
        //System.assertEquals(1,offerList.size());
        


    }
    public static testmethod void testmethod2()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.IsContactTriggerActivated__c=true;
        mc.IsoldcontacttrgActivated__c=false;
        insert mc;
        Contact cntObj=new Contact();
        integer count;
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Sample Requested';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=true;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        insert cntObj;
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='104';
        web.Customer_Contact__c=cntObj.Id;
       insert web;

        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.Webinar_Id__c='104';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id; 
        insert opp;
        
        opp.Webinar_Id__c='102';
        
        update opp;
      Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     cntobj.Prospect_Interest_Type__c='Webinar';
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        update cntobj;
        
    }
    public static testmethod void testmethod3()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.IsContactTriggerActivated__c=true;
        mc.IsoldcontacttrgActivated__c=false;
        insert mc;
        Contact cntObj=new Contact();
        integer count;
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Webinar';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=false;
        cntobj.Is_Webinar_Attended__c=false;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=false;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        
        insert cntObj;
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='104';
        web.Customer_Contact__c=cntObj.Id;
       insert web;
        
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.Webinar_Id__c='106';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id;
        insert opp;
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=true;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        
        update opp;
      Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     cntobj.Prospect_Interest_Type__c='Sample Requested';
        update cntobj;
        
    }
    public static testmethod void testmethod4()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.IsContactTriggerActivated__c=true;
        mc.IsoldcontacttrgActivated__c=false;
        insert mc;
        Contact cntObj=new Contact();
        integer count;
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Webinar';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=false;
        cntobj.Is_Webinar_Attended__c=false;
        cntobj.Is_Webinar_Attended2__c=false;
        cntobj.Is_Webinar_Attended3__c=false;
        cntobj.Is_Webinar_Attended4__c=false;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        
        insert cntObj;
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='105';
        web.Customer_Contact__c=cntObj.Id;
       insert web;
        
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.Webinar_Id__c='105';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Webinar';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id;
        insert opp;
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__C=true;
        cntobj.Is_Webinar_Attended4__c=true;
       cntobj.Is_Webinar_Attended3__c=true;
        
      Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     cntobj.Prospect_Interest_Type__c='Sample Requested';
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        update cntobj;
        
    }
    public static testmethod void testmethod5()
    {
        EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
        mc.IsContactTriggerActivated__c=true;
        mc.IsoldcontacttrgActivated__c=false;
        insert mc;
        Contact cntObj=new Contact();
        integer count;
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Webinar';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=false;
        cntobj.Is_Webinar_Attended__c=false;
        cntobj.Is_Webinar_Attended2__c=false;
        cntobj.Is_Webinar_Attended3__c=false;
        cntobj.Is_Webinar_Attended4__c=false;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        
        insert cntObj;
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='104';
        web.Customer_Contact__c=cntObj.Id;
       insert web;
        
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.Webinar_Id__c='98';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id;
        insert opp;
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=true;
        cntobj.Industry__c = 'Medical and Surgical Equipment';
        cntobj.Number_of_Employees_Custom__c = '0-20';
        
        update opp;
      Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     cntobj.Prospect_Interest_Type__c='Sample Requested';
        update cntobj;
        
    }
    
  /* public static testmethod void testmethod6()
    {
        Contact cntObj=new Contact();
        integer count;
        cntObj.Offer_Product__c='abc';
        cntObj.LastName='testdemo1';
        cntObj.Intends_to_place_an_order_request__c = false;
        cntObj.Intends_to_speak_to_LOCTITE__c = false;
        cntobj.Prospect_Interest_Type__c='Webinar';
        cntObj.Offer_Product__c = null;
        cntObj.Flag_Webinar__c=true;
        cntObj.Webinar_Id__c='103';
        cntObj.Webinar_Id_1__c='102';
        cntobj.Webinar_Id_2__c='98';
        cntobj.Webinar_Id_3__c='105';
        cntobj.Webinar_Id_4__c='106';
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=false;
        cntobj.Is_Webinar_Attended2__c=false;
        cntobj.Is_Webinar_Attended3__c=false;
        cntobj.Is_Webinar_Attended4__c=false;
        cntobj.Prospect_Interest_Type__c='';
        cntObj.Industry__c ='MEDIA AND ENTERTAINMENT';
        cntObj.Number_of_Employees_Custom__c ='20-100';
        insert cntObj;
        
        
        
        Webinar__c web=new Webinar__c();
        web.Webinar_Id__c='104';
        web.Customer_Contact__c=cntObj.Id;
       insert web;
        
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.Webinar_Id__c='105';
        opp.Status__c='Completed';
        opp.StageName = 'Sample Sent/Inquiry Received';
        opp.Probability=15;
        opp.Prospect_Interest_Type__c='Sample Requested';
        opp.CloseDate=Date.today();
        opp.Intends_to_place_an_order_request_del__c = cntObj.Intends_to_place_an_order_request__c;
        opp.Intends_to_Speak__c = cntObj.Intends_to_speak_to_LOCTITE__c;
        opp.Contact2__c = cntObj.id;
        insert opp;
        cntobj.Is_Webinar_Attended1__c=true;
        cntobj.Is_Webinar_Attended__c=true;
        cntobj.Is_Webinar_Attended2__c=true;
        cntobj.Is_Webinar_Attended3__c=true;
        cntobj.Is_Webinar_Attended4__c=true;
        
        
        update opp;
      Task t = new Task();
        t.Subject = 'Confirm Sample Received';
        t.WhatId = opp.Id;
        t.Status = 'Completed';
        insert t;
     
        //update cntobj;
        cntobj.Prospect_Interest_Type__c='Sample Requested';
        cntObj.Request_Callback_Product__c='test';
        cntObj.Customized_Price_Product__c='test';
        cntObj.Refer_A_Friend_Product__c='test';
        cntObj.Industry__c='Health care';
        cntObj.Intends_to_place_an_order_request__c=true;
        
        //cntObj.Contact_Industry_Employees__c='MEDIA AND ENTERTAINMENT-20-100';
        
        update cntObj;
        
        System.debug('Industry_Value__c	--- '+cntObj.Industry_Value__c);
        
    }*/
}