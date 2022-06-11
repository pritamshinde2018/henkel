Public class IndiaMartUIController
{
    public List<Lead> leadList{get;set;}
    public string paramVal{get;set;}
   	Public IndiaMartUIController()
    {}
    public IndiaMartUIController(ApexPages.StandardController controller) 
    {
        leadList= new List<Lead>();
        leadList= [select id,Indiamart_QTYPE__c,IM_Status__c,Hot_Lead__c,Product_Quantity__c,Product_Name__c,Unit__c,Time_Of_Enquiry__c,
        ENQ_CALL_DURATION__c,ENQ_MESSAGE__c,lastName,Date_Of_Enquiry__c,What_is_the_purpose_use__c,street,city,state,country,Role_in_organisation__c,
        Job_Title__c,PostalCode,What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,Company,MobilePhone,Email,Which_Product_Sent__c,
        Tell_us_about_your_application_in_one_li__c,Industry,NumberOfEmployees,Address,CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource from Lead 
        where Indiamart_QTYPE__c!='PNS' AND leadSource='Indiamart'AND (CC_Status__c='' OR CC_Status__c='callback1' OR CC_Status__c='callback2') AND ownerID=:UserInfo.getUserId() AND IsConverted=false AND Indiamart_ID__c!=null ];          
    }
    public PageReference updateLead()
    {
        string passedParam2 = system.CurrentPageReference().getParameters().get('myParam');
        passedParam2 = passedParam2.substring(1);
        List<String> lstAlpha = passedParam2.split(',');
        Lead myLead = new Lead();
        
        System.debug('lstAlpha[1] '+lstAlpha[1]);
        mylead.Hot_Lead__c=lstAlpha[1].replace('^',',');
        if(lstAlpha[2]=='null')
        {
           System.debug('lstAlpha[2] '+lstAlpha[2]);
           mylead.IM_Status__c='None'; 
        }
        else
        {
           mylead.IM_Status__c=lstAlpha[2].replace('^',',');  
        }
       	mylead.lastName=lstAlpha[3].replace('^',',');
        mylead.company=lstAlpha[4].replace('^',',');
        mylead.MOBILEPHONE=lstAlpha[5].replace('^',',');
        mylead.email=lstAlpha[6].replace('^',',');
        if(lstAlpha[7] == null || lstAlpha[7] == 'null')
        {}
        else
        {
            mylead.Which_Product_Sent__c=lstAlpha[7].replace('^',',');
        }
        mylead.Product_Name__c=lstAlpha[8].replace('^',',');
        if(lstAlpha[9].isNumeric())
        {
            mylead.Product_Quantity__c=decimal.valueOf(lstAlpha[9].replace('^',',')); 
        }
        mylead.Unit__c=lstAlpha[10].replace('^',',');
        mylead.Tell_us_about_your_application_in_one_li__c= lstAlpha[11].replace('^',',');
        mylead.What_the_company_does__c= lstAlpha[12].replace('^',',');
        mylead.Industry=lstAlpha[13].replace('^',',');
        mylead.What_is_the_purpose_use__c=lstAlpha[14].replace('^',',');
        mylead.Role_in_organisation__c=lstAlpha[15].replace('^',',');
        if(lstAlpha[16].replace('^',',') == null || lstAlpha[16].replace('^',',') == 'null')
        {
            mylead.NumberOfEmployees = 0;
        }
        else
        {
            mylead.Number_of_Employees_Custom__c=lstAlpha[16].replace('^',',');
        }
        mylead.Street=lstAlpha[17].replace('^',',');
        mylead.City=lstAlpha[18].replace('^',',');
        mylead.State=lstAlpha[19].replace('^',',');
        mylead.postalcode=lstAlpha[20].replace('^',',');
        mylead.CC_Remarks_1__c=lstAlpha[21].replace('^',',');
        mylead.CC_Remarks_2__c=lstAlpha[22].replace('^',',');
        mylead.CC_Remarks_3__c=lstAlpha[23].replace('^',',');
        mylead.id=lstAlpha[24].replace('^',',');
        try
        {
            update mylead;
            //For Rerendering the datatable on page
            leadList= [select id,Indiamart_QTYPE__c,Hot_Lead__c,IM_Status__c,Product_Quantity__c,Product_Name__c,Unit__c,Time_Of_Enquiry__c,
            ENQ_CALL_DURATION__c,ENQ_MESSAGE__c,lastName,Date_Of_Enquiry__c,What_is_the_purpose_use__c,street,city,state,country,Role_in_organisation__c,
            Job_Title__c,PostalCode,What_the_company_does__c ,Number_of_Employees_Custom__c,CC_Status__c,Company,MobilePhone,Email,Which_Product_Sent__c,
            Tell_us_about_your_application_in_one_li__c,Industry,NumberOfEmployees,Address,CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,LeadSource from Lead 
            where Indiamart_QTYPE__c!='PNS' AND leadSource='Indiamart'AND (CC_Status__c='' OR CC_Status__c='callback1' OR CC_Status__c='callback2') AND ownerID=:UserInfo.getUserId() AND IsConverted=false]; 
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