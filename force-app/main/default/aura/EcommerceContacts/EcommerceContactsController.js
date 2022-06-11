({
	 doInit: function(component, event, helper) {
         
         // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
         // method for get picklist values dynamic
         //console.log('output',component.get('v.singleRec.Number_of_Employees_Custom__c'));   
         helper.fetchPickListVal(component, 'Number_of_Employees_Custom__c', 'ratingPicklistOpts');
         helper.fetchPickList(component, 'What_is_the_purpose_use__c', 'ratingPicklistOpts1');
         helper.fetchPickList2(component, 'Source_CC__c', 'ratingPicklistOpts2');
         helper.fetchPickList3(component, 'Industry', 'ratingPicklistOpts3');
         var roleInOrg=[{
                        class: "optionClass",
                        label:'I take all decisions related to purchase of material/parts used in manufacturing, repair and maintenance',
                        value: 'I take all decisions related to purchase of material/parts used in manufacturing, repair and maintenance'
                    },{
                        class: "optionClass",
                        label:'I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance',
                        value: 'I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance'
                    },
                       {
                        class: "optionClass",
                        label:'I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning',
                        value:'I operate, repair and maintain machinery or repair vehicles to ensure smooth functioning'
                    }];
         component.set('v.RoleinOrg',roleInOrg);
         console.log('ratingPicklistOpts3',component.get('v.ratingPicklistOpts3'));
    },
    
    inlineEditName : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
     inlineEditRating4 : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.ratingEditMode4", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accRating4").set("v.options" , component.get("v.RoleinOrg"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accRating4").focus();
        }, 100);
     },
    inlineEditccremark2 : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode1", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId1").focus();
        }, 100);
    },
    inlineEditccremark3 : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode2", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId2").focus();
        }, 100);
    },
    
    inlineEditName4 : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode3", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId3").focus();
        }, 100);
    },
    inlineEditName5 : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode4", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId4").focus();
        }, 100);
    },
    inlineEditName6 : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode5", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId5").focus();
        }, 100);
    },
   
    
    inlineEditRating : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.ratingEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accRating").set("v.options" , component.get("v.ratingPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accRating").focus();
        }, 100);
    },
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
      
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner
       
       component.set("v.Spinner", false);
    },
    inlineEditRating1 : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.ratingEditMode1", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accRating1").set("v.options" , component.get("v.ratingPicklistOpts1"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accRating1").focus();
        }, 100);
    },
    inlineEditRating2 : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.ratingEditMode2", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accRating2").set("v.options" , component.get("v.ratingPicklistOpts2"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accRating2").focus();
        }, 100);
    },
    
     inlineEditRating3 : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.ratingEditMode3", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accRating3").set("v.options" , component.get("v.ratingPicklistOpts3"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accRating3").focus();
        }, 100);
    },
     onNameChange : function(component,event,helper){ 
        // if edit field value changed and field not equal to blank,
        // then show save and cancel button by set attribute to true
        if(event.getSource().get("v.value") != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    },
 
    onRatingChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeNameBox : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    closeNameBox1 : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode1", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    closeNameBox2 : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode2", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    closeNameBox3 : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode3", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    closeNameBox4 : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode4", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    closeNameBox5 : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode5", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value") == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
	closeRatingBox4 : function (component, event, helper) {
        component.set("v.ratingEditMode4", false); 
    },	
    closeRatingBox : function (component, event, helper) {
        component.set("v.ratingEditMode", false); 
    },
    closeRatingBox1 : function (component, event, helper) {
        component.set("v.ratingEditMode1", false); 
    },
    closeRatingBox2 : function (component, event, helper) {
        component.set("v.ratingEditMode2", false); 
    },
    closeRatingBox3 : function (component, event, helper) {
        component.set("v.ratingEditMode3", false); 
    },
    
})