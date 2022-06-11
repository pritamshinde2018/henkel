trigger TaskDeleteNotAllowed on Task (before delete,before insert) 
{
   /* if(Trigger.isDelete && Trigger.isBefore){
      for(Task t : trigger.old)
      {
        if(!Test.isRunningTest())
        t.addError(System.label.Task_Delete_Error_Message);
      }
   }
   
   if(Trigger.isInsert && Trigger.isBefore){
       String ProfileId = UserInfo.getProfileId();  
       List<Profile> profileList=[select id from Profile where name='Partner Community User - Custom'];
    
       if(profileList != null && profileList.size() > 0)
       {
           for (Task a : Trigger.new)      
           {            
              if(profileId == profileList[0].id) 
              {
                 a.addError(System.label.TaskError);
              }
           }            
       }
   }*/

}