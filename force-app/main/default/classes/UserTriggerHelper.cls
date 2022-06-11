public class UserTriggerHelper 
{
    Public void handleAfterUpdate(List<User> newList)
    {
        updateOwnerOnOfferAndOpportunity(newList);
    }
    Public void handleAfterInsert(List<User> newList)
    {
        updateOwnerOnOfferAndOpportunity(newList);
    }
    public void updateOwnerOnOfferAndOpportunity(List<User> newList)
    {
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        List<Offer__c> offerListToUpdate = new List<Offer__c>();
        MAP<ID,String> oppUserEmailIdMap = new MAP<ID,String>();
        MAP<ID,String> oppOfferEmailIdMap = new MAP<ID,String>();
        MAP<String,List<Opportunity>> oppPostalCodeOppMap = new MAP<String,List<Opportunity>>();
        MAP<String,List<Offer__c>> offerPostalCodeOfferMap = new MAP<String,List<Offer__c>>();
        for(Opportunity opp : [SELECT ID,Pincode_Status__c,OwnerID,Contact2__r.MailingPostalCode
                               FROM Opportunity WHERE Pincode_Status__c = '2'])
        {
            if(oppPostalCodeOppMap.containsKey(opp.Contact2__r.MailingPostalCode))
            {
                oppPostalCodeOppMap.get(opp.Contact2__r.MailingPostalCode).add(opp);
            }
            else
            {
                oppPostalCodeOppMap.put(opp.Contact2__r.MailingPostalCode, New List<Opportunity>());
                oppPostalCodeOppMap.get(opp.Contact2__r.MailingPostalCode).add(opp);
            }
        }
        for(Offer__c offer : [SELECT ID,Pincode_Status__c,OwnerID,Addres__c
                                FROM Offer__c WHERE Pincode_Status__c = '2'])
        {
            String pinCode = offer.Addres__c.replaceAll('[^0-9]','');
            system.debug('');
            if(offerPostalCodeOfferMap.containsKey(pinCode))
            {
                offerPostalCodeOfferMap.get(pinCode).add(offer);
            }
            else
            {
                offerPostalCodeOfferMap.put(pinCode, New List<Offer__c>());
                offerPostalCodeOfferMap.get(pinCode).add(offer);
            }
        }
        for(User u : newList)
        {
            for(String pin : oppPostalCodeOppMap.keySet())
            {
                if(!String.isEmpty(u.Pin_codes__c) && u.Pin_codes__c.contains(pin))
                {
                    for(Opportunity opp : oppPostalCodeOppMap.get(pin))
                    {
                        opp.Pincode_Status__c = '1';
                        opp.OwnerId = u.id;
                        oppListToUpdate.add(opp);
                        oppUserEmailIdMap.put(opp.Id,u.Email);
                    }
                }
            }
            for(String pin : offerPostalCodeOfferMap.keySet())
            {
                if(!String.isEmpty(u.Pin_codes__c) && u.Pin_codes__c.contains(pin))
                {
                    for(Offer__c off : offerPostalCodeOfferMap.get(pin))
                    {
                        off.Pincode_Status__c = '1';
                        off.OwnerId = u.id;
                        offerListToUpdate.add(off);
                        oppOfferEmailIdMap.put(off.Id,u.Email);
                    }
                }
            }
        }
        update oppListToUpdate;
        update offerListToUpdate;
        if(!oppUserEmailIdMap.isEmpty())
        {
             sendEmail(oppUserEmailIdMap,'Opportunity');
        }
        if(!oppOfferEmailIdMap.isEmpty())
        {
             sendEmail(oppOfferEmailIdMap,'Offer');
        }
    }
    public void sendEmail(Map<ID,String> emailIdsMap,String objectName)
    {
        EmailTemplate etdist = new EmailTemplate();
        Contact cont = [SELECT id FROM Contact Limit 1];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        if(objectName == 'Opportunity')
        {
        	 etdist = [SELECT id FROM EmailTemplate WHERE Name='Case1-Step4 Sample Confirmation Email-Distributor' Limit 1];    
        }
        else if(objectName == 'Offer')
        {
            etdist = [SELECT id FROM EmailTemplate WHERE Name='Case1-Step6 - Order Confirmation - Distributor' Limit 1];    
        }
        
        
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        
      //  String[] toAddress1 = new String[]{u.Email};
       	String[] toccAddress1 = new String[]{'vinay.ravindranath@henkel.com'};
        for(ID id: emailIdsMap.keySet())
        {
            String[] toAddress1 = new String[]{emailIdsMap.get(id)};
            mail1.setToAddresses(emailIdsMap.values());
            mail1.setCcAddresses(toccAddress1);
            mail1.setTargetObjectId(cont.id);
            mail1.setWhatId(id);
            mail1.setTreatTargetObjectAsRecipient(false);
            mail1.setSaveAsActivity(false);
            //mail.setOrgWideEmailAddressId('0D27F000000PD8P');
            mail1.setTemplateId(etdist.id);
            emailList.add(mail1);
        } 
        if(!emailList.isEmpty())
        {
            Messaging.sendEmail(emailList);
        }
    }
}