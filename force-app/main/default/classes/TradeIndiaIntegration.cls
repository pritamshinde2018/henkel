/**
* Indiamart Integration with Salesforce
* This class is scheduled for every 20 Minutes
* Created By : Pritam Shinde
* Created Date : 25/10/2021
* Created by : Pritam Shinde
*/
public class TradeIndiaIntegration implements Schedulable
{
    /*TradeIndiaIntegration testobj=new TradeIndiaIntegration();
	System.schedule('TradeIndia 0','0 0 * * * ?',testobj);*/
    
    
    static List<TradeIndiaWrapper> wrapperList;
    public TradeIndiaWrapper iObj=new TradeIndiaWrapper();
    
    public TradeIndiaIntegration()
    {
        wrapperList=new List<TradeIndiaWrapper>();
    }
    
    public void execute(SchedulableContext sc)
    {
        extract_LeadData();  
    }
    
    @future(callout=true)
    public static void extract_LeadData()
    {
        String responsebody;
        try
        {
            String userid = System.Label.TradeIndia_userid;
            String profile_id = System.label.TradeIndia_profile_id;
            String key = System.label.TradeIndia_Key;
            Datetime to_date1 = System.now();
            String to_date=to_date1.format('yyyy-MM-dd%20HH:mm:ss','Asia/Kolkata');
            System.debug('to_date1 '+to_date1);
            Datetime from_date1=to_date1.addMinutes(-60);
            String from_date=from_date1.format('yyyy-MM-dd%20HH:mm:ss','Asia/Kolkata');
            System.debug('from_date1 '+from_date1);
            HttpRequest request=new HttpRequest();
            //String endpoint ='https://www.tradeindia.com/utils/my_inquiry.html?userid='+userid+'&profile_id='+profile_id+'&key='+key+'&from_date=2021-11-26%2011:00:00&to_date=2021-11-26%2012:00:00/';
            String endpoint ='https://www.tradeindia.com/utils/my_inquiry.html?userid='+userid+'&profile_id='+profile_id+'&key='+key+'&from_date='+from_date+'&to_date='+to_date+'/';
            System.debug('endpoint '+endpoint);
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setTimeout(50000);
            Http http=new Http(); 
            HttpResponse response=http.send(request);
            System.debug('response '+response);
            System.debug('response Body '+response.getBody());
            responsebody=response.getbody();
            
            if(responsebody.substring(0,1)=='[')
            {
                wrapperList=(List<TradeIndiaWrapper>)JSON.deserialize(responsebody,List<TradeIndiaWrapper>.class);  
            }
            else
            {
                responsebody='['+responsebody+']';
                wrapperList=(List<TradeIndiaWrapper>)JSON.deserialize(responsebody,List<TradeIndiaWrapper>.class);  
            }
            System.debug('wrapperList '+wrapperList);
            
            List<Lead> leadList=new List<Lead>();
            List<Lead> leadUpdateList=new List<Lead>();
            List<CTA__c> ctainsert=new List<CTA__c>();
            if(wrapperList.size() > 0)   
            {   
                for(TradeIndiaWrapper obj : wrapperList)
                {
                    List<Lead> existing_LeadList=new List<Lead>();
                    
                    System.debug('obj.MOB---- '+obj.sender_mobile);
                    if(obj.sender_mobile!=null)
                    {
                        existing_LeadList=[Select id,leadsource,Company,ENQ_MESSAGE__c from lead where phone= :obj.sender_mobile order by createddate desc]; 
                    }
                    
                    System.debug('existing_LeadList---- '+existing_LeadList);
                    
                    if(existing_LeadList.size()>0)
                    {
                        Lead lObj=new Lead();
                        lObj=existing_LeadList[0];
                        
                        if(obj.address != null)
                        {
                            lobj.street = obj.address;
                            lObj.PostalCode=obj.address.substringAfterLast(',');
                        }
                        
                        if(obj.sender_name==null && (lObj.LastName==null || lObj.LastName=='NA'))
                        {
                            lObj.LastName='NA';  
                        }
                        else
                        {
                            lObj.LastName=obj.sender_name; 
                        }
                        
                        if(obj.sender_co==null && (lObj.Company==null || lObj.Company=='NA') )
                        {
                            lObj.Company='NA';  
                        }
                        else
                        {
                            lObj.Company=obj.sender_co;  
                        }
                        
                        lobj.Ecom_media__c=obj.sender_uid;
                        lObj.Indiamart_QTYPE__c=obj.inquiry_type;
                        
                        if(obj.sender_mobile != null)
                        {
                            lobj.phone = obj.sender_mobile;
                        }
                        
                        lobj.Email = obj.sender_email;
                        lobj.Subject__c = obj.subject;
                        lObj.Date_Of_Enquiry__c=obj.generated_date;
                        lobj.Time_Of_Enquiry__c=obj.generated_time;
                        lobj.State = obj.sender_state;
                        lobj.City = obj.sender_city;
                        lobj.Product_Name__c = obj.product_name;
                        lobj.Country = obj.sender_country;
                        lobj.Ecom_Source__c = obj.product_source;
                        
                        //System.debug('Is numeric quantity' +obj.quantity.isNumeric());
                        if(obj.quantity != null && obj.quantity.isNumeric())
                            lobj.Product_Quantity__c = decimal.valueOf(obj.quantity);
                        
                        if(obj.rfi_id != null)
                            lobj.Indiamart_ID__c = obj.rfi_id;
                        
                        if(lobj.ENQ_MESSAGE__c == null)
                            lobj.ENQ_MESSAGE__c = obj.message;
                        
                        if(lObj.LeadSource==null)
                            lObj.LeadSource='TradeIndia';
                        leadUpdateList.add(lObj);
                        Id recTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('TradeIndia').getRecordTypeId();
                        CTA__c cta=new CTA__c();
                        cta.RecordTypeId=recTypeId;
                        cta.Lead__c=lObj.id;
                        cta.Indiamart_ID__c=obj.rfi_id;
                        cta.Indiamart_QTYPE__c = obj.inquiry_type;
                        cta.Subject__c = obj.subject;
                        cta.Date_Of_Enquiry__c = obj.generated_date;
                        cta.Time_Of_Enquiry__c = obj.generated_time;
                        cta.Enquiry_Message__c = obj.message;
                        cta.EMAIL_ALT__c = obj.sender_email;
                        ctainsert.add(cta);
                    }
                    else
                    {
                        Lead lObj=new Lead();
                        Lead lObjRef=new Lead();
                        lObjRef.Indiamart_ID__c = obj.rfi_id;
                        lobj.Indiamart_ID__c =obj.rfi_id;
                        lobj.Phone = obj.sender_mobile;
                        if(obj.address != null)
                        {
                            lobj.street = obj.address;
                            lObj.PostalCode=obj.address.substringAfterLast(',');
                        }
                        
                        if(obj.sender_name==null && (lObj.LastName==null || lObj.LastName=='NA'))
                        {
                            lObj.LastName='NA';  
                        }
                        else
                        {
                            lObj.LastName=obj.sender_name; 
                        }
                        
                        if(obj.sender_co==null && (lObj.Company==null || lObj.Company=='NA') )
                        {
                            lObj.Company='NA';  
                        }
                        else
                        {
                            lObj.Company=obj.sender_co;  
                        }
                        
                        lobj.Ecom_media__c=obj.sender_uid;
                        lObj.Indiamart_QTYPE__c=obj.inquiry_type;
                        
                        if(obj.sender_mobile != null)
                        {
                            lobj.phone = obj.sender_mobile;
                        }
                        
                        lobj.Email = obj.sender_email;
                        lobj.Subject__c = obj.subject;
                        lObj.Date_Of_Enquiry__c=obj.generated_date;
                        lobj.Time_Of_Enquiry__c=obj.generated_time;
                        lobj.State = obj.sender_state;
                        lobj.City = obj.sender_city;
                        lobj.Product_Name__c = obj.product_name;
                        lobj.Country = obj.sender_country;
                        lobj.Ecom_Source__c = obj.product_source;
                        
                        if(obj.quantity != null && obj.quantity.isNumeric())
                            lobj.Product_Quantity__c = decimal.valueOf(obj.quantity);
                        
                        if(obj.rfi_id != null)
                            lobj.Indiamart_ID__c = obj.rfi_id;
                        
                        if(lobj.ENQ_MESSAGE__c == null)
                            lobj.ENQ_MESSAGE__c = obj.message;
                        
                        if(lObj.LeadSource==null)
                            lObj.LeadSource='TradeIndia';
                        
                        leadList.add(lobj);  
                        
                        Id recTypeId = Schema.SObjectType.CTA__c.getRecordTypeInfosByName().get('TradeIndia').getRecordTypeId();
                        CTA__c cta=new CTA__c();
                        cta.Lead__r= lObjRef;
                        cta.RecordTypeId=recTypeId;
                        cta.Indiamart_ID__c=obj.rfi_id;
                        cta.Indiamart_QTYPE__c = obj.inquiry_type;
                        cta.Subject__c = obj.subject;
                        cta.Date_Of_Enquiry__c = obj.generated_date;
                        cta.Time_Of_Enquiry__c = obj.generated_time;
                        cta.Enquiry_Message__c = obj.message;
                        cta.EMAIL_ALT__c = obj.sender_email;
                        ctainsert.add(cta);
                        
                    }
                }
            }
            if(leadList.size()!=0)
            {
                Insert leadList;
            }
            if(leadUpdateList.size()>0)
            {
                update leadUpdateList; 
            }
            if(ctainsert.size()>0)
            {
                    Insert ctainsert; 
            }
            
        }
        catch(Exception e)
        {
            system.debug('error'+e);
            system.debug('error'+e.getLineNumber());
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'pritam.shinde@nanostuffs.com'};
            message.setSubject('TradeIndia Error from TradeIndiaIntegration Class') ;
            message.setPlainTextBody(e.getMessage()+'--'+e.getLineNumber()+'/n'+responsebody);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
    
}