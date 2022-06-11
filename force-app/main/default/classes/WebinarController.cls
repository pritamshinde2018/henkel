public class WebinarController {
    public List<Lead> leadList{get;set;}
    public string paramVal{get;set;}
    Public WebinarController()
    {}
    public WebinarController(ApexPages.StandardController controller) 
    {
        leadList= new List<Lead>();
        leadList= [select Phone,id,pi__conversion_date__c,What_is_the_purpose_use__c,street,city,state,
            country,Name,Role_in_organisation__c,pi__created_date__c,Job_Title__c,PostalCode,
            What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,CC_Conversion_Date_Time__c,
            CC_Date_Added_In_Sheet__c,pi__score__c,Current_Score__c,Company,  MobilePhone,CC_Qualification__c,
            Email,Which_Product_Sent__c,CC_Sample_Required__c,Pincode_Status__c,Tell_us_about_your_application_in_one_li__c,
            CC_Current_Method__c,CC_Collected_Information__c,Industry,  CC_Market_Segment__c,NumberOfEmployees,Address,
            CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource,Manual_Organic__c from Lead 
            where Indiamart_ID__c=null AND (CC_Status__c='callback' OR CC_Status__c='' OR CC_Status__c='callback1' OR CC_Status__c='callback2') AND IsConverted=false AND Prospect_Interest_Type__c='Webinar' and  ownerID=:UserInfo.getUserId()];          
    }
    public PageReference updateLead()
    {
        string passedParam2 = system.CurrentPageReference().getParameters().get('myParam');
        passedParam2 = passedParam2.substring(1);
        List<String> lstAlpha = passedParam2.split(',');
        system.debug('lstAlpha---'+lstAlpha.size());
        Lead myLead = new Lead();
        if(lstAlpha[1]!='null')
        {
            myLead.CC_Status__c=lstAlpha[1].replace('^',','); 
        }
        myLead.LastName=lstAlpha[2].replace('^',',');
        myLead.Company=lstAlpha[3].replace('^',',');
        myLead.Which_Product_Sent__c=lstAlpha[4].replace('^',',');
        myLead.PostalCode=lstAlpha[5].replace('^',',');
        mylead.Tell_us_about_your_application_in_one_li__c=lstAlpha[6].replace('^',',');  
        mylead.CC_Current_Method__c=lstAlpha[7].replace('^',',');
        mylead.What_the_company_does__c=lstAlpha[8].replace('^',',');
        mylead.Industry=lstAlpha[9].replace('^',',');
        if(lstAlpha[10].replace('^',',') == null || lstAlpha[10].replace('^',',') == 'null') 
        {}
        else
        {
            mylead.What_is_the_purpose_use__c=lstAlpha[10].replace('^',',');
           
        } 
        if(lstAlpha[11].replace('^',',') == null || lstAlpha[11].replace('^',',') == 'null')
        {}
        else
        {
           // System.debug('lstAlpha[6] '+lstAlpha[7]);
            mylead.Job_Title__c=lstAlpha[11].replace('^',',');
            
        }
        
        mylead.Role_in_organisation__c=lstAlpha[12].replace('^',',');
        
        
        if(lstAlpha[13].replace('^',',') == null || lstAlpha[13].replace('^',',') == 'null')
        {
            mylead.NumberOfEmployees = 0;
            
        }
        else
        {
            mylead.Number_of_Employees_Custom__c=lstAlpha[13].replace('^',',');
        }
        
        mylead.Street=lstAlpha[14].replace('^',',');
        mylead.City=lstAlpha[15].replace('^',',');
        mylead.State=lstAlpha[16].replace('^',',');
        mylead.Country=lstAlpha[17].replace('^',',');
        mylead.CC_Remarks_1__c= lstAlpha[18].replace('^',',');
        mylead.CC_Remarks_2__c= lstAlpha[19].replace('^',',');
        mylead.CC_Remarks_3__c= lstAlpha[20].replace('^',',');
        mylead.id=lstAlpha[21].replace('^',',');
        try
        {
            update mylead;
            //For Rerendering the datatable on page
            leadList= [select Phone,id,pi__conversion_date__c,What_is_the_purpose_use__c,street,city,state,
            country,Name,Role_in_organisation__c,pi__created_date__c,Job_Title__c,PostalCode,
            What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,CC_Conversion_Date_Time__c,
            CC_Date_Added_In_Sheet__c,pi__score__c,Current_Score__c,Company,  MobilePhone,CC_Qualification__c,
            Email,Which_Product_Sent__c,CC_Sample_Required__c,Pincode_Status__c,Tell_us_about_your_application_in_one_li__c,
            CC_Current_Method__c,CC_Collected_Information__c,Industry,  CC_Market_Segment__c,NumberOfEmployees,Address,
            CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource,Manual_Organic__c from Lead 
            where Indiamart_ID__c=null AND (CC_Status__c='callback' OR CC_Status__c='' OR CC_Status__c='callback1' OR CC_Status__c='callback2') AND IsConverted=false AND Prospect_Interest_Type__c='Webinar' and  ownerID=:UserInfo.getUserId()];          
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