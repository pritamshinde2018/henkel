public class EcomContactAssignment implements database.Batchable<sObject>,Database.StateFul,Schedulable
{
    List<Contact> conupdate = New List<Contact>();
     public void execute(SchedulableContext SC){
        Database.executebatch(new EcomContactAssignment());
    }
    public database.QueryLocator start(Database.BatchableContext bc)
    {
        string str='Select id from Contact where ((Number_of_Employees_Custom__c=null OR Industry__c=null) AND (CC_Remarks_1__c= null or CC_Remarks_2__c= null or CC_Remarks_3__c= null)) Limit 9000';
        return Database.getQueryLocator(str);
        
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope)
    {
          List<Group> g = [Select id from group where name='CC Team' limit 1];
          List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g[0].Id];
        
          List<Id> lstIds = new List<Id>();
          for(groupMember gb: memberList)
          {
              lstIds.add(gb.UserOrGroupId);
          }
        System.debug('lstIds----'+lstIds);
         Map<Id,Integer> usercountMap=new Map<Id,Integer>();
         List<AggregateResult> lst = [select OwnerId, count(Id)reccount from Contact where  OwnerId in :lstIds group by OwnerId order by count(Id)];
        if(lst.size()!=0)
        {
            for(AggregateResult ar : lst)
            {
                usercountMap.put((Id)ar.get('OwnerId'),(Integer)ar.get('reccount'));
            }
        }
        else
        {
            for(String str : lstIds)
            {
                usercountMap.put(str,0);
            }
        }
        System.debug('usercountMap---- '+usercountMap);
          for(Contact con : scope)
          {
            Id lowernumberID;
            Integer lowercount;
            if(usercountMap.size()!=0)
            {
                lowernumberID=new List<Id>(usercountMap.keyset())[0];
                lowercount=usercountMap.get(new List<Id>(usercountMap.keyset())[0]);
                for(ID i : usercountMap.keyset())
                {
                    if(lowercount>usercountMap.get(i))
                    {
                        lowercount=usercountMap.get(i);
                        lowernumberID=i;
                    }
                }
            }
            System.debug('lowernumberID '+lowernumberID);
            if(lowernumberID!=null)
            con.OwnerId=lowernumberID;
            conupdate.add(con);
         }
              
    }
    
    public  void finish(Database.BatchableContext bc)
    {
        System.debug('conupdate--- '+conupdate);
        if(conupdate.size()>0)
        {
           update conupdate;
        }
    }
}