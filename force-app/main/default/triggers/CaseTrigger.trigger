trigger CaseTrigger on Case (before insert, after insert,after update) {
    
   /* if(Trigger.isBefore && Trigger.isInsert){
        CaseTriggerHelper.autoCreateContact(Trigger.new);
    } */
    if(trigger.isafter && Trigger.isupdate)
    {
        if (UserInfo.getUserType() == 'Standard'){
        DateTime completionDate = System.now(); 
            List<Id> updateCases = new List<Id>();
            for (Case c : Trigger.new){
                    if (((c.isClosed == true)||(c.Status == 'Closed'))&&((c.SlaStartDate 
                        <= completionDate)&&(c.SlaExitDate == null)))
        updateCases.add(c.Id);
        }
    if (updateCases.isEmpty() == false)
        milestoneUtils.completeMilestone(updateCases, 'Resolution Time', completionDate);
    }
    }
}