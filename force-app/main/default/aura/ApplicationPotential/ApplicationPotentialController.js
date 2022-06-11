({
	doInit : function(cmp, event, helper) 
    {
        var action = cmp.get("c.getapplicationPotential");
        var sobjecttype=cmp.get("v.sobjecttype");
        var recordId=cmp.get("v.recordIDcustom");
        action.setParams({ sobjectId:recordId ,sObjectType:sobjecttype});
      action.setCallback(this, function(response) 
      {
          var state = response.getState();
         
          if (state === "SUCCESS") 
          {
             var responsecontroller=response.getReturnValue();
             cmp.set("v.applicationPotentialObj",responsecontroller);
             cmp.set("v.estimatedAnnulized",responsecontroller.Estimated_annualized_potential);
             console.log('responsecontroller',responsecontroller.Estimated_annualized_potential);
          }
          else if (state === "INCOMPLETE") 
          {
              alert('INCOMPLETE');
          }
          else if (state === "ERROR") 
          {
              //alert('ERROR');
              var errors = response.getError();
              if (errors) 
              {
                  if (errors[0] && errors[0].message) 
                  {
                        console.log("Error message: " + 
                                 errors[0].message);
                   }
              } 
              else 
              {
                    console.log("Unknown error");
              }
            }
         
        });
         $A.enqueueAction(action);
 
	}
})