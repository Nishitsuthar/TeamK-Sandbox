({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
	    var recordId = component.get("v.recordId");
        var action = component.get("c.getOpportunity");
        action.setParams({ 
           recordId: recordId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                var oppData = response.getReturnValue();
                component.set("v.OpportunityData", oppData);
                if(oppData.AccountId != undefined){
                    component.find("accountId").set("v.value", oppData.Account.Id); 
                }

                var action1 = component.get("c.getProjectRecordType");
                action1.setCallback(this, function(response) {
                    if(response.getState() === "SUCCESS"){
                        var recordTypeData = response.getReturnValue();
                        if (recordTypeData.length > 0) {
                            var recordTypeList = [];
                            var CheckBoxValue = '';
                            recordTypeData.forEach(element => {
                                recordTypeList.push({'label': element.Name, 'value': element.Id})
                                if (oppData.Type != undefined && element.Name.includes(oppData.Type)) {
                                    CheckBoxValue = element.Id;
                                }
                            });
                            if (CheckBoxValue == '') {
                                CheckBoxValue = recordTypeData[0].Id;
                            }
                            component.set("v.CheckBoxOptions", recordTypeList);
                            component.set("v.CheckBoxValue", CheckBoxValue);
                        } else{
                            component.set("v.hideSelectType", true);
                        }
                    }
                    component.set("v.Spinner", false);
                });
                $A.enqueueAction(action1);

            } else{
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    closeModel : function(component, event, helper) { 
        helper.closeModel(component, event, helper);
    },

   saveModel : function(component, event, helper) {
    
        var CheckBoxValue = component.get("v.CheckBoxValue");
        console.log('CheckBoxValue ==> ',{CheckBoxValue});

        if (CheckBoxValue.length > 0) {
            component.set("v.Spinner", true);
            var project = component.find("projectNameId").get("v.value");
            var accountId = component.find("accountId").get("v.value");
            debugger;
            var action = component.get("c.createProjectBatch");
            action.setParams({
                opp : component.get("v.OpportunityData"),
                projectName : project,
                account : accountId,
                recordTypeList : CheckBoxValue
            });
            action.setCallback(this, function(response){
                debugger
                var state = response.getState();
                console.log('state ',state);
                if(state === "SUCCESS"){
                    helper.showToast("Success", "Success", "Project Created successfully", "5000");
                }else{
                    console.log('Error ==> ',response.getError());
                    helper.showToast("Error", "Error", "Something Went Wrong", "5000");
                }
                helper.closeModel(component, event, helper)
            });
            $A.enqueueAction(action);
        }
        
    },

})