({
    showToast: function(type, title, message, time) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message,
            "duration": time
        });
        toastEvent.fire();
    },

    closeModel : function(component, event, helper) {
        component.set("v.Spinner", false);
        $A.get("e.force:closeQuickAction").fire();    
   },
})