@isTest
public class TestUpdateLeadPage 
{
    static testmethod void testmethod1()
    {
        contact cObj=new Contact();
        cObj.LastName='test11';
        
        insert cObj;
     
        Call_Center_Agents__c agentObj=new Call_Center_Agents__c();
        agentObj.Active__c=true;
        agentObj.Name='TestAgent';
        
        Insert agentObj;
      
        Lead lobj=new Lead();
        lObj.Tell_us_about_your_application_in_one_li__c='test';
            lObj.CC_Current_Method__c='test current';
            lobj.What_the_company_does__c='test Company does';
            lobj.Industry='Other';
            lobj.What_is_the_purpose_use__c='Maintenance of Machinery or Facility';
            lobj.Job_Title__c='Proprietor/Owner';
            lobj.Role_in_organisation__c='I take all decisions related to purchase of material/parts used in manufacturing repair and maintenance';
            lobj.Number_of_Employees_Custom__c='0-20';
            lobj.CC_Remarks_1__c='cc1';
            lobj.CC_Remarks_2__c='cc2';
            lobj.CC_Remarks_3__c='cc3';
            lobj.Street='Mahatma';
            lobj.City='City';
            lobj.State='state';
            lobj.Country='Country';
        	lobj.LastName='test';
            lobj.Company='nano';
    
            Insert lobj;
     
        ApexPages.currentPage().getParameters().put('myparam',','+lobj.Id+',tell,current,company does,2-wheeler repair,Maintenance of Machinery or Facility,Proprietor/Owner,I take all decisions related to purchase of material/parts used in manufacturing repair and maintenance,0-20,remark1,remark2,remark3,street,city,state,country,0');
		LeadUpdateRecordsControllerTest lObjcon=new LeadUpdateRecordsControllerTest();
        lObjcon.DeleteQuoteLineItem();
        
        Lead lobj1=[Select id,Tell_us_about_your_application_in_one_li__c,CC_Current_Method__c from lead where id=:lobj.Id];
        
        System.assertEquals('tell', lobj1.Tell_us_about_your_application_in_one_li__c);
        System.assertEquals('current', lobj1.CC_Current_Method__c);
        
    }
    static testmethod void testmethod2()
    {
		JSON2Apex.parse('{"Country":"country","State":"state","City":"city","Street":"street","CC_Remarks_3":"remark3","CC_Remarks_2":"remark2","CC_Remarks_1":"remark1","Number_of_Employees_Custom":"0-20","Role_in_organisation":"I take all decisions related to purchase of material/parts used in manufacturing repair and maintenance","What_is_the_purpose_use":"Maintenance of Machinery or Facility","Industry":"2-wheeler repair","What_the_company_does":"company does","CC_Current_Method":"current","Tell_us_about_your_application_in_one_li":"tell","id":"00Qp000000459DVEAY"}');
    }
    
}