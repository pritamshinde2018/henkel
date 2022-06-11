({
    getuserData : function(component, pageNumber, pageSize) {
        
        var action1 = component.get("c.fetchAccount");
        action1.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
      
        
        action1.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.data", resultData.contactList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
        
                else {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action1);      
    },
	requiredValidation : function(component,event) 
    {var allRecords = component.get("v.AccountList");
        var isValid = true;
        // play a for loop on all account list and check that account name is not null,   
        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].Name == null || allRecords[i].Name == ''){
                alert('Complete this field : Row No ' + (i+1) + ' Name is null' );
                isValid = false;
            }  
        }
        return isValid;
    },
})