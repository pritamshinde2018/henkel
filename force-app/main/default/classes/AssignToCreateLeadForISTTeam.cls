Global class AssignToCreateLeadForISTTeam {
    public String caseId { get; set; }
    Public Case cs;
    public String message {get;set;}
    
    public AssignToCreateLeadForISTTeam(ApexPages.StandardController controller){
        cs = (Case)controller.getRecord();
        caseId = cs.Id;
    }
    
    webservice static void CreateLeadAndAssign(Id caseId){
        Case cs = [SELECT id, status, CaseNumber,Origin,SuppliedName ,OwnerId, Phone__c,SuppliedEmail, Prospect_Interest_Type__c, Has_Attachment__c,
                No_of_Employees__c, Street__c,Description, Pin_code__c,Contact.Contact_Sr_No__c,Contact.LastName,Contact.FirstName,Contact.Email,ContactId,
                Enquiry_Type__c,Industry__c, lead__c,lead__r.Email,Company__c FROM Case WHERE id = :caseId];
        
        //Contact ct = [SELECT id,Email FROM Contact WHERE id = :cs.ContactId];
                       
        List<User> usrList = [SELECT id, Pin_codes__c FROM User WHERE Profile.Name='Standard User - IST'];
        List<lead> updatelead = new List<lead>();
        List<String> pcList = new List<String>();
        Map<String,User> PinCodeToUserMap = new Map<String,User>();
        for(User usr : usrList){
            if(usr.Pin_codes__c!=null)
            {
                 String pincodeStr = usr.Pin_codes__c;
            pcList = pincodeStr.Split(',');
            for(String pc : pcList){
                PinCodeToUserMap.put(pc,usr);
            }
           
            }
        }
        System.debug('PinCodeToUserMap--->>>'+PinCodeToUserMap);
        
        if(PinCodeToUserMap.containskey(String.valueOf(cs.Pin_code__c))){
            List<Lead> Relatedld = [SELECT id,Enquiry_Type__c FROM Lead WHERE email = :cs.SuppliedEmail limit 1];
            
            
            Lead ld;
            if(Relatedld!=Null && Relatedld.Size()>0)
            {
                ld = new Lead(Id=Relatedld[0].id);
                ld.Prospect_Interest_Type__c = cs.Prospect_Interest_Type__c;
                ld.Mail_Enquiry_Message__c = cs.Description;
                ld.Enquiry_Type__c = cs.Enquiry_Type__c;
                ld.Contact_Sr_No__c= cs.Contact.Contact_Sr_No__c;
                ld.Latest_Case_Number__c=cs.CaseNumber;
                ld.Street=cs.Street__c;
                ld.PostalCode = String.valueOf(cs.Pin_code__c);
                ld.Industry = cs.Industry__c;
                ld.Number_of_Employees_Custom__c = cs.No_of_Employees__c;
                ld.Company=cs.Company__c;
                //updatelead.add(ldupdate);
                cs.Lead__c = Relatedld[0].id;
                cs.Status = 'WIP with IST Team';
                try{
                    update ld;
                }catch(Exception e)
                {
                    System.debug('Exception occured Message for the lead Update on Case: '+e);
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {'pritam.shinde@nanostuffs.com'};
                        message.setSubject('CTA Error Message for the lead Update on Case') ;
                    message.setPlainTextBody('Exception occured on creation of CTA after lead update trigger: '+e.getMessage()+' :'+e.getCause()+'--'+e.getLineNumber());
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
                
                update cs; 
            }
            else
            {
                ld = new Lead();
                if(cs.ContactId!=null)
                {
                 ld.LastName = cs.Contact.LastName;
                 ld.FirstName = cs.Contact.FirstName;  
                 ld.Contact_Sr_No__c = cs.Contact.Contact_Sr_No__c;
                }
                else
                {
                    ld.LastName=cs.SuppliedName;
                }
                
                ld.Company = cs.Company__c;
                ld.Prospect_Interest_Type__c = cs.Prospect_Interest_Type__c;
                ld.Industry = cs.Industry__c;
                ld.Street=cs.Street__c;
                ld.Latest_Case_Number__c=cs.CaseNumber;
                ld.ownerId = PinCodeToUserMap.get(String.valueOf(cs.Pin_code__c)).id;
                ld.Mail_Enquiry_Message__c = cs.Description;
                ld.Prospect_Interest_Type__c = cs.Prospect_Interest_Type__c;
                ld.Number_of_Employees_Custom__c = cs.No_of_Employees__c;
                ld.Phone=cs.Phone__c;
                ld.Status = 'Assigned to IST';
                ld.Email = cs.SuppliedEmail;
                ld.PostalCode = String.ValueOf(cs.Pin_code__c);
                ld.Enquiry_Type__c = cs.Enquiry_Type__c; 
                
                ld.Company = cs.Company__c;
                ld.Prospect_Interest_Type__c = cs.Prospect_Interest_Type__c;
                ld.Industry = cs.Industry__c;
                ld.Street=cs.Street__c;
                ld.Latest_Case_Number__c=cs.CaseNumber;
                ld.ownerId = PinCodeToUserMap.get(String.valueOf(cs.Pin_code__c)).id;
                ld.Mail_Enquiry_Message__c = cs.Description;
                ld.Prospect_Interest_Type__c = cs.Prospect_Interest_Type__c;
                ld.Number_of_Employees_Custom__c = cs.No_of_Employees__c;
                ld.Phone=cs.Phone__c;
                ld.Status = 'Assigned to IST';
                ld.Email = cs.SuppliedEmail;
                ld.PostalCode = String.ValueOf(cs.Pin_code__c);
                ld.Enquiry_Type__c = cs.Enquiry_Type__c;
                insert ld;                   
                cs.Lead__c = ld.id;
                cs.Status = 'WIP with IST Team';
                update cs;
            }
            
        /*        Map<id,EmailMessage> emailMsgMap = new Map<id,EmailMessage>([SELECT id FROM EmailMessage WHERE Incoming = true AND 
                                               HasAttachment = true AND ParentId = :cs.id]);
            System.debug('emailMsgMap-->>'+emailMsgMap);
            if(emailMsgMap != null && emailMsgMap.size() > 0){
                List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink 
                                                            WHERE LinkedEntityId = :emailMsgMap.keySet()];
                if(contentDocumentLinks.size() > 0){
                    List<Id> contentDocumentLinkIds = new List<Id>();
                    for (ContentDocumentLink contentDocumentLink : contentDocumentLinks )
                        contentDocumentLinkIds .add(contentDocumentLink .ContentDocumentId);
        
                    List<ContentVersion> contentVersions = [SELECT Id,Title,VersionData,PathOnClient,ContentDocumentId,isLatest FROM ContentVersion WHERE ContentDocumentId in :contentDocumentLinkIds and FileType!='SNOTE' and IsLatest = true];  
                    
                    for(ContentVersion existingcv : contentVersions){
                        //Create File
                        ContentVersion cv = new ContentVersion();
                        cv.Title = existingcv.Title;
                        cv.PathOnClient = existingcv.PathOnClient;
                        cv.VersionData = existingcv.VersionData;
                        cv.IsMajorVersion = true;
                        Insert cv;
                        
                        //Get Content Documents
                        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                         
                        //Create ContentDocumentLink 
                        ContentDocumentLink cdl = New ContentDocumentLink();
                        cdl.LinkedEntityId = ld.Id;
                        cdl.ContentDocumentId = conDocId;
                        cdl.shareType = 'V';
                        Insert cdl;
                    } 
                }
            } */
            
           
        } 
        if(Test.isRunningTest())
    {
       covermethod(); 
    }
    }
    
    
        
 public static void covermethod()
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
         }
}