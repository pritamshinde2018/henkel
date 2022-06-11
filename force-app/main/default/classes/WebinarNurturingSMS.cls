global class WebinarNurturingSMS implements Schedulable  {
    //list<Lead> l1=new list<Lead>();
    //l1=[select id,Webinar_Name1__c,Webinar_Machine__c from lead where Webinar_Name1__c !=NUll and IsConverted!=TRUE];
    List<Lead> leadlist=new List<Lead>();
    List<Lead> leadstobeUpdated=new List<Lead>();
 global void execute(SchedulableContext ctx)
 {
    List<Lead> l=[select id,Phone,Webinar_Id__c,Webinar_Name1__c,Webinar_Machine1__c,Reminder_SMS2__c,Email_Encrypted__c from lead where  Webinar_Id__c LIKE '1614' and IsConverted!=TRUE and Webinar_Name__c!=NULL and Webinar_Name1__c!='Threadlockers' and Reminder_SMS2__c!=TRUE LIMIT 35];
   
    for(Lead Newlead:l)
    {
         string msg='LOCTITE Masterclass on threadlockers goes live tomorrow at 11 a.m. Click this link  https://www.tryloctite.in/webinar to learn practical solutions for reducing plant downtime.';
        System.debug('List of lead'+Newlead);
        SendSMS_Helper.sendSMSMessage(Newlead.Phone,msg);
        Newlead.Reminder_SMS2__c=true;
        leadstobeUpdated.add(NewLead);
       
    }
          if(leadstobeUpdated.size()!=0)
     {
         update leadstobeUpdated;
     }
 }
}