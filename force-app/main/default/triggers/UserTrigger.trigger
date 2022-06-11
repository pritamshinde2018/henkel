trigger UserTrigger on User (after update,after insert) 
{
    /*UserTriggerHelper helper = new UserTriggerHelper();
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            List<User> userNewList = new List<User>();
            for(User newUser: Trigger.New)
            {
                for(User oldUser: Trigger.old)
                {
                    if(newUser.id == oldUser.id && newUser.Pin_codes__c != oldUser.Pin_codes__c)
                    {
                        userNewList.add(newUser);
                         
                    }
                }   
            }
            helper.handleAfterUpdate(userNewList);
        }
        if(trigger.isInsert)
        {
            helper.handleAfterInsert(Trigger.New);
        }
    }*/
}