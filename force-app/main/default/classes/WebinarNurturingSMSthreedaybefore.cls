global class WebinarNurturingSMSthreedaybefore  implements Schedulable  {
    //list<Lead> l1=new list<Lead>();
    //l1=[select id,Webinar_Name1__c,Webinar_Machine__c from lead where Webinar_Name1__c !=NUll and IsConverted!=TRUE];
    List<Lead> leadlist=new List<Lead>();
    List<Lead> leadstobeUpdated=new List<Lead>();
 global void execute(SchedulableContext ctx)
 {
    List<Lead> l=[select id, Phone, Webinar_Name1__c, Webinar_Machine1__c, Couldnt_Attend_SMS__c, Email_Encrypted__c from lead where Webinar_Id_1__c!=NUll and Email_Encrypted__c !=NULL and IsConverted!=TRUE and  Couldnt_Attend_SMS__c!=true and Is_Webinar_Attended1__c!=true limit 38 ];
   
    for(Lead Newlead:l)
    {
         string msg='Couldn’t watch the live session of LOCTITE Masterclass. Don’t worry, we have you covered. You can now watch it on demand on this link: https://www.tryloctite.in/webinar/recorded-video?webinar=threadlocker-second. Also you can avail and exclusive offer on your first purchase. Click on www.tryloctite.in/estore and get upto 50% discount now.';
        //System.debug('List of lead'+Newlead);
        SendSMS_Helper.sendSMSMessage(Newlead.Phone,msg);
        Newlead.Couldnt_Attend_SMS__c=true;
        leadstobeUpdated.add(Newlead);
    }
     if(leadstobeUpdated.size()!=0)
     {
         update leadstobeUpdated;
     }
 }
}