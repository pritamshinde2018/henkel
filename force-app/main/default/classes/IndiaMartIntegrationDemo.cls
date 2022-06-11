/**
* Indiamart Integration with Salesforce
* This class is scheduled for every 20 Minutes
* Created By : Akshay Phatak
* Created Date : 01/11/2018
* Updated by : Akshay Phatak
* Updated date :04/09/2020 ------Reason: Salesforce Restructuring
*/
public class IndiaMartIntegrationDemo implements Schedulable
{
    /*IndiaMartIntegration testobj=new IndiaMartIntegration();
	System.schedule('Indiamart 0','0 0 * * * ?',testobj);
	System.schedule('Indiamart 15','0 20 * * * ?',testobj);
	System.schedule('Indiamart 30','0 40 * * * ?',testobj);*/
    static List<IndiaMartWrapper> wrapperList;
    public IndiaMartWrapper iObj=new IndiaMartWrapper();
    public IndiaMartIntegrationDemo()
    {
        wrapperList=new List<IndiaMartWrapper>();
    }
    public void execute(SchedulableContext sc)
    {
        extract_LeadData();  
    }
    @future(callout=true)
    public static void extract_LeadData()
    {
        String responsebody;
        //Indiamart_Settings__c indiamartObj=Indiamart_Settings__c.getInstance(System.Label.Custom_Setting_ID);
        String mobile=System.Label.GLUSR_MOBILE;
        String mobileKey=System.Label.GLUSR_MOBILE_KEY;
        Datetime EndTime1 = System.now();
        String EndTime=System.Label.Indiamart_EndDate;
        System.debug('EndTime '+Endtime);
        //Datetime StartTime1=EndTime1.addMinutes(-20);
        String StartTime=System.Label.Indiamart_StartDate;
        System.debug('StartTime '+StartTime);
        HttpRequest request=new HttpRequest();
        System.debug('StartTime'+StartTime);
        System.debug('EndTime '+EndTime);
        String endpoint='http://mapi.indiamart.com/wservce/enquiry/listing/GLUSR_MOBILE/8329380527/GLUSR_MOBILE_KEY/ODMyOTM4MDUyNyM4NzQ2MTQz/Start_Time/'+StartTime+'/End_Time/'+EndTime+'/';
        System.debug('endpoint '+endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        //request.setTimeout(120000);
        Http http=new Http(); 
        HttpResponse response=http.send(request);
        System.debug('response '+response);
        System.debug('response Body '+response.getBody());
       	responsebody=response.getbody();
        //responsebody = '{"RN":"12","QUERY_ID":"786798740","QTYPE":"P","SENDERNAME":"Phunsukhbhai2.Wangadu","SENDEREMAIL":"Phunsukhbhai2.Wangadu@usweek.net","SUBJECT":"Requirement for Loctite 272 Threadlocker","DATE_RE":"18 Nov 2018","DATE_R":"18-Nov-18","DATE_TIME_RE":" 18-Nov-2018 09:34:35 AM","GLUSR_USR_COMPANYNAME":"mahindra","READ_STATUS":"-1","SENDER_GLUSR_USR_ID":"6811004","MOB":"+91-8181811814","COUNTRY_FLAG":"http:abncgvhhsbb","QUERY_MODID":"ASTBUY","LOG_TIME":"20181118093435","QUERY_MODREFID":"26219836675","DIR_QUERY_MODREF_TYPE":"0","ORG_SENDER_GLUSR_ID":"6811004","ENQ_MESSAGE":"I want to buy Loctite 272 Threadlocker.Kindly send me price and other details.Quantity: 2 Unit Grade Standard: Industrial Grade  Packaging Size: Box  Currency: INR - Indian Rupee Approximate Order Value: 1,000 to 3,000 Why do you need this: For Business Use ","ENQ_ADDRESS":", Nashik, Maharashtra, ","ENQ_CALL_DURATION":null,"ENQ_RECEIVER_MOB":null,"ENQ_CITY":"Nashik","ENQ_STATE":"Maharashtra","PRODUCT_NAME":"Loctite 272 Threadlocker","COUNTRY_ISO":"IN","EMAIL_ALT":null,"MOBILE_ALT":null,"PHONE":"+91536608050","PHONE_ALT":null,"IM_MEMBER_SINCE":"Feb-2013","TOTAL_COUNT":"15"}';
        if(responsebody.substring(0,1)=='[')
        {
            wrapperList=(List<IndiaMartWrapper>)JSON.deserialize(responsebody,List<IndiaMartWrapper>.class);  
        }
        else
        {
            responsebody='['+responsebody+']';
            wrapperList=(List<IndiaMartWrapper>)JSON.deserialize(responsebody,List<IndiaMartWrapper>.class);  
        }
        System.debug('wrapperList '+wrapperList);
        /* Map<String,Lead> leadMap=new Map<String,Lead>();
        for(Lead lObj : [Select id,Indiamart_ID__c from Lead])
        {
        leadMap.put(lObj.Indiamart_ID__c,lObj);
        }*/
        List<Lead> leadList=new List<Lead>();
        List<Lead> leadUpdateList=new List<Lead>();
        List<CTA__c> ctainsert=new List<CTA__c>();
        for(IndiaMartWrapper obj  : wrapperList)
        {
            List<Lead> existing_LeadList=new List<Lead>();
            System.debug('obj.MOB---- '+obj.MOB);
            System.debug('obj.MOBILE_ALT---- '+obj.MOBILE_ALT );
            if((obj.MOB!=null && obj.MOBILE_ALT!=null) && obj.SENDEREMAIL != null)
            {
                existing_LeadList=[Select id,leadsource,Company,Email,mobilephone from lead where (mobilephone= :obj.MOB or mobilephone=:obj.MOBILE_ALT OR Email =:obj.SENDEREMAIL) order by createddate desc]; 
            }
            else if(obj.MOB!=null && obj.SENDEREMAIL != null)
            {
                existing_LeadList=[Select id,Company,leadsource,mobilephone from lead where (mobilephone= :obj.MOB OR Email =:obj.SENDEREMAIL) order by createddate desc];  
            }
            
            System.debug('existing_LeadList---- '+existing_LeadList);
            if(existing_LeadList.size()>0)
            {
                        Lead lObj=new Lead();
                        lObj=existing_LeadList[0];
                        if(obj.ENQ_ADDRESS!=null)
                        {
                            lObj.PostalCode=obj.ENQ_ADDRESS.substringAfterLast(',');
                            lobj.Street=obj.ENQ_ADDRESS.substringBeforeLast(',').substringBeforeLast(',').substringBeforeLast(',');
                        }
                        if(obj.SENDERNAME==null && (lObj.LastName==null || lObj.LastName=='NA'))
                        {
                            lObj.LastName='NA';  
                        }
                        else
                        {
                            lObj.LastName=obj.SENDERNAME; 
                        }
                        if(obj.GLUSR_USR_COMPANYNAME==null && (lObj.Company==null || lObj.Company=='NA') )
                        {
                            if(existing_LeadList[0].Company != null){
                            lObj.Company = existing_LeadList[0].Company;  
                            }
                            else{
                                lObj.Company='NA';
                            }
                        }
                        else if(lObj.Company==null && obj.GLUSR_USR_COMPANYNAME!=null)
                        {
                            lObj.Company=obj.GLUSR_USR_COMPANYNAME;  
                        }
                        lobj.Indiamart_ID__c=obj.QUERY_ID;
                        if(obj.QTYPE=='W')
                        {
                            lObj.Indiamart_QTYPE__c='Contact Suppliers';  
                        }
                        else if(obj.QTYPE=='B')
                        {
                            lObj.Indiamart_QTYPE__c='Buy Leads';  
                        }
                        else
                        {
                            lObj.Indiamart_QTYPE__c='PNS';  
                        }
                        lobj.MobilePhone=obj.MOB;
                        if(obj.PHONE!=null)
                        {
                            lobj.Phone=(String)obj.PHONE;  
                        }
                        if(obj.PHONE_ALT!=null)
                        {
                            lobj.PHONE_ALT__c=(String)obj.PHONE_ALT;  
                        }
                        lObj.Email=obj.SENDEREMAIL; 
                        lobj.Subject__c=obj.SUBJECT;
                        lObj.Date_Of_Enquiry__c=obj.DATE_RE;
                        lobj.Time_Of_Enquiry__c=obj.DATE_TIME_RE;
                        lobj.COUNTRY_FLAG__c=obj.COUNTRY_FLAG;
                        lObj.QUERY_MODID__c=obj.QUERY_MODID;
                        lobj.LOG_TIME__c=obj.LOG_TIME;
                        lobj.QUERY_MODREFID__c=obj.QUERY_MODREFID;
                        lobj.DIR_QUERY_MODREF_TYPE__c=obj.DIR_QUERY_MODREF_TYPE;
                        lObj.ORG_SENDER_GLUSR_ID__c=obj.ORG_SENDER_GLUSR_ID;
                        lobj.ENQ_MESSAGE__c=obj.ENQ_MESSAGE;
                        if(obj.ENQ_CALL_DURATION!=null)
                        {
                            lobj.ENQ_CALL_DURATION__c=(String)obj.ENQ_CALL_DURATION;  
                        }
                        lobj.City=obj.ENQ_CITY;
                        lobj.State=obj.ENQ_STATE;
                        lObj.Product_Name__c=obj.PRODUCT_NAME;
                        lobj.Country=Obj.COUNTRY_ISO;
                        if(obj.EMAIL_ALT!=null)
                        {
                            lobj.EMAIL_ALT__c=(String)obj.EMAIL_ALT;  
                        }
                        lobj.Indiamart_Member_Since__c=obj.IM_MEMBER_SINCE;
                        lObj.TOTAL_COUNT__c=obj.TOTAL_COUNT;
                        if(lObj.LeadSource==null)
                            lObj.LeadSource='Indiamart';
                        leadUpdateList.add(lObj);
                        Id recTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Indiamart').getRecordTypeId();
                        CTA__c cta=new CTA__c();
                        cta.RecordTypeId=recTypeId;
                        cta.Lead__c=lObj.id;
                        cta.Indiamart_ID__c=obj.QUERY_ID;
                        if(obj.QTYPE=='W')
                        {
                            cta.Indiamart_QTYPE__c='Contact Suppliers';  
                        }
                        else if(obj.QTYPE=='B')
                        {
                            cta.Indiamart_QTYPE__c='Buy Leads';  
                        }
                        else
                        {
                            cta.Indiamart_QTYPE__c='PNS';  
                        }
                        if(obj.PHONE_ALT!=null)
                        {
                            cta.PHONE_ALT__c=(String)obj.PHONE_ALT;  
                        }
                        cta.Subject__c=obj.SUBJECT;
                        cta.Date_Of_Enquiry__c=obj.DATE_RE;
                        cta.Time_Of_Enquiry__c=obj.DATE_TIME_RE;
                        cta.COUNTRY_FLAG__c=obj.COUNTRY_FLAG;
                        cta.QUERY_MODID__c=obj.QUERY_MODID;
                        cta.LOG_TIME__c=obj.LOG_TIME;
                        cta.QUERY_MODREFID__c=obj.QUERY_MODREFID;
                        cta.DIR_QUERY_MODREF_TYPE__c=obj.DIR_QUERY_MODREF_TYPE;
                        cta.ORG_SENDER_GLUSR_ID__c=obj.ORG_SENDER_GLUSR_ID;
                        cta.ENQ_MESSAGE__c=obj.ENQ_MESSAGE;
                        if(obj.ENQ_CALL_DURATION!=null)
                        {
                            cta.ENQ_CALL_DURATION__c=(String)obj.ENQ_CALL_DURATION;  
                        }
                        if(obj.EMAIL_ALT!=null)
                        {
                            cta.EMAIL_ALT__c=(String)obj.EMAIL_ALT;  
                        }
                        cta.Indiamart_Member_Since__c=obj.IM_MEMBER_SINCE;
                        cta.TOTAL_COUNT__c=obj.TOTAL_COUNT;
                        ctainsert.add(cta);
                    }
             
            else
            {
                Lead lObj=new Lead();
                Lead lObjRef=new Lead();
                lObjRef.Indiamart_ID__c=obj.QUERY_ID;
                lobj.MOBILE_ALT__c=obj.MOBILE_ALT;
                if(obj.ENQ_ADDRESS!=null)
                {
                    lObj.PostalCode=obj.ENQ_ADDRESS.substringAfterLast(',');
                    lobj.Street=obj.ENQ_ADDRESS.substringBeforeLast(',').substringBeforeLast(',').substringBeforeLast(',');
                }
                if(obj.SENDERNAME==null)
                {
                    lObj.LastName='NA';  
                }
                else
                {
                    lObj.LastName=obj.SENDERNAME; 
                }
                if(obj.GLUSR_USR_COMPANYNAME==null)
                {
                    lObj.Company='NA';  
                }
                else
                {
                    lObj.Company=obj.GLUSR_USR_COMPANYNAME;  
                }
                lobj.Indiamart_ID__c=obj.QUERY_ID;
                if(obj.QTYPE=='W')
                {
                    lObj.Indiamart_QTYPE__c='Contact Suppliers';  
                }
                else if(obj.QTYPE=='B')
                {
                    lObj.Indiamart_QTYPE__c='Buy Leads';  
                }
                else
                {
                    lObj.Indiamart_QTYPE__c='PNS';  
                }
                lobj.MobilePhone=obj.MOB;
                if(obj.PHONE!=null)
                {
                    lobj.Phone=(String)obj.PHONE;  
                }
                if(obj.PHONE_ALT!=null)
                {
                    lobj.PHONE_ALT__c=(String)obj.PHONE_ALT;  
                }
                lObj.Email=obj.SENDEREMAIL; 
                lobj.Subject__c=obj.SUBJECT;
                lObj.Date_Of_Enquiry__c=obj.DATE_RE;
                lobj.Time_Of_Enquiry__c=obj.DATE_TIME_RE;
                lobj.COUNTRY_FLAG__c=obj.COUNTRY_FLAG;
                lObj.QUERY_MODID__c=obj.QUERY_MODID;
                lobj.LOG_TIME__c=obj.LOG_TIME;
                lobj.QUERY_MODREFID__c=obj.QUERY_MODREFID;
                lobj.DIR_QUERY_MODREF_TYPE__c=obj.DIR_QUERY_MODREF_TYPE;
                lObj.ORG_SENDER_GLUSR_ID__c=obj.ORG_SENDER_GLUSR_ID;
                lobj.ENQ_MESSAGE__c=obj.ENQ_MESSAGE;
                if(obj.ENQ_CALL_DURATION!=null)
                {
                    lobj.ENQ_CALL_DURATION__c=(String)obj.ENQ_CALL_DURATION;  
                }
                lobj.City=obj.ENQ_CITY;
                lobj.State=obj.ENQ_STATE;
                lObj.Product_Name__c=obj.PRODUCT_NAME;
                lobj.Country=Obj.COUNTRY_ISO;
                if(obj.EMAIL_ALT!=null)
                {
                    lobj.EMAIL_ALT__c=(String)obj.EMAIL_ALT;  
                }
                lobj.Indiamart_Member_Since__c=obj.IM_MEMBER_SINCE;
                lObj.TOTAL_COUNT__c=obj.TOTAL_COUNT;
                lObj.LeadSource='Indiamart';
                leadList.add(lobj);  
                
                
                Id recTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('Indiamart').getRecordTypeId();
                CTA__c cta=new CTA__c();
                cta.Lead__r= lObjRef;
                cta.RecordTypeId=recTypeId;
                //cta.Lead__c=lObj.id;
                cta.Indiamart_ID__c=obj.QUERY_ID;
                if(obj.QTYPE=='W')
                {
                    cta.Indiamart_QTYPE__c='Contact Suppliers';  
                }
                else if(obj.QTYPE=='B')
                {
                    cta.Indiamart_QTYPE__c='Buy Leads';  
                }
                else
                {
                    cta.Indiamart_QTYPE__c='PNS';  
                }
                if(obj.PHONE_ALT!=null)
                {
                    cta.PHONE_ALT__c=(String)obj.PHONE_ALT;  
                }
                cta.Subject__c=obj.SUBJECT;
                cta.Date_Of_Enquiry__c=obj.DATE_RE;
                cta.Time_Of_Enquiry__c=obj.DATE_TIME_RE;
                cta.COUNTRY_FLAG__c=obj.COUNTRY_FLAG;
                cta.QUERY_MODID__c=obj.QUERY_MODID;
                cta.LOG_TIME__c=obj.LOG_TIME;
                cta.QUERY_MODREFID__c=obj.QUERY_MODREFID;
                cta.DIR_QUERY_MODREF_TYPE__c=obj.DIR_QUERY_MODREF_TYPE;
                cta.ORG_SENDER_GLUSR_ID__c=obj.ORG_SENDER_GLUSR_ID;
                cta.ENQ_MESSAGE__c=obj.ENQ_MESSAGE;
                if(obj.ENQ_CALL_DURATION!=null)
                {
                    cta.ENQ_CALL_DURATION__c=(String)obj.ENQ_CALL_DURATION;  
                }
                if(obj.EMAIL_ALT!=null)
                {
                    cta.EMAIL_ALT__c=(String)obj.EMAIL_ALT;  
                }
                cta.Indiamart_Member_Since__c=obj.IM_MEMBER_SINCE;
                cta.TOTAL_COUNT__c=obj.TOTAL_COUNT;
                ctainsert.add(cta);
                
            }
            
        }
        try{     
            if(leadList.size()!=0)
            {
                Insert leadList;
            }
            if(leadUpdateList.size()>0)
            {
                try{
                update leadUpdateList; 
                }catch(Exception e)
                {
                    system.debug('error : '+e.getMessage()+' line no.: '+e.getLineNumber());
                }
            }
            if(ctainsert.size()>0)
            {
                Insert ctainsert;    
            }
        }catch(Exception e)
            {
                system.debug('Exception '+e.getCause()+' lIne :'+e.getLineNumber()+' Message :'+e.getMessage());
            }
        }
    
}