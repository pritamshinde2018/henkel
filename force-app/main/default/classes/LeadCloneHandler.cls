public class LeadCloneHandler 
{
    public static JSON2Apex wrapper {get;set;}  
    public List<Lead> accList{get;set;}
    
    public LeadCloneHandler()
    {
        wrapper = new JSON2Apex(); 
    } 
    
    public static void ParseData(List<LeadClone__c> cloneData)
    {  
        System.debug('I am in ParseData Method');
        System.debug('cloneData[0] '+cloneData[0]);
        String cloneId = cloneData[0].id;
        
        List<LeadClone__c> leadClone = new List<LeadClone__c>();
        Lead myLead = new Lead();
        wrapper = (JSON2Apex) System.JSON.deserialize(cloneData[0].LeadQuery__c,JSON2Apex.class);
        myLead.id = wrapper.id;          
        mylead.Tell_us_about_your_application_in_one_li__c=wrapper.Tell_us_about_your_application_in_one_li;
        mylead.CC_Current_Method__c=wrapper.CC_Current_Method;
        mylead.What_the_company_does__c=wrapper.What_the_company_does;
        mylead.Industry=wrapper.Industry;
        mylead.What_is_the_purpose_use__c =wrapper.What_is_the_purpose_use;       
        mylead.Job_Title__c =wrapper.Job_Title;
		mylead.Role_in_organisation__c =wrapper.Role_in_organisation;
        
        System.debug('Number of Employees------------'+wrapper.Number_of_Employees_Custom);
        if(wrapper.Number_of_Employees_Custom!='0')
        {
            mylead.Number_of_Employees_Custom__c = wrapper.Number_of_Employees_Custom;   
        }
       
         mylead.CC_Remarks_1__c =wrapper.CC_Remarks_1;
        mylead.CC_Remarks_2__c =wrapper.CC_Remarks_2;
        mylead.CC_Remarks_3__c =wrapper.CC_Remarks_3;
        mylead.Street=wrapper.Street;
        mylead.City=wrapper.City;
        mylead.State=wrapper.State;
        mylead.Country=wrapper.Country;      
        update mylead;
        leadClone = [SELECT ID FROM LeadClone__c WHERE ID=:cloneId];
        
        delete leadClone;
        
    }

}