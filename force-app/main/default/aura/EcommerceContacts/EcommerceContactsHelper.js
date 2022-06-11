({
    // fetch picklist values dynamic from apex controller 
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    
     fetchPickList: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.findselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues1"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPickList2: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.findselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues2"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    
     fetchPickList3: function(component, fieldName, picklistOptsAttributeName) {
         //alert();
        var action = component.get("c.selectIndustryOptions");
         
        /*action.setParams({
            "objObject": "Account",
            "fld": "Industry"
        });*/
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
     
})