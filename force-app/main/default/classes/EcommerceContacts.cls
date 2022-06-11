public with sharing class EcommerceContacts 
{
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            system.debug('a'+a.getValue());
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
        public static List < String > findselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    public static List < String > selectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
     @AuraEnabled
    public static List < String > selectIndustryOptions(/*sObject objObject, string fld*/) {
        System.debug('I am in selectIndustryOptions');
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();//Change
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get('Industry').getDescribe().getPickListValues(); //Change
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
     @AuraEnabled
    public static ContactDataTableWrapper fetchAccount(Decimal pageNumber, Decimal pageSize) {
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
         
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
         
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Contact where 
                 ((Account.Industry = '' Or Account.Industry = Null) OR Number_of_Employees_Custom__c = Null 
                 OR CC_Remarks_1__c = Null OR CC_Remarks_2__c = Null OR CC_Remarks_3__c = Null) AND Prospect_Interest_Type__c = 'E-Commerce'];
        Integer recordEnd = pSize * pNumber;
 
        //Instance of Contact DataTable Wrapper Class
        ContactDataTableWrapper objDT =  new ContactDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        
        
        objDT.contactList = [SELECT Id, Name,Prospect_Interest_Type__c,MailingStreet, Phone, Email, LeadSource,CreatedDate,Account.Name,Account.Industry,
                 Number_of_Employees_Custom__c,What_the_company_does__c,What_is_the_purpose_use__c,
                 CC_Remarks_1__c,CC_Remarks_2__c,CC_Remarks_3__c,Source__c,	Reference_link__c,Source_CC__c FROM Contact where 
                 ((Account.Industry = '' Or Account.Industry = Null) OR Number_of_Employees_Custom__c = Null) 
                 AND (CC_Remarks_1__c = Null OR CC_Remarks_2__c = Null OR CC_Remarks_3__c = Null) AND Prospect_Interest_Type__c = 'E-Commerce'  LIMIT :pSize OFFSET :offset];
        
        
        return objDT;
    }
    
      @AuraEnabled
    public static List < contact > saveAccount(List<contact> lstAccount) {
        System.debug('lstAccount------ '+lstAccount[0].Account.Industry);
        
        Map<Id,Account> maptoUpdate=new Map<Id,Account>();
        for(Contact cnt : lstAccount)
        {
           if(cnt.account!=null)
           {
           Account acc=new Account();
           acc.Industry=cnt.Account.Industry;
           acc= cnt.account;
           maptoUpdate.put(cnt.accountId,acc);
           }
        }
        update lstAccount;
        if(maptoUpdate.values().size()!=0)
        update maptoUpdate.values();
        return lstAccount;
    }
    
    public class ContactDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Contact> contactList {get;set;}
    }

}