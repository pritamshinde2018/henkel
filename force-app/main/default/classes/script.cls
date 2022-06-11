public class script {
     public static List<String> emailList = new List<String>();
    
    public static void getData()
    {
       if(test.isRunningTest())
           emailList.add('testusha@gmail.com');
        
        //emailList.add('testpriya@gmail.com');
       // emailList.add('testneha@gmail.com');
          
        //emailList.add('henna@gmail.com');
        // emailList.add('terance.masiah@ldaho.biz');
        // emailList.add('gerson.caedmon@ldaho.biz');
        //emailList.add('lamon.crayson@ldaho.biz');
        
        List<Contact> con = [select Id, Name, Email, AccountId, zipcode__c from Contact where Email IN : emailList];
        system.debug('****con***'+con);
        List<Products_on_Cart__c> prod = [select Id, Customer_Contact__c from Products_on_Cart__c];
        List<Opportunity> oppList = new List<Opportunity>();
        List<Products_on_Cart__c> prodList = new List<Products_on_Cart__c>();
        
        List<User> allUesrs = [select Id, Pin_codes__c from User where ProfileId =: Label.IST_Profile_For_Abandoned];
        List<String> allPinCodes = new List<String>();
        List<ID> listOFID = new List<ID>();
        for(User u : allUesrs)
        {
            if(u.Pin_codes__c!=null)
            {
                allPinCodes.add(u.Pin_codes__c);
                listOFID.add(u.id);
            }
        }
        
        for(Contact cont : con)
        {
            System.debug(cont);
            string contactZip = cont.zipcode__c;
            for(Products_on_Cart__c pr : prod)
            {
                if(pr.Customer_Contact__c == cont.Id)
                {
                    prodList.add(pr);  
                }
            }
            
            if(!prodList.isEmpty())
            {
                System.debug('*****hi*****');
                Opportunity opp = new Opportunity();
                opp.Contact2__c = cont.Id;
                opp.AccountId = cont.AccountId;
                opp.Name = 'DG-AG-SU-Product-Application';
                opp.StageName = 'Sample Sent/Inquiry Received';
                opp.Probability = 15;
                opp.CloseDate = Date.Today().addDays(60);
                opp.Flag_Product_Check__c = true;
                opp.Flag_abandoned_cart__c = true;
                opp.Status__c = 'Active';
                Integer a = -1;
                for(String pinCode:allPinCodes)
                {
                    a++;
                    if(pinCode.Contains(contactZip))
                    {
                        opp.Assigned_IST_User__c = listOFID[a];
                        system.debug(listOFID[a]+'*******pinCode Match*********');
                        break;
                    }
                }
                //opp.Assigned_IST_User__c = '0057F0000011Dlq';
                insert opp;
               // oppList.add(opp);
            }
          
            Set<String> allSkuId = new Set<String>();
            List<Products_on_Cart__c> listId = [select sku__c,Quanitity__c,Price__c from Products_on_Cart__c where Customer_Contact__c =: cont.Id];
            for(Integer r = 0; r < listId.size(); r++){
                allSkuId.add(listId[r].sku__c);
            }
            System.debug('*********allSkuId****'+allSkuId);
            Map<String,String> prodMap = new  Map<String,String>();
            for(Product2 prodm :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: allSkuId and IsActive=true])
            {
                prodMap.put(prodm.IB_SKU__c,prodm.Id);
            }
            System.debug('Product Map is:..... '+prodMap);
            List<OpportunityLineItem> oppItemList = new List<OpportunityLineItem>();
            String newId;
            List<Opportunity> lstOpp = [select Id,Flag_Product_Check__c from Opportunity where Contact2__c =: cont.Id];
            System.debug('*******lstOpp*********'+lstOpp);
            for(Opportunity opt : lstOpp){
                newId = opt.id;
            }
            List<OpportunityLineItem> oppLineitem =[Select Id From OpportunityLineItem where OpportunityId IN :lstOpp];
            system.debug('*****oppLineitem*****'+oppLineitem);
            
            if(prodMap != null){
                for(Integer p = 0; p< listId.size(); p++){
                    if(prodMap.get(listId[p].SKU__c) != null){
                        system.debug('listId[p].SKU__c'+listId[p].SKU__c);
                        List<OpportunityLineItem> prodPrice = [select Id,ListPrice from OpportunityLineItem where Product2.IB_SKU__c=: listId[p].SKU__c ];
                        System.debug('***prodPrice***'+prodPrice);
                        
                        List<pricebookentry> priceidList = [select Id,UnitPrice from pricebookentry where Product2Id =: prodMap.get(listId[p].SKU__c) limit 1];
                        
                        if(priceidList!=null && priceidList.size() >0 && prodPrice.size()>0){
                            OpportunityLineItem oppItem = new OpportunityLineItem();
                            oppItem.OpportunityId = newId;
                            oppItem.PricebookEntryId = priceidList[0].id;
                            oppItem.Quantity = Decimal.valueOf(listId[p].Quanitity__c);
                            oppItem.UnitPrice = priceidList[0].UnitPrice;
                            //oppItem.TotalPrice = prodPrice[p].ListPrice ;
                            
                            oppItemList.add(oppItem);
                        }
                        
                        
                    }
                    
                }
                try
                {
                    if(oppItemList.size()>0){
                        insert oppItemList;
                    }
                    
                }
                catch(Exception e)
                {
                    system.debug('exception...  '+e.getMessage()+'***line no*****'+e.getLineNumber());
                }
                
            }
            
            Task t = new Task();
            List<Task> tlist = new List<Task>();
            system.debug('*******Task*******');
            List<Opportunity> lp = [select Id,Flag_abandoned_cart__c, Assigned_IST_User__c from Opportunity where Id IN : lstOpp];
            System.debug('**********lp******'+lp);
            for(Opportunity o : lp){
                System.debug('**********IN FOR******'+o.Flag_abandoned_cart__c);
                if(o.Flag_abandoned_cart__c != False){
                    System.debug('**********IN FOR IF******'+o.Flag_abandoned_cart__c);
                    t.WhatId = o.Id;
                    t.OwnerId=o.Assigned_IST_User__c;
                    t.subject='Validate Abandoned Cart Reason';
                    t.Status = 'Open';
                    t.Priority = 'High';
                    tlist.add(t);
                    
                }
            }
            try{
                insert tlist;
            }
            catch(Exception e){
                System.debug('exception'+e.getMessage());
            }
            
        }       
    }
    
}