({
    helperClick : function(component) {
        
        var action = component.get("c.insertLead");
        
        var lead = {
            recId : component.get("v.recordId"),
            Industry : component.get("v.Industry"),
            Employees : component.get("v.Employees"),
            Role : component.get("v.Role"),
            Street : component.get("v.Street"),
            City : component.get("v.City"),
            State : component.get("v.State"),
            Country : component.get("v.Country")
        };
        
        //alert(component.get("v.recordId"));
        action.setParams({'ctaId' : component.get("v.recordId")});
                          
 		action.setCallback(this,function(response){
           // alert(response.getState());
            //alert(response.getReturnValue().cause);
            //alert(response.getReturnValue().line);
            //alert(response.getReturnValue().error);
            if (response.getState() === "SUCCESS"){
                
                if(response.getReturnValue())
                {
                	component.set("v.recId", response.getReturnValue().ctaRecord.Lead__c);   
                    //alert(response.getReturnValue().ctaRecord.Lead__c);
                }
            }
            });
                          
        $A.enqueueAction(action);
                          
       }
})