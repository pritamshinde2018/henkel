global class ScheduleBatchOwnerAssignment implements schedulable{
    global void execute(SchedulableContext sc)
    {
        BatchOwnerAssignment bt = new BatchOwnerAssignment(); //ur batch class
        database.executebatch(bt);
    }
}