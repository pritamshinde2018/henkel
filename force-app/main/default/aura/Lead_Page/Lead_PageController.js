({
    handleClick : function(component, event, helper) {
        helper.helperClick(component);
    },
    successClick : function(component, event, helper) {
         $A.get('e.force:refreshView').fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        "title": "Success!",
        "message": "The record has been updated successfully.",
         "type": "success"
    });
    toastEvent.fire();
    },
    helperClear : function(component) {
    	component.set("v.Industry", null);
    	component.set("v.Employees", null);
    	component.set("v.Role", null);
    	component.set("v.Street", null);
    	component.set("v.City", null);
    	component.set("v.State", null);
    	component.set("v.Country", null);
},
     showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    handleError: function (component, event, helper) {
        component.set('v.loading', false);
        //component.find('OppMessage').setError('Please add Product Requested, Address, Email, Mobile, Name, Industry, No. Of Employees And What is the purpose/use.');
    }
    
   /* handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    }*/
 })