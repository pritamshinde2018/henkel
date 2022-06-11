Public with sharing class CallCenterUIControllerPlumbing
{
    public List<Lead> leadList{get;set;}
    public string paramVal{get;set;}
    Public CallCenterUIControllerPlumbing()
    {}
    public CallCenterUIControllerPlumbing(ApexPages.StandardController controller) 
    {
        leadList= new List<Lead>();
        leadList= [select Phone,id,pi__conversion_date__c,Type__c,What_is_the_purpose_use__c,street,city,state,
            country,Name,Role_in_organisation__c,pi__created_date__c,Job_Title__c,PostalCode,
            What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,CC_Conversion_Date_Time__c,
            CC_Date_Added_In_Sheet__c,pi__score__c,Current_Score__c,Company,  MobilePhone,CC_Qualification__c,
            Email,Which_Product_Sent__c,CC_Sample_Required__c,Pincode_Status__c,Tell_us_about_your_application_in_one_li__c,
            CC_Current_Method__c,CC_Collected_Information__c,Industry,  CC_Market_Segment__c,NumberOfEmployees,Address,
            CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource,Manual_Organic__c from Lead 
            where Plumbing_Lead__c=True and CC_Status__c!='Details verified' and CC_Status__c!='mql' and CC_Status__c!='noco' and CC_Status__c!='nmql' and CC_Status__c!='Not interested' ORDER BY CreatedDate DESC LIMIT 1000];          
    }
    public PageReference updateLead()
    {
        string passedParam2 = system.CurrentPageReference().getParameters().get('myParam');
        passedParam2 = passedParam2.substring(1);
        List<String> lstAlpha = passedParam2.split(',');
        for(String str : lstAlpha)
        {
           system.debug('str--- '+str); 
        }
        system.debug('lstAlpha----- '+lstAlpha.size());
        system.debug('lstAlpha[1] '+lstAlpha[1].replace('^',','));
        system.debug('lstAlpha[2]'+lstAlpha[2].replace('^',','));
        system.debug('lstAlpha[3] '+lstAlpha[3].replace('^',','));
        system.debug('lstAlpha[4] '+lstAlpha[4].replace('^',','));
        system.debug('lstAlpha[5] '+lstAlpha[5].replace('^',','));
        system.debug('lstAlpha[6] '+lstAlpha[6].replace('^',','));
        system.debug('lstAlpha[7] '+lstAlpha[7].replace('^',','));
        system.debug('lstAlpha[8]'+lstAlpha[8].replace('^',','));
        system.debug('lstAlpha[9] '+lstAlpha[9].replace('^',','));
        system.debug('lstAlpha[10] '+lstAlpha[10].replace('^',','));
        system.debug('lstAlpha[11] '+lstAlpha[11].replace('^',','));
        system.debug('lstAlpha[12]'+lstAlpha[12].replace('^',','));
        system.debug('lstAlpha[13] '+lstAlpha[13].replace('^',','));
        system.debug('lstAlpha[14]'+lstAlpha[14].replace('^',','));
        system.debug('lstAlpha[15]'+lstAlpha[15].replace('^',','));
        Lead myLead = new Lead();
        if(lstAlpha[1]!='null')
        {
            myLead.CC_Status__c=lstAlpha[1].replace('^',','); 
        }
        if(lstAlpha[2]!='null')
        {
            myLead.Company=lstAlpha[2].replace('^',','); 
        }
        if(lstAlpha[3]!='null')
        {
            myLead.Email=lstAlpha[3].replace('^',','); 
        }
        if(lstAlpha[4]!='null')
        {
            myLead.Type__c=lstAlpha[4].replace('^',','); 
        }
        if(lstAlpha[5].replace('^',',') == null || lstAlpha[5].replace('^',',') == 'null')
        {
            mylead.NumberOfEmployees = 0;
            
        }
        else
        {
            mylead.Number_of_Employees_Custom__c=lstAlpha[5].replace('^',',');
        }
        mylead.Industry=lstAlpha[6].replace('^',',');
        mylead.CC_Current_Method__c=lstAlpha[7].replace('^',',');
        
        if(lstAlpha[8].replace('^',',') == null || lstAlpha[8].replace('^',',') == 'null') 
        {}
        else
        {
            mylead.What_is_the_purpose_use__c=lstAlpha[8].replace('^',',');
           
        } 
        
        mylead.CC_Remarks_1__c=lstAlpha[9].replace('^',',');
        system.debug('lstAlpha[9]---- '+mylead.CC_Remarks_1__c);
        mylead.CC_Remarks_2__c=lstAlpha[10].replace('^',',');
        mylead.CC_Remarks_3__c=lstAlpha[11].replace('^',',');
        mylead.Street=lstAlpha[12].replace('^',',');
        mylead.City=lstAlpha[13].replace('^',',');
        mylead.State=lstAlpha[14].replace('^',',');
        mylead.Country=lstAlpha[15].replace('^',',');
        mylead.id=lstAlpha[16].replace('^',',');
        
        /*mylead.Number_of_Employees_Custom__c=lstAlpha[9].replace('^',',');
        mylead.CC_Remarks_1__c= lstAlpha[10].replace('^',',');
        mylead.CC_Remarks_2__c= lstAlpha[11].replace('^',',');
        mylead.CC_Remarks_3__c= lstAlpha[12].replace('^',',');*/
        
        
       
        try
        {
            update mylead;
            //For Rerendering the datatable on page
            leadList= [select Phone,id,pi__conversion_date__c,What_is_the_purpose_use__c,street,city,state,
            country,Name,Role_in_organisation__c,pi__created_date__c,Type__c,Job_Title__c,PostalCode,
            What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,CC_Conversion_Date_Time__c,
            CC_Date_Added_In_Sheet__c,pi__score__c,Current_Score__c,Company,  MobilePhone,CC_Qualification__c,
            Email,Which_Product_Sent__c,CC_Sample_Required__c,Pincode_Status__c,Tell_us_about_your_application_in_one_li__c,
            CC_Current_Method__c,CC_Collected_Information__c,Industry,  CC_Market_Segment__c,NumberOfEmployees,Address,
            CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource,Manual_Organic__c from Lead 
            where Plumbing_Lead__c=True AND Indiamart_ID__c=null AND (CC_Status__c='callback' OR CC_Status__c='' OR CC_Status__c='callback1' OR CC_Status__c='callback2') AND Prospect_Interest_Type__c='Sample Requested' AND CC_Status__c!='mql'AND CC_Status__c!='Details verified' AND IsConverted=false AND ownerID=:UserInfo.getUserId() ORDER BY CreatedDate DESC LIMIT 1000];          
        }
        catch(Exception ex)
        {
            ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR,ex.getDmlMessage(0));  
            IndiaMartUIController i=new IndiaMartUIController();
            ApexPages.addMessage(errMsg); 
        }
       return null;        
    }
}