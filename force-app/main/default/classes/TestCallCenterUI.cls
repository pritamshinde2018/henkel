@isTest
public class TestCallCenterUI {
 static testmethod void testmethod1()
    {
        contact cObj=new Contact();
        cObj.LastName='test11';
        cObj.Email='test@nanostuffs.com';
        insert cObj;
          Lead lobj=new Lead();
            lobj.LastName = 'Test Lead';
            lobj.Phone = '7896541230';
            lobj.LeadSource='Indiamart';
            //lobj.Indiamart_QTYPE__c='Buy Leads';
            lobj.cc_status__c = '';
            lobj.IM_Status__c = 'None';
            lObj.Tell_us_about_your_application_in_one_li__c='test';
            lobj.Email = 'ajinkya.wankhede@nanostuffs.com';
            lobj.MobilePhone = '7895641232';
            lobj.Which_Product_Sent__c = 'LOCTITE Threadlocker 243';
            lobj.Product_Name__c = 'Test Product';
            lobj.Product_Quantity__c = 5 ;
            lobj.Unit__c = 'KG';
            //lObj.CC_Current_Method__c='test current';
            lobj.What_the_company_does__c='test Company does';
            lobj.Industry='Other';
            lobj.What_is_the_purpose_use__c='Maintenance of Machinery or Facility';
            //lobj.Job_Title__c='Proprietor/Owner';
            lobj.Role_in_organisation__c='I take all decisions related to purchase of material/parts used in manufacturing repair and maintenance';
            lobj.Number_of_Employees_Custom__c='0-20';
            lobj.CC_Remarks_1__c='cc1';
            lobj.CC_Remarks_2__c='cc2';
            lobj.CC_Remarks_3__c='cc3';
            lobj.Street='Mahatma';
            lobj.City='City';
            lobj.State='state';
            lobj.Country='Country';
            lobj.Company='nano';
            Insert lobj;
   			ApexPages.currentPage().getParameters().put('myparam',',callback1,test,currentMethod,whatcompany,BANKING,Maintenance of Machinery or Facility,CEO,I take all decisions related to purchase of material/parts used in manufacturing, repair and maintenance,0-20,cc1,cc2,cc3,street,city,state,country,'+lobj.id);
    		CallCenterUIController lObjcon=new CallCenterUIController();
        	lObjcon.updateLead();
        
        Lead lobj1=[Select id,Tell_us_about_your_application_in_one_li__c,CC_Remarks_1__c from lead where id=:lobj.Id];
        
        System.assertEquals('test', lobj1.Tell_us_about_your_application_in_one_li__c);
        System.assertEquals('cc1', lobj1.CC_Remarks_1__c);
        
    }
  
}