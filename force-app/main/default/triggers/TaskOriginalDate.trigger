trigger TaskOriginalDate on Task (before insert) 
{
    /*for(Task t:trigger.new)
    {
        if(Trigger.isInsert)
        {
            t.Original_Due_Date__c = t.ActivityDate;
        }
    }*/
}