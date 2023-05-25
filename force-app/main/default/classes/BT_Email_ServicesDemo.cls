global with sharing class BT_Email_ServicesDemo implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('fromAddress --> ' + email.fromAddress);
        system.debug('toaddress -->'+ email.toAddresses);
        system.debug('email subject--> '+ email.subject);
        system.debug('email subject--> '+ email.plainTextBody);
        
        system.debug('email --> '+ email);
        system.debug('envelope -->'+ envelope);

        String replyTo = email.replyTo;
        String[] toAddresses = email.toAddresses;
        String fromAddress = email.fromAddress;
        String[] ccAddresses = email.ccAddresses;
        String fromname = email.fromname;
        String emailSubject = email.Subject;
        String htmlBody = email.htmlBody;
        String plainTextBody = email.plainTextBody;
        String inReplyTo = email.inReplyTo;
        String messageId = email.messageId;
        String[] references = email.references;
        Id fromId;
        Id contactId;
        Id userId;

        try{
            fromId = [Select Id
                      from Contact
                      where Email = :fromAddress
                      LIMIT 1].Id;
            contactId = fromId;

        } catch (exception ex){
            system.debug(ex);
        }
        
        try{
            list<user> ulist  = [Select Id, Email from user where Email = :fromAddress limit 1];
            if(ulist.size()>0){
                userId =  ulist[0].Id;  
            }
           

        } catch (exception ex){
            system.debug(ex);
        }
        string emailaddress;
        list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
        list<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodeConfigurations = [Select Id,buildertek__Email_Address__c
                                                                                              from buildertek__Admin_Interface_Node_Configuration__c
                                                                                              WHERE Name = :'Email Configuration'];
        if (adminInterfaceNodeConfigurations.size() > 0){
                    owea = [select Id from OrgWideEmailAddress where Address =: adminInterfaceNodeConfigurations[0].buildertek__Email_Address__c];
         }
        
        system.debug(fromId);
        system.debug(emailSubject.indexOf('[ref'));
        if (emailSubject.indexOf('[ref') != -1){
            if (emailSubject.indexOf('[ref:') != -1){
                String relatedToId = emailSubject.split('ref:')[1];
                system.debug('---relatedToId---' + relatedToId);
                relatedToId = relatedToId.split(']')[0].trim();
                system.debug('relatedToId ----------> ' + relatedToId);

                String objectAPI = Id.valueOf(relatedToId).getSObjectType().getDescribe().getName();
                system.debug('objectAPI ---------> ' + objectAPI);
                String queryString;
                String salesRepEmailId = '';
                system.debug(objectAPI.toLowerCase());

                if (objectAPI.toLowerCase() == 'buildertek__rfq_to_vendor__c'){
                    String status = plainTextBody.split('\n')[0];

                    if (status.toLowerCase() == 'accepted'){
                        buildertek__rfq_to_vendor__c rfqToVendor;
                        rfqToVendor = [select Id, name, buildertek__status__c, buildertek__RFQ__c,buildertek__Accepted_Date__c
                                    from buildertek__rfq_to_vendor__c
                                    where id = :relatedToId];

                        if (rfqToVendor.Id != null){
                            rfqToVendor.buildertek__status__c = 'Accepted';
                            rfqToVendor.buildertek__Accepted_Date__c = system.now();
                            update rfqToVendor;

                            if (rfqToVendor.buildertek__RFQ__c != null){
                                buildertek__RFQ__c rfqRec = [SELECT Id, Name, buildertek__Accepted_Date__c, buildertek__Awarded_Date__c, buildertek__RFQ_s_Replied_To__c
                                                            FROM buildertek__RFQ__c
                                                            WHERE Id = :rfqToVendor.buildertek__RFQ__c];

                                rfqRec.buildertek__Accepted_Date__c = System.today(); // here we update the accepted date when the status is accepted
                                rfqRec.buildertek__status__c = 'Accepted';
                                update rfqRec;
                            }
                        }
                    } else if (status.toLowerCase() == 'canceled' || status.toLowerCase() == 'rejected'){
                        System.debug('Status::' + status);
                        buildertek__rfq_to_vendor__c refqVendor;
                        if (Schema.sObjectType.buildertek__rfq_to_vendor__c.fields.id.isAccessible() && Schema.sObjectType.buildertek__rfq_to_vendor__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__rfq_to_vendor__c.fields.buildertek__RFQ__c.isAccessible()){
                            refqVendor = [SELECT Id, Name, buildertek__RFQ__c
                                        FROM buildertek__rfq_to_vendor__c
                                        WHERE Id = :relatedToId];
                        }

                        buildertek__rfq_to_vendor__c rfqToVendor = new buildertek__rfq_to_vendor__c();
                        rfqToVendor.Id = relatedToId;
                        rfqToVendor.buildertek__status__c = status;
                        rfqToVendor.buildertek__Rejected_Date__c = system.now();
                        rfqToVendor.buildertek__Awarded_Date__c = null;
                        update rfqToVendor;
                        System.debug('RFQ To vendor::' + rfqToVendor);

                        buildertek__RFQ__c rfq;
                        rfq = [SELECT Id, Name, buildertek__Accepted_Date__c, buildertek__Awarded_Date__c, buildertek__RFQ_s_Replied_To__c
                            FROM buildertek__RFQ__c
                            WHERE Id = :refqVendor.buildertek__RFQ__c];

                        if (rfq != null){
                            rfq.buildertek__Status__c = 'Canceled';
                            rfq.buildertek__Awarded_Date__c = null;

                            update rfq;
                            System.debug('Updated RFQ::' + rfq);
                            System.debug([SELECT Id, Name, buildertek__Status__c FROM buildertek__rfq_to_vendor__c WHERE Id = :relatedToId]);
                        }
                    }
                }
            }
            result.success = true;
        }
        return result;
    }
}