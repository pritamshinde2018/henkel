public class ecomOrdersAssignment implements database.Batchable<sObject>,Database.StateFul,Schedulable
{
    List<Order_Information__c> orderupdate = New List<Order_Information__c>();
    public void execute(SchedulableContext SC){
        Database.executebatch(new ecomOrdersAssignment());
    }
    public database.QueryLocator start(Database.BatchableContext bc)
    {
        string str='Select id,Payment_Status__c,Number_of_minutes__c,CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c from Order_Information__c where Payment_Status__c=\'booked\' and Number_of_minutes__c<=6000';
        return Database.getQueryLocator(str);
        
    }
    public void execute(Database.BatchableContext bc, List<Order_Information__c> scope)
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
        List<AggregateResult> lst = [select OwnerId, count(Id)reccount from Order_Information__c where  OwnerId in :lstIds group by OwnerId order by count(Id)];
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
        for(Order_Information__c ord : scope)
        {
            if(ord.Number_of_minutes__c!=NULL && ord.Number_of_minutes__c>=15 && ord.Number_of_minutes__c<4320 )
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
                    ord.OwnerId=lowernumberID;
                orderupdate.add(ord);
            }  
            else if(ord.Number_of_minutes__c>=4320 && ord.CC_Remarks_1__c!=Null  && ord.CC_Remarks_2__c!=Null  && ord.CC_Remarks_3__c!=Null)
            {
                ord.OwnerId =label.Default_IST;
                orderupdate.add(ord);
            }
        }
        
    }
    
    public  void finish(Database.BatchableContext bc)
    {
        System.debug('orderupdate--- '+orderupdate);
        if(orderupdate.size()>0)
        {
            update orderupdate;
        }
    }
}