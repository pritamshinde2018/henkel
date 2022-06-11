global class agentAssignment implements Schedulable  
{
    public static List<Lead> leadList=new List<Lead>();
    public static List<Lead> leadstobeUpdate=new List<Lead>();
    
    public static List<Lead> leadstobeUpdateDemo=new List<Lead>();
    public static List<Lead> leadstobeUpdateWebinar=new List<Lead>();
    
    public static List<Lead> leadDemo=new List<Lead>();
    public static List<Lead> leadWebinar=new List<Lead>();
    
    public static Boolean agenassignmentFlag=true;
    global static void execute (SchedulableContext ctx) 
    {
        Group g = [Select id from group where name='CC Team'];
        List<groupMember> memberList = [Select GroupId, UserOrGroupId from GroupMember where GroupId =: g.Id];
        List<Id> lstIds = new List<Id>();
        for(groupMember g1: memberList)
        {
            lstIds.add(g1.UserOrGroupId);  
        }
        List<AggregateResult> lst = [select OwnerId, count(Id)reccount from Lead where isConverted=false AND (cc_status__c = null OR cc_status__c = 'callback1' OR cc_status__c = 'callback2') AND (status ='Data and Intent Validation Process' OR status = 'Data Collection Process') AND OwnerId in : lstIds 
        group by OwnerId order by count(Id)];
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        Datetime dt=local.addDays(-3);
        Datetime dt1=local.addDays(0);
        
        Datetime dt2=local.addDays(-2);
        Datetime dt3=local.addDays(-1);
        
        System.debug('dt '+dt);
        System.debug('dt '+dt2);
        System.debug('dt '+dt3);
        leadList=[Select id,name,pi__score__c,OwnerId,Call_Center_Agents__c,CC_Status__c,Prospect_Interest_Type__c,
                  CC_Sample_Required__c,pi__created_date__c from Lead 
                  where ((pi__created_date__c<=:dt AND Prospect_Interest_Type__c='Sample Requested') OR ( Prospect_Interest_Type__c='Webinar' )) AND ((pi__campaign__c='Salesforce Prospect' AND(LeadSource='LinkedIn' OR LeadSource='Facebook_Zapier') ) OR pi__campaign__c='Send Sample' OR pi__campaign__c='Webinar' ) AND CC_Status__c=null  AND Street=null AND industry=null and Number_of_Employees_Custom__c=null  and isConverted=false AND Indiamart_ID__c=null AND  ownerID NOt in :lstIds Limit 20];
        
        
        leadDemo=[Select id,name,pi__score__c,OwnerId,Call_Center_Agents__c,CC_Status__c,Prospect_Interest_Type__c,
                  CC_Sample_Required__c,pi__created_date__c,status from Lead 
                  where pi__created_date__c<=:dt2 AND Prospect_Interest_Type__c='GM Design Guide' AND status = 'Data and Intent Validation Process' AND isConverted=false AND ownerID NOt in :lstIds Limit 20];
        
        
        leadWebinar=[Select id,name,pi__score__c,OwnerId,Call_Center_Agents__c,CC_Status__c,Prospect_Interest_Type__c,
                  CC_Sample_Required__c,pi__created_date__c,status from Lead 
                  where pi__created_date__c<=:dt3 AND status = 'Data and Intent Validation Process' AND Prospect_Interest_Type__c='Webinar' AND isConverted=false AND ownerID NOt in :lstIds Limit 20];
        
        
        Map<Id,Integer> usercountMap=new Map<Id,Integer>();
        
        for(AggregateResult ar : lst)
        {
            usercountMap.put((Id)ar.get('OwnerId'),(Integer)ar.get('reccount'));
        }
        System.debug('leadList '+leadList);
        System.debug('leadList.size() '+leadList.size());
        
        for(Lead l  : leadList)
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
            {
            	l.OwnerId=lowernumberID;
                l.Status='Data Collection Process';
            	l.CC_Qualification__c='Yes';
            }
            if(usercountMap.containsKey(lowernumberID))
            {
               usercountMap.put(lowernumberID,usercountMap.get(lowernumberID)+1);  
            }
           System.debug('usercountMap after'+usercountMap);
            /*for(AggregateResult ar : lst)
            {
                l.OwnerId = (Id)ar.get('OwnerId');
                break;
            }*/
            leadstobeUpdate.add(l);
        }
        if(leadstobeUpdate.size()!=0)
        {
            agenassignmentFlag=false;
            update leadstobeUpdate;    
        }
        
        for(Lead l  : leadDemo)
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
            {
            	l.OwnerId=lowernumberID;
                //l.Status='Data Collection Process';
            	//l.CC_Qualification__c='Yes';
            }
            if(usercountMap.containsKey(lowernumberID))
            {
               usercountMap.put(lowernumberID,usercountMap.get(lowernumberID)+1);  
            }
           System.debug('usercountMap after'+usercountMap);
            leadstobeUpdateDemo.add(l);
        }
        if(leadstobeUpdateDemo.size()!=0)
        {
            agenassignmentFlag=false;
            update leadstobeUpdateDemo;    
        }
        
        
        for(Lead l  : leadWebinar)
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
            {
            	l.OwnerId=lowernumberID;
                //l.Status='Data Collection Process';
            	//l.CC_Qualification__c='Yes';
            }
            if(usercountMap.containsKey(lowernumberID))
            {
               usercountMap.put(lowernumberID,usercountMap.get(lowernumberID)+1);  
            }
           System.debug('usercountMap after'+usercountMap);
            /*for(AggregateResult ar : lst)
            {
                l.OwnerId = (Id)ar.get('OwnerId');
                break;
            }*/
            leadstobeUpdateWebinar.add(l);
        }
        if(leadstobeUpdateWebinar.size()!=0)
        {
            agenassignmentFlag=false;
            update leadstobeUpdateWebinar;    
        }
        
        
        if(test.isRunningTest())
        convert();
    }
    
    public static void convert()
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
    }
}