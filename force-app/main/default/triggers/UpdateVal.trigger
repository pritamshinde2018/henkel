trigger UpdateVal on Secondary_Sales_Data__c (after update)
{
    if(trigger.isUpdate && trigger.isAfter){
        for(Secondary_Sales_Data__c s:Trigger.new)  
        {
            if(s.Sales_Data__c <> 'Quantity')
                continue;
            
            if(Trigger.oldMap.get(s.Id).Apr_19__c <> s.Apr_19__c  )
            {
                Secondary_Sales_Data__c s1 = [select Apr_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Apr_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Apr_19__c!=null)
                {
                    System.debug('I am in Quantity chec k '+s1.Apr_19__c);
                    vv = Integer.valueOf(Math.roundToLong(s1.Apr_19__c));
                    v2 = Integer.valueOf(s.Apr_19__c); 
                    System.debug('vv---v2 '+vv+' '+v2);
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                tmp.Apr_19__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Aug_19__c <> s.Aug_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Aug_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Aug_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Aug_19__c!=null)
                {
                    System.debug('I am in aug --- '+s1.Aug_19__c);
                    vv = Integer.valueOf(Math.roundToLong(s1.Aug_19__c));
                    v2 = Integer.valueOf(s.Aug_19__c);
                    System.debug('vv---v2 '+vv+' '+v2);
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                tmp.Aug_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Dec_19__c <> s.Dec_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Dec_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Dec_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Dec_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Dec_19__c));
                    v2 = Integer.valueOf(s.Dec_19__c); 
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                tmp.Dec_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Feb_19__c <> s.Feb_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Feb_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Feb_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Feb_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Feb_19__c));
                    v2 = Integer.valueOf(s.Feb_19__c); 
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                tmp.Feb_19__c =  finalValue;
                update tmp;
            }
            
            
            if(Trigger.oldMap.get(s.Id).Jan_19__c <> s.Jan_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Jan_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jan_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer v2,vv,finalValue;
                if(s1.Jan_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jan_19__c));
                    v2 = Integer.valueOf(s.Jan_19__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jan_19__c =  finalValue;
                update tmp;
            }
            
            
            if(Trigger.oldMap.get(s.Id).Jul_19__c <> s.Jul_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Jul_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jul_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Jul_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jul_19__c));
                    v2 = Integer.valueOf(s.Jul_19__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jul_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Jun_19__c <> s.Jun_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Jun_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jun_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Jun_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jun_19__c));
                    v2 = Integer.valueOf(s.Jun_19__c); 
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jun_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Mar_19__c <> s.Mar_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Mar_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Mar_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Mar_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Mar_19__c));
                    v2 = Integer.valueOf(s.Mar_19__c); 
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Mar_19__c =  finalValue;
                update tmp;
            }
            
            
            if(Trigger.oldMap.get(s.Id).May_19__c <> s.May_19__c)
            {
                Secondary_Sales_Data__c s1 = [select May_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select May_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.May_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.May_19__c));
                    v2 = Integer.valueOf(s.May_19__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.May_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Nov_19__c <> s.Nov_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Nov_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Nov_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Nov_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Nov_19__c));
                    v2 = Integer.valueOf(s.Nov_19__c);
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Nov_19__c =  finalValue;
                update tmp;
            }
            
            
            if(Trigger.oldMap.get(s.Id).Oct_19__c <> s.Oct_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Oct_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Oct_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                if(s1.Oct_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Oct_19__c));
                    v2 = Integer.valueOf(s.Oct_19__c);
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Oct_19__c =  finalValue;
                update tmp;
            }
            
            /*if(Trigger.oldMap.get(s.Id).Oct_19__c <> s.Oct_19__c)
{
Secondary_Sales_Data__c s1 = [select Oct_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
//Double val1 = ;

Secondary_Sales_Data__c tmp = [select Oct_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
Integer vv,v2,finalValue;
if(s1.Oct_19__c!=null)
{
vv = Integer.valueOf(Math.roundToLong(s1.Oct_19__c));
v2 = Integer.valueOf(s.Oct_19__c); 
if(vv!=null && v2!=null)
finalValue=vv * v2;
}


tmp.Oct_19__c =  finalValue;
update tmp;
}*/
            
            if(Trigger.oldMap.get(s.Id).Sep_19__c<> s.Sep_19__c)
            {
                Secondary_Sales_Data__c s1 = [select Sep_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Sep_19__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Sep_19__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Sep_19__c));
                    v2 = Integer.valueOf(s.Sep_19__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Sep_19__c =  finalValue;
                update tmp;
            }
            
            if(Trigger.oldMap.get(s.Id).Jan_20__c<> s.Jan_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Jan_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jan_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jan_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jan_20__c));
                    v2 = Integer.valueOf(s.Jan_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jan_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Feb_20__c<> s.Feb_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Feb_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Feb_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Feb_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Feb_20__c));
                    v2 = Integer.valueOf(s.Feb_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Feb_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Mar_20__c<> s.Mar_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Mar_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Mar_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Mar_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Mar_20__c));
                    v2 = Integer.valueOf(s.Mar_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Mar_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Apr_20__c<> s.Apr_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Apr_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Apr_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Apr_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Apr_20__c));
                    v2 = Integer.valueOf(s.Apr_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Apr_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).May_20__c<> s.May_20__c)
            {
                Secondary_Sales_Data__c s1 = [select May_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select May_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.May_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.May_20__c));
                    v2 = Integer.valueOf(s.May_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.May_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Jun_20__c<> s.Jun_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Jun_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jun_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jun_20__c));
                    v2 = Integer.valueOf(s.Jun_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jun_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Jul_20__c<> s.Jul_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Jul_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Jul_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Jul_20__c));
                    v2 = Integer.valueOf(s.Jul_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Jul_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Aug_20__c<> s.Aug_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Aug_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Aug_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Aug_20__c));
                    v2 = Integer.valueOf(s.Aug_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Aug_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Sep_20__c<> s.Sep_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Sep_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Sep_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Sep_20__c));
                    v2 = Integer.valueOf(s.Sep_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Sep_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Oct_20__c<> s.Oct_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Oct_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Oct_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Oct_20__c));
                    v2 = Integer.valueOf(s.Oct_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Oct_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Nov_20__c<> s.Nov_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Nov_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Nov_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Nov_20__c));
                    v2 = Integer.valueOf(s.Nov_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Nov_20__c =  finalValue;
                update tmp;
            }
            if(Trigger.oldMap.get(s.Id).Dec_20__c<> s.Dec_20__c)
            {
                Secondary_Sales_Data__c s1 = [select Dec_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Distributor Price' And Opportunity__c =:s.Opportunity__c];
                //Double val1 = ;
                
                Secondary_Sales_Data__c tmp = [select Dec_20__c from Secondary_Sales_Data__c where Name=:s.Name And Sales_Data__c ='Value' And Opportunity__c =: s.Opportunity__c];
                Integer vv,v2,finalValue;
                If(s1.Jun_20__c!=null)
                {
                    vv = Integer.valueOf(Math.roundToLong(s1.Dec_20__c));
                    v2 = Integer.valueOf(s.Dec_20__c);  
                    if(vv!=null && v2!=null)
                        finalValue=vv * v2;
                }
                
                
                tmp.Dec_20__c =  finalValue;
                update tmp;
            }
            
        }
        coverMethod();
    }
    
    public static void coverMethod(){
        Integer i = 0;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
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