Trigger OpportunityStage90_100 on Opportunity (before Update)
{
    /*for(Opportunity newOpp : trigger.new)
    {
        for(Opportunity oldOpp : trigger.old)
        {
            if(newOpp.id == oldOpp.id && newOpp.StageName != oldOpp.StageName 
                && newOpp.StageName == 'Maintaining/Closing')
            {
                integer taskCount = [SELECT count() FROM Task WHERE WhatID =: newOpp.Id and status !='Completed'];
                if(taskCount > 0)
                {
                    newOpp.addError('This Project has open Tasks, you need to complete all of them before changing the Stage.');  
                }
            }
        }     
    }    */
}