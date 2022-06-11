Public class LeadUpdateRecordsControllerTest
{
    public List<Lead> accList{get;set;}
    public List<Lead> leadList;
    public string paramVal{get;set;}
    public List<Call_Center_Agents__c> agentList{get;set;}
    String agentId;
    Public LeadUpdateRecordsControllerTest()
    {
        agentId = ApexPages.currentPage().getParameters().get('id'); 
        accList= new List<Lead>();
        agentList = new List<Call_Center_Agents__c>();
        leadList=new List<Lead>();
        if(agentId ==null || agentId=='')
        {
            accList = null; 
        }
        else
        {
        
            agentList = [Select id,Name from Call_Center_Agents__c where id=:agentId];
            accList= [select Phone,id,pi__conversion_date__c,What_is_the_purpose_use__c,street,city,state,country,Name,Role_in_organisation__c,pi__created_date__c,Job_Title__c,PostalCode,What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,CC_Conversion_Date_Time__c,CC_Date_Added_In_Sheet__c,pi__score__c,Current_Score__c,Company,  MobilePhone,CC_Qualification__c,Email,Which_Product_Sent__c,CC_Sample_Required__c,Pincode_Status__c,Tell_us_about_your_application_in_one_li__c,CC_Current_Method__c,CC_Collected_Information__c,Industry,  CC_Market_Segment__c,NumberOfEmployees,Address,CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource,Manual_Organic__c from Lead where Call_Center_Agents__c =:agentId AND (CC_Status__c='callback' OR CC_Status__c='')AND isConverted=false ];          
            
        }
    }
    
    public PageReference IWantToDebug() 
    {    
        String par = Apexpages.currentPage().getParameters().get('node');
        return null;
    }
    
    public void DeleteQuoteLineItem()
    {
        System.debug('I am in DeleteQuoteLineItem()');
        Map<String, String> mapobj = new Map<String, String>();
        string passedParam2 = system.CurrentPageReference().getParameters().get('myParam');
        System.debug('passedParam2-------------'+passedParam2);
        passedParam2 = passedParam2.substring(1);
        List<String> lstAlpha = passedParam2.split(',');
        Lead myLead = new Lead();
        mylead.id=lstAlpha[0];         
        mylead.Tell_us_about_your_application_in_one_li__c=lstAlpha[1];
        mylead.CC_Current_Method__c=lstAlpha[2];
        mylead.What_the_company_does__c=lstAlpha[3];
        mylead.Industry=lstAlpha[4];
        mapobj.put('id',lstAlpha[0]);
        mapobj.put('Tell_us_about_your_application_in_one_li',lstAlpha[1]);
        mapobj.put('CC_Current_Method',lstAlpha[2]);
        mapobj.put('What_the_company_does',lstAlpha[3]);
        mapobj.put('Industry',lstAlpha[4]);
        
        if(lstAlpha[5] == null || lstAlpha[5] == 'null') 
        {}
        else
        {
            mylead.What_is_the_purpose_use__c=lstAlpha[5];
            mapobj.put('What_is_the_purpose_use',lstAlpha[5]);
        } 
        if(lstAlpha[6] == null || lstAlpha[6] == 'null')
        {}
        else
        {
            System.debug('lstAlpha[6] '+lstAlpha[6]);
            mylead.Job_Title__c=lstAlpha[6];
            mapobj.put('Job_Title',lstAlpha[6]);
        }
        
        mylead.Role_in_organisation__c=lstAlpha[7];
        mapobj.put('Role_in_organisation',lstAlpha[7]);
        
        if(lstAlpha[8] == null || lstAlpha[8] == 'null')
        {
            mylead.NumberOfEmployees = 0;
            mapobj.put('Number_of_Employees_Custom','0');
        }
        else
        {
            mylead.Number_of_Employees_Custom__c=lstAlpha[8];
            mapobj.put('Number_of_Employees_Custom',lstAlpha[8]);
        }
        
        mylead.CC_Remarks_1__c= lstAlpha[9];
        mylead.CC_Remarks_2__c= lstAlpha[10];
        mylead.CC_Remarks_3__c= lstAlpha[11];
        mapobj.put('CC_Remarks_1',lstAlpha[9]);
        mapobj.put('CC_Remarks_2',lstAlpha[10]);
        mapobj.put('CC_Remarks_3',lstAlpha[11]);
        mapobj.put('Street',lstAlpha[12]);
        mapobj.put('City',lstAlpha[13]);
        mapobj.put('State',lstAlpha[14]);
        mapobj.put('Country',lstAlpha[15]);
        String valueTobeInsert = JSON.Serialize(mapobj);
        LeadClone__c insObj = new LeadClone__c();
        insObj.LeadQuery__c = valueTobeInsert;
        
        insert insObj;
    }
}