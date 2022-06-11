/*
 * Test Class : test_EcomRegistrantAssignment
*/
public class EcomRegistrantsAssignments implements database.Batchable<sObject>,Database.Stateful,Schedulable
{
    List<String> pincodeList;
    List<User> userList=[Select id,Pin_codes__c,profileId,UserRoleId from user where UserRole.name='Inside Sales Team'];
    Map<String,User> userpincodeMap=new Map<String,User>();
    List<Contact> cnttoUpdate=new List<Contact>();
    public void execute(SchedulableContext SC){
        Database.executebatch(new EcomRegistrantsAssignments(),5);
    }
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='Select id,Ecom_Registration__c,MailingPostalCode,(Select id from Opportunities2__r) from contact where (number_of_minutes_from_Creation__c>60.00 and number_of_minutes_from_Creation__c<360) and Ecom_Registration__c= true';
        for(User u  : userList)
        {
            String pincodes=u.Pin_codes__c;
            pincodeList=new List<String>();
            if(pincodes!=null && pincodes!='')
                pincodeList=pincodes.split(',');
            for(String str :pincodeList)	
            {
                userpincodeMap.put(str,u);  
            }
            
        }
        System.debug('userpincodeMap in start------ '+userpincodeMap);
        return database.getQueryLocator(query);
    }
    
    public  void execute(Database.BatchableContext bc , List<Contact> scope)
    {
        System.debug('userpincodeMap in execute----- '+userpincodeMap);
        for(Contact cnt :scope)
        {
            if(cnt.Opportunities2__r.size()==0)
            {
                System.debug('cnt.MailingPostalCode--- '+cnt.MailingPostalCode);
                System.debug(userpincodeMap.containsKey(cnt.MailingPostalCode));
                if(userpincodeMap.containsKey(cnt.MailingPostalCode))
                {
                    cnt.OwnerId=userpincodeMap.get(cnt.MailingPostalCode).id; 
                    cnttoUpdate.add(cnt);
                }
            }
        }
        
    }
    
    public  void finish(Database.BatchableContext bc)
    {
        System.debug('cnttoUpdate--- '+cnttoUpdate);
        System.debug('userpincodeMap in finish------ '+userpincodeMap);
        update cnttoUpdate; 
    }
}