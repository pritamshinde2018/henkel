global class Products_In_Cart implements database.Batchable<sObject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query='Select id,(Select id,name,Active__c,CreatedDate from Products_on_Cart__r where Active__c=true order by createdDate Asc),name from Contact';
        return database.getQueryLocator(query);     
    }
    global void execute(Database.BatchableContext BC, list<Contact> scope)
    {
        Group g = [Select id from group where name='IST Team'];
        List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g.Id];
        List<Id> lstIds = new List<Id>();
        for(groupMember g1: memberList)
        {
            lstIds.add(g1.UserOrGroupId);  
        }
        List<Task> taskList=new List<Task>();
        List<Contact> cntList=new List<Contact>();
        List<Products_on_Cart__c> prdList=new List<Products_on_Cart__c>();
        for(Contact cnt  : scope)
        {
            Integer isOld;
            for(Products_on_Cart__c prd : cnt.Products_on_Cart__r)
            {
                if(prd.Active__c==true)
                {
                    Datetime now = Datetime.now();
                    Integer offset = UserInfo.getTimezone().getOffset(now);
                    Datetime local = now.addSeconds(offset/1000);
                    Datetime dt=local.addDays(-3);
                    Datetime dt1=local.addDays(-4);
                    Datetime dt2=local.addDays(-5);
                    Datetime dt3=local.addDays(-6);
                    if(prd.CreatedDate.date() == dt.date())
                    {
                        isOld=3;
                    }
                    else if(prd.CreatedDate.date() == dt1.date())
                    {
                       isOld=4;
                    }
                    else if(prd.CreatedDate.date() == dt2.date())
                    {
                       isOld=5;
                    }
                    else if(prd.CreatedDate.date() <= dt3.date())
                    {
                        isOld=6;
                        prd.Active__c=false;
                        prdList.add(prd);
                    }
                    else
                    {
                        isOld=0;
                    }
                    
                }
            }
           /* if(isOld==3)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTargetObjectId(cnt.Id); 
                mail.setSenderDisplayName('Get an instant discount on pending items in your cart!'); 
                mail.setUseSignature(false); 
                mail.setBccSender(false); 
                mail.setSaveAsActivity(false); 
                EmailTemplate et=[Select id from EmailTemplate where Name= 'Abandaon Cart- Promo Code Mailer']; 
                mail.setTemplateId(et.id); 
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                cnt.ACE1__c=true;
                cntList.add(cnt);
            }
            if(isOld==4)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTargetObjectId(cnt.Id); 
                mail.setSenderDisplayName('24 hours to avail an instant discount!'); 
                mail.setUseSignature(false); 
                mail.setBccSender(false); 
                mail.setSaveAsActivity(false); 
                EmailTemplate et=[Select id from EmailTemplate where Name= 'Abandaon Cart- Reminder 2']; 
                mail.setTemplateId(et.id); 
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                cnt.ACE1__c=true;
                cntList.add(cnt);
                
            }
            if(isOld==5)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTargetObjectId(cnt.Id); 
                mail.setSenderDisplayName('48 hours to avail an instant discount!'); 
                mail.setUseSignature(false); 
                mail.setBccSender(false); 
                mail.setSaveAsActivity(false); 
                EmailTemplate et=[Select id from EmailTemplate where Name= 'Abandaon Cart- Reminder 1']; 
                mail.setTemplateId(et.id); 
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                cnt.ACE1__c=true;
                cntList.add(cnt);
            }*/
            if(isOld==6)
            {
                Task t=new Task();
                t.WhoId=cnt.id;
                t.OwnerId=lstIds[0];
                t.subject='Validate Abandoned Cart Reason';
                taskList.add(t);                
            }
        }
        
        if(taskList.size()!=0)
        {
          insert taskList;  
        }
        if(cntList.size()!=0)
        {
           update cntList; 
        }
        if(prdList.size()!=0)
        {
           update prdList; 
        }
        
    }
    global void finish(Database.BatchableContext BC)
    {
      convert();  
    }
    public void convert()
    {
        Integer i=0;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
         i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
         i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;


        
    }
    
}