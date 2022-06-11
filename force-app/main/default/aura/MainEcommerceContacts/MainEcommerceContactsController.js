({
    init: function (component, event, helper) { 
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 	
                  helper.getuserData(component,pageNumber, pageSize);
            
       
     },
    
    
     
     Save: function(component, event, helper) {
      // Check required fields(Name) first in helper method which is return true/false
            
             // var user=component.get('v.currentUser');
            // var monthYear=component.get('v.currentMonth');
             // call the saveAccount apex method for update inline edit fields update 
               var action = component.get("c.saveAccount");
                  action.setParams({
                      lstAccount: component.get("v.data"),
                     // userId : user.Id,
                     // monthYear:monthYear
                  });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                     var rows = response.getReturnValue();
                             component.set('v.data',rows);
                             component.set("v.showSaveCancelBtn",false);
                    		 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Records has been updated successfully."
                    });
                    toastEvent.fire();
                    
                }
            });
            $A.enqueueAction(action);
    },
    cancel : function(component,event,helper){
       // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var setSrNumber=(pageNumber)*pageSize;
        component.set("v.SerialNum",setSrNumber);
        pageNumber++;
        helper.getuserData(component, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var setSrNumber=(pageNumber-2)*pageSize;
        component.set("v.SerialNum",setSrNumber);
        pageNumber--;
        helper.getuserData(component, pageNumber, pageSize);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getuserData(component, page, pageSize);
    },
})