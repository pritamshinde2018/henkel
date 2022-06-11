/*
* testClass : testcontactTrigger
* handler : trg_OnContactHandler
*/
trigger trg_OnContact on Contact (before update, after insert, after update,before insert) 
{
    EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
    System.debug('mc---- '+mc.IsContactTriggerActivated__c);
    if(mc.IsContactTriggerActivated__c)
    {
        //if(checkRecursive.Leadflag)
        //{
            boolean ecom = false;
            for(contact cnt : trigger.new)
            {
                if(cnt.LeadSource == 'E-Commerce')
                {
                    ecom = true;
                }
            }
            List<Contact> exitingContactList=new List<Contact>();
            Map<id,List<Quotation__c>> leadQuotationNumberMap=new Map<Id,List<Quotation__c>>();
            Map<id,List<Request__c>> leadRequestCallBackMap=new Map<Id,List<Request__c>>();
            Map<id,List<Customized_Price__c>> leadCustomizedPriceMap=new Map<Id,List<Customized_Price__c>>();
            Map<id,List<Refer_Friend__c>> leadReferFrndMap = new Map<id,List<Refer_Friend__c>>();
            Map<String,Care__c> careMap=new Map<String,Care__c>();
            /*Map<String,State__mdt > StateCodeMap=new Map<String,State__mdt>();
For(State__mdt code :[Select id,label,Internal_Code__c from State__mdt])// State Code Metadata
{
StateCodeMap.put(code.label,code);

}
List<User> userList=[Select id,Pin_codes__c,profileId,UserRoleId from user where UserRole.name='Inside Sales Team'];
Map<String,User> userpincodeMap=new Map<String,User>();
List<String> pincodeList;
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

}*/
            
            
            
            
            /* if((trigger.isInsert || trigger.isUpdate) && trigger.isbefore)
{
for(contact con : trigger.new)
{
con.Lead_Status__c = 'Qualified';
}
}*/
            
            
            if(trigger.isBefore)
            {
                if(trigger.isUpdate)
                {
                    System.debug('I am in before update contact trigger');
                    /*for(Contact l :[Select id,(Select id from Quotations__r),(Select id from Request_Callbacks__r),(Select id from Customized_Prices__r),MailingState from Contact where id in :trigger.new])
{
leadQuotationNumberMap.put(l.Id,l.Quotations__r); 
leadRequestCallBackMap.put(l.Id,l.Request_Callbacks__r);
leadCustomizedPriceMap.put(l.id,l.Customized_Prices__r);
leadReferFrndMap.put(l.id,l.Refer_Friends__r);

}
for(Care__c careObj  :[Select id,Focus_Segment__c,Focus_Priority__c,Annualized_value_estimation__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c ])
{
careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
}*/
                    exitingContactList=[Select id,name,Which_Product_Sent__c,
                                        (select id,Related_Project__c,Webinar_Id__c from Webinar__r),
                                        (Select id,Comments__c,Status__c,StageName,name,Webinar_Id__c,SampleRequested_Timestamp__c,
                                         Which_Product_Sent__c,CloseDate,Assigned_IST_User__c,Type_of_Enquiry__c,Contact_email__c,probability,Prospect_Interest_Type__c,Flag_abandoned_cart__c,Intends_to_place_an_order_request_del__c,Intends_to_Speak__c
                                         from Opportunities2__r 
                                         where Flag_abandoned_cart__c!=true and Probability<=30 and (Flag_Sample_Requested__c=true OR Flag_Webinar__c=true OR Flag_Contact_Us__c=true) order by createddate DESC) 
                                        from contact where id in :trigger.new];
                    
                    
                    //trg_OnContactHandler.webinarCreation(exitingContactList,trigger.new,trigger.oldMap,userpincodeMap,trigger.newMap);
                    //trg_OnContactHandler.handlePDP(trigger.new,trigger.oldMap,leadQuotationNumberMap,
                    //leadRequestCallBackMap,leadCustomizedPriceMap,leadReferFrndMap);
                    trg_OnContactHandler.HandleCareFunctionality(trigger.new,trigger.oldMap,false);
                    //trg_OncontactHandler.handleItenttoBuy(trigger.new,trigger.oldMap,false,exitingContactList);
                    //trg_OncontactHandler.StateCodeMethod(trigger.new,trigger.oldMap,false,StateCodeMap);//State Code Mapping Update
                    trg_OncontactHandler.pardotCalloutforActivity(JSON.serialize(Trigger.newMap),JSON.serialize(Trigger.oldMap));
                    trg_OncontactHandler.Contactscoringmodel(trigger.new,trigger.oldmap,'update');
                }
                else
                {
                    System.debug('I am in before Insert');
                    /*for(Care__c careObj  :[Select id,Annualized_value_estimation__c,Focus_Segment__c,Focus_Priority__c,Lead_classification_basis_value__c,Lead_priority__c,Grade__c,
SBU__c,Industry_priority__c,Industry_NumberofEmployees__c from Care__c ])
{
careMap.put(careObj.Industry_NumberofEmployees__c,careObj);
}*/
                    trg_OnContactHandler.HandleCareFunctionality(trigger.new,trigger.oldMap,true);
                    trg_OncontactHandler.Contactscoringmodel(trigger.new,trigger.newmap,'insert');
                    //trg_OncontactHandler.StateCodeMethod(trigger.new,trigger.oldMap,true,StateCodeMap);//State Code Mapping Insert 
                }
            }
            if(trigger.isAfter)
            {
                if(trigger.isUpdate)
                {
                    /*exitingContactList=[Select id,name,Which_Product_Sent__c,
(select id,Related_Project__c,Webinar_Id__c from Webinar__r),
(Select id,Comments__c,Status__c,StageName,name,Webinar_Id__c,SampleRequested_Timestamp__c,
Which_Product_Sent__c,probability,Flag_abandoned_cart__c  from Opportunities2__r 
where Flag_abandoned_cart__c!=true and Probability<30 and Prospect_Interest_Type__c='Sample Requested' order by createddate DESC) 
from contact where id in :trigger.new];*/
                    // trg_OnContactHandler.handleEcomRegistrants(trigger.new,trigger.newMap,trigger.oldMap,userpincodeMap);
                }
                
            }
            if(ecom)
            {
                checkRecursive.leadflag = true;
            }
      // }
    }
}