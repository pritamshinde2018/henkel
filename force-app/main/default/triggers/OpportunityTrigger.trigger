trigger OpportunityTrigger on Opportunity (before insert) 
{
    /*Map<Id,id> contIdMap = new Map<Id,Id>();
    for(Opportunity opp : trigger.new){
        contIdMap.put(opp.Contact2__c,opp.id);
    }
    List<Contact> contList = [SELECT id,MailingPostalCode FROM Contact WHERE id IN :contIdMap.keySet()];
    Map<Id,String> contToPostalCodeMap = new Map<Id,String>();
    for(Contact c : contList){
         contToPostalCodeMap.put(c.id,c.MailingPostalCode); 
    }
    
    List<User> userList = [SELECT id,Pin_codes__c FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
    for(User u : userList){
        String pincodeStr = '';
        pincodeStr = u.Pin_codes__c;
         for(Opportunity oppr : trigger.new){
             String pin = contToPostalCodeMap.get(oppr.Contact2__c);
             if(Test.isRunningTest()){
                 pin = '110084';
             }
             if(pincodeStr != null && pincodeStr != '' && pincodeStr.contains(pin)){
                 oppr.OwnerId = u.id;
             }
         }
    }*/
}