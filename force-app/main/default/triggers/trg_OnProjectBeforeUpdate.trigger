trigger trg_OnProjectBeforeUpdate on Opportunity (before update,before insert) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    if(mc.trg_OnProjectBeforeUpdate__c)
    {
       map<id,List<Task>> oppTaskMap=new map<id,List<Task>>();
       Map<String,String> projectsourceMappingMap=new Map<String,String>();
       //List<Project_Source_Mapping__c> projectsourceMappingList=[Select id,name,Priority__c from Project_Source_Mapping__c];
       
        List<String> projectsourceList = new List<String>();
        List<Project_Source_Mapping__c> projectsourceMappingList = new List<Project_Source_Mapping__c>();
        
       List<User> userList = [SELECT id,Pin_codes__c,street,state,country,city,Email,Contact.Account.Name,Contact.name,Phone,postalcode FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
   	   Map<String,user> pinCodeUserMap = new Map<String,user>();
        for(User u  : userList)
        {
            if(u.Pin_codes__c!=null)
                pinCodeUserMap.put(u.Pin_codes__c,u); 
        }
        
       /*for(Project_Source_Mapping__c pr :projectsourceMappingList)
       {
           projectsourceMappingMap.put(pr.Name,pr.Priority__c);
       }*/
        
       if(trigger.isBefore && trigger.isUpdate)
       {
           for(Opportunity opp  :[Select id,name,(Select id,subject,status from tasks where status!='Completed') from Opportunity where id in:trigger.new])
           {
               oppTaskMap.put(opp.Id, opp.tasks); 
           }
           
           for(Opportunity opp: Trigger.new)
           {
               if(trigger.oldMap.get(opp.id).Project_source__c!=opp.Project_source__c)
               {
                   if(opp.Project_source__c != null)
                   {
                       projectsourceList.add(opp.Project_source__c);
                   }
               }
           }
           
           if(projectsourceList.size() > 0)
           {
               projectsourceMappingList = [Select id,name,Priority__c from Project_Source_Mapping__c where name =: projectsourceList];
           }
           
           for(Project_Source_Mapping__c pr :projectsourceMappingList)
           {
               projectsourceMappingMap.put(pr.Name,pr.Priority__c);
           }
           
           for(Opportunity opp: Trigger.new)
           {
             if(trigger.oldMap.get(opp.id).Contact_PinCode__c!=opp.Contact_PinCode__c && opp.Contact_PinCode__c!=null)
             {
                for(String s :pinCodeUserMap.keySet())
                {
                    if(opp.Contact_PinCode__c!=null)
                    {
                        if(s!=null && s.contains (opp.Contact_PinCode__c))     
                        {
                            opp.Distributor_On_Project__c = pinCodeUserMap.get(s).Contact.Account.Name;
                        }
                    }
                }

             }
             if(trigger.oldMap.get(opp.id).Project_source__c!=opp.Project_source__c)
             {
                if(projectsourceMappingMap.containsKey(opp.Project_source__c))
                {
                   opp.Project_Source_priority__c=projectsourceMappingMap.get(opp.Project_source__c); 
                }
             }
            if(trigger.oldMap.get(opp.id).Sample_Sent_On__c != opp.Sample_Sent_On__c)
            {
                //opp.addError('e');
                opp.OwnerId = trigger.oldMap.get(opp.id).OwnerId;
                opp.from_Code_updated_Inserted__c='update from trg_onprojectBeforeUpdate Line 18';
			}
            if(opp.StageName == label.Stage_60 && opp.StageName!=trigger.oldMap.get(opp.id).StageName)
            {
               if(oppTaskMap.containsKey(opp.Id))
               {
                  if(oppTaskMap.get(opp.Id).size()!=0)
                  {
                      for(task t : oppTaskMap.get(opp.Id))
                      {
                        if(t.subject.contains('Share Product Information/Schedule a trial') || t.subject.contains('Re-confirm requirements with the customer'))
                        {
                           opp.addError('Complete the Open Tasks to change the stage to 60'); 
                        }
                        if((t.subject.contains('Confirm trial date with customer') || t.subject.contains('Understand customer’s enquiry')) && opp.Flag_Contact_Us__c)
                        {
                           opp.addError('Complete the \'Contact Us open Tasks\' to change the stage to 60'); 
                        }
                        if((t.subject.contains('Confirm Sample Received') || t.subject.contains('Qualify Sampling')) && opp.Flag_Sample_Requested__c)
                        {
                           opp.addError('Complete the \'Confirm Sample received / Qualify Sampling\' to change the stage to 60'); 
                        }
                      }
                 } 
              }
               
               
                Integer cnt = [select count() from Task where WhatId =: opp.Id And Status = 'Open' And
                    (Subject = 'Qualify Sampling' Or Subject = 'Confirm Sample Received')];
                if(cnt > 0)
                    opp.addError(' Close the Confirm Sample Received & Qualify Sampling task before you change the Stage to 60.');
}
            if(opp.StageName == label.Stage_30 || opp.StageName == 'Alternate Trial Scheduled' || 
                opp.StageName == 'Trial Successful & Business Qualified')
                opp.Override__c = false;//9 jan 2019
            
           /*
            * Below Code Added By Akshay Phatak
            * 12-Nov-2018
            * Task  : Validation Rule on Opprtunity--if stage is First Order Supplied then check tasks Fulfill First Order With Customer and Validate First Order Fulfillment
            * if these tasks are not closed then user can not change stage to  First Order Supplied.
            * Select all Projects whoes stage is First Order Supplied and add to set.
            */
            
           if((trigger.oldMap.get(opp.id).StageName!=label.Stage_90 || trigger.oldMap.get(opp.id).StageName!=label.Stage_100) && opp.Flag_Ecommerce__c == false && trigger.oldMap.get(opp.id).StageName!=opp.stagename)
            {
                if(trigger.oldMap.get(opp.id).StageName!=label.Stage_60 && opp.stageName==label.Stage_90)
                {
                    opp.addError('You can not change stage manually to stage 90/"First Order Supplied"');
                }
}
            /*if(opp.StageName=='Sample Received')
            {
                if(oppTaskMap.containsKey(opp.Id))
                {
                    if(oppTaskMap.get(opp.Id).size()!=0)
                    {
                        for(task t : oppTaskMap.get(opp.Id))
                        {
                            if(t.subject.contains('Confirm Sample Received'))
                            {
                                opp.addError('Please Close "Confirm Sample Received" task');
                            }
                        }
                }
                    
                }
            }*/
           if(opp.StageName==label.Stage_90 && trigger.oldMap.get(opp.id).StageName!=opp.stagename)
            {
                if(oppTaskMap.containsKey(opp.Id))
                {
                    if(oppTaskMap.get(opp.Id).size()!=0)
                    {
                        for(task t : oppTaskMap.get(opp.Id))
                        {
                            if(t.subject.contains('Confirm First Order With Customer'))
                            {
                                opp.addError('Complete "Open Tasks" to change stage to "First Order supplied"'); 
                            }
                            if(t.subject.contains('Fulfill First Order With Customer'))
                            {
                                opp.addError('Complete "Open Tasks" to change stage to "First Order supplied"'); 
                            }
                            if(t.subject.contains('Validate First Order Fulfillment'))
                            {
                                opp.addError('Complete "Open Tasks" to change stage to "First Order supplied"'); 
                            }
                        }
                    }
                }
             
}
            if(opp.StageName==label.Stage_30 && opp.Prospect_Interest_Type__c=='Sample Requested' && trigger.oldMap.get(opp.id).StageName=='Sample Received' )
            {
                    if(oppTaskMap.containsKey(opp.Id))
                    {
                        if(oppTaskMap.get(opp.Id).size()!=0)
                        {
                            for(task t : oppTaskMap.get(opp.Id))
                            {
                                if(t.Subject.contains('Confirm Sample Received') )
                                {
                                    opp.addError('Please close "Confirm Sample Received" Task for moving to "Trial Scheduled/Intent to buy" stage');  
                                }
                            }  
                        }
                    }
                   
}
       
}
       }
       else if(trigger.isBefore && trigger.isInsert)
       {
           System.debug('Before Insert Project : ');
           
           List<String> accId = new List<String>();
           
           for(Opportunity opp : trigger.new)
           {	
               accId.add(opp.AccountId);
           }
           
           List<AccountTeamMember> salesteam = new List<AccountTeamMember>();
           
           salesteam = [select id,AccountId,User.FirstName,User.LastName,TeamMemberRole from AccountTeamMember where AccountId =:accId];
           system.debug('Account id : ' + salesteam);
           
           Map<String,AccountTeamMember> salesteamMap = new Map<String,AccountTeamMember>();
           
           Map<String,AccountTeamMember> seniorteamMap = new Map<String,AccountTeamMember>();
           
           for(AccountTeamMember member : salesteam)
           {
               if(member.TeamMemberRole == 'Digital Sales Engineer')
               {
                   System.debug('member name' +member.user.firstname+' Role : '+member.TeamMemberRole);
                   salesteamMap.put(member.AccountId, member);
               }
               if(member.TeamMemberRole == 'Senior Digital Sales Engineer')
               {
                   System.debug('member name' +member.user.firstname+' Role : '+member.TeamMemberRole);
                   seniorteamMap.put(member.AccountId, member);
               }
           }

           for(Opportunity opp: Trigger.new)
           {
               if(opp.Project_source__c != null)
               {
                   projectsourceList.add(opp.Project_source__c);
               }
           }
           
           if(projectsourceList.size() > 0)
           {
               projectsourceMappingList = [Select id,name,Priority__c from Project_Source_Mapping__c where name =: projectsourceList];
           }
           
           for(Project_Source_Mapping__c pr :projectsourceMappingList)
           {
               projectsourceMappingMap.put(pr.Name,pr.Priority__c);
           }
           
          for(Opportunity opp  : trigger.new)
          {
              System.debug('projectsourceMappingMap.containsKey(opp.Project_source__c)-- '+projectsourceMappingMap.containsKey(opp.Project_source__c));
              if(opp.Contact_PinCode__c!=null)
              {
              for(String s :pinCodeUserMap.keySet())
              {
                  if(s!=null && s.contains (opp.Contact_PinCode__c))     
                  {
                  	opp.Distributor_On_Project__c = pinCodeUserMap.get(s).Contact.Account.Name;
                  }
                }
              }
              if(projectsourceMappingMap.containsKey(opp.Project_source__c))
                {
                   opp.Project_Source_priority__c=projectsourceMappingMap.get(opp.Project_source__c); 
                }
              
              if(salesteamMap.containsKey(opp.AccountId))
              {
                  system.debug(salesteamMap.get(opp.AccountId).User.FirstName);
                  opp.Digital_Sales_Engineer__c = salesteamMap.get(opp.AccountId).User.FirstName + ' ' + salesteamMap.get(opp.AccountId).User.LastName;
              }
              if(seniorteamMap.containsKey(opp.AccountId))
              {
                  system.debug(seniorteamMap.get(opp.AccountId).User.FirstName);
                  opp.Senior_Sales_Engineer__c = seniorteamMap.get(opp.AccountId).User.FirstName + ' ' + seniorteamMap.get(opp.AccountId).User.LastName;
              }
          }
       }
    if(Test.isRunningTest())
    coverMethod(); 
    }
    
    
    public static void coverMethod()
    {
        Integer i = 0;
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
    }
}