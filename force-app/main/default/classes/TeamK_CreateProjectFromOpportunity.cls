public with sharing class TeamK_CreateProjectFromOpportunity {
    @AuraEnabled
    public static Opportunity getOpportunity(String recordId){
        Opportunity opp = [SELECT Id, Name, Type, AccountId, Account.Name, Account.Billingstate, Account.Billingstreet, Account.Billingpostalcode, Account.Billingcity, buildertek__Notes__c, OwnerId FROM Opportunity WHERE Id =: recordId]; 
        return opp;
    }

    @AuraEnabled
    public static List<RecordType> getProjectRecordType(){
        List<RecordType> projectRecordTypes = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'buildertek__Project__c'];
        return projectRecordTypes;
    }
    
    @AuraEnabled
    public static string createProject(Opportunity opp, String projectName, String account, List<String> recordTypeList){
        String recordId = opp.Id;

        List<Id> quoteIdsList = new List<Id>();

        list<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodeConfigurations = [SELECT Id, buildertek__Org_Base_URL__c FROM buildertek__Admin_Interface_Node_Configuration__c WHERE Name=:'Quote Configuration' limit 1]; 

        List<buildertek__Quote__c> quoteList;
        quoteList = [SELECT Id, Name, buildertek__Description__c, buildertek__Quote_Amount__c, buildertek__Status__c, buildertek__Project__c, 
                        buildertek__Auto_Number__c, buildertek__Primary__c, buildertek__Markup__c, buildertek__Shipping_and_Handling__c,
                        buildertek__Profit_Margin__c, buildertek__Payment_Terms__c, buildertek__Discount__c, buildertek__Tax__c,
                        buildertek__Expires_On__c, buildertek__Sales_Rep__c, buildertek__Primary_Contact__c, buildertek__Start_Date__c, 
                        buildertek__Bill_To_Name__c, buildertek__Bill_To_Street__c, buildertek__Bill_To_City__c, buildertek__Bill_To_State__c, 
                        buildertek__Bill_To_Country__c, buildertek__Ship_To_Name__c, buildertek__Ship_To_Street__c, buildertek__Ship_To_City__c, 
                        buildertek__Ship_To_State__c, buildertek__Group_Line_Items__c,buildertek__OppToQuoteId__c, buildertek__Ship_To_Zip_Code__c, 
                        buildertek__Email_Body__c, buildertek__Email_Subject__c, buildertek__Ship_To_Country__c, buildertek__Bill_To_Zip_Code__c,
                        buildertek__Opportunity__c, buildertek__SignatureBase64__c, buildertek__Bill_To_Cell_Phone__c, buildertek__Bill_To_Email_Address__c, 
                        buildertek__Customer_Accepted_Date__c, buildertek__Date_Accepted_by_Customer__c, buildertek__Date_Sent_To_Customer__c, buildertek__Type__c 
                        FROM buildertek__Quote__c WHERE buildertek__Opportunity__c =: recordId AND (buildertek__Status__c = 'Approved' OR buildertek__Status__c = 'Customer Accepted')];

        Set<Id> contentDocumentIds1 = new Set<Id>();
        for(ContentDocumentLink conDoc : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId]){
            contentDocumentIds1.add(conDoc.ContentDocumentId);
        }
        List<ContentNote> contentNoteslist = new List<ContentNote>();
        List<ContentNote> contentNotes = [SELECT Id, Title, TextPreview, Content FROM ContentNote WHERE Id In: contentDocumentIds1];
        String[] tmp  = New String[]{};
        string textpreview = '';
        String TextPreview1;
        for(ContentNote c : contentNotes){
            tmp.add(c.Title + ' : ' + c.TextPreview);
        }
        TextPreview1 = string.join(tmp,'\n\n');
        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = projectName;
        if(account != null){
            project.buildertek__Account__c = account;
        }
        project.buildertek__Opportunity__c =  recordId;
        project.buildertek__State__c = opp.Account.Billingstate;
        project.buildertek__Address__c = opp.Account.Billingstreet;
        project.buildertek__Zip__c = opp.Account.Billingpostalcode;
        project.buildertek__City__c = opp.Account.Billingcity;
        if(TextPreview1 != null){
            project.buildertek__Notes__c = TextPreview1; 
        }
        if(account != null){
            project.buildertek__Customer__c = account;
        }
        project.OwnerId = opp.OwnerId;
        if(adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c != null && quoteList.size() > 0){
           project.buildertek__Pictures__c = adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c+'/lightning/r/buildertek__Quote__c/'+quoteList[0].Id+'/related/AttachedContentDocuments/view';
        }
        insert project;

        for(ContentNote c : contentNotes){
            textpreview = c.TextPreview;
            ContentNote noteRec = new ContentNote();
            noteRec.Title = c.Title;
            noteRec.Content = c.Content;
            contentNoteslist.add(noteRec);
        }
        if(contentNoteslist.size() > 0){
            insert contentNoteslist; 

            SET<Id> contentDocumentIds = new SET<Id>();
            List<ContentNote> contentVersionList = [SELECT Id FROM ContentNote WHERE Id IN: contentNoteslist];
            for(ContentNote cv : contentVersionList){
                contentDocumentIds.add(cv.Id);
            }
            List<ContentDocument> conDocList = [SELECT Id,Title FROM ContentDocument WHERE Id IN:contentDocumentIds];
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            if(project.id != null){
                for(ContentDocument cd : conDocList){
                    ContentDocumentLink objCntDocLink = new ContentDocumentLink();
                    objCntDocLink.LinkedEntityId = project.id; // Specify your parent Id 
                    objCntDocLink.ContentDocumentId = cd.Id;  //Content Note Id
                    objCntDocLink.shareType = 'V'; // Specify your sharing type 
                    cdlList.add(objCntDocLink);
                }
                insert cdlList; 
            }
        }        
        
        List<buildertek__Quote__c> quoteToUpdateList = new List<buildertek__Quote__c>();
        for(buildertek__Quote__c quote: quoteList){
            quoteIdsList.add(quote.Id); 
                
            buildertek__Quote__c quoteToUpdate = new buildertek__Quote__c(); 
            quoteToUpdate.Name = quote.Name  ;
            quoteToUpdate.buildertek__Description__c = quote.buildertek__Description__c  ;
            quoteToUpdate.buildertek__Status__c = quote.buildertek__Status__c ; 
            quoteToUpdate.buildertek__Project__c = project.Id;
            quoteToUpdate.buildertek__OppToQuoteId__c = quote.Id;
            quoteToUpdate.buildertek__Primary__c  = quote.buildertek__Primary__c;
            quoteToUpdate.buildertek__Markup__c  = quote.buildertek__Markup__c;
            quoteToUpdate.buildertek__Shipping_and_Handling__c = quote.buildertek__Shipping_and_Handling__c ;
            quoteToUpdate.buildertek__Profit_Margin__c  = quote.buildertek__Profit_Margin__c ;
            quoteToUpdate.buildertek__Payment_Terms__c  =quote.buildertek__Payment_Terms__c  ;
            quoteToUpdate.buildertek__Discount__c = quote.buildertek__Discount__c ;
            quoteToUpdate.buildertek__Tax__c = quote.buildertek__Tax__c ;
            quoteToUpdate.buildertek__Expires_On__c = quote.buildertek__Expires_On__c ;
            quoteToUpdate.buildertek__Sales_Rep__c = quote.buildertek__Sales_Rep__c ;
            quoteToUpdate.buildertek__Primary_Contact__c = quote.buildertek__Primary_Contact__c ;
            quoteToUpdate.buildertek__Start_Date__c  = quote.buildertek__Start_Date__c ;
            quoteToUpdate.buildertek__Bill_To_Name__c = quote.buildertek__Bill_To_Name__c ;
            quoteToUpdate.buildertek__Bill_To_Street__c = quote.buildertek__Bill_To_Street__c;
            quoteToUpdate.buildertek__Bill_To_City__c = quote.buildertek__Bill_To_City__c ;
            quoteToUpdate.buildertek__Bill_To_State__c  = quote.buildertek__Bill_To_State__c;
            quoteToUpdate.buildertek__Bill_To_Country__c  = quote.buildertek__Bill_To_Country__c ;
            quoteToUpdate.buildertek__Ship_To_Name__c  = quote.buildertek__Ship_To_Name__c ;
            quoteToUpdate.buildertek__Ship_To_Street__c = quote.buildertek__Ship_To_Street__c ;
            quoteToUpdate.buildertek__Ship_To_City__c  = quote.buildertek__Ship_To_City__c;
            quoteToUpdate.buildertek__Ship_To_State__c = quote.buildertek__Ship_To_State__c;
            quoteToUpdate.buildertek__Group_Line_Items__c  = quote.buildertek__Group_Line_Items__c ;
            quoteToUpdate.buildertek__Ship_To_Zip_Code__c = quote.buildertek__Ship_To_Zip_Code__c ;
            quoteToUpdate.buildertek__Email_Body__c = quote.buildertek__Email_Body__c;
            quoteToUpdate.buildertek__Email_Subject__c  = quote.buildertek__Email_Subject__c ;
            quoteToUpdate.buildertek__Ship_To_Country__c = quote.buildertek__Ship_To_Country__c ;
            quoteToUpdate.buildertek__Bill_To_Zip_Code__c  = quote.buildertek__Bill_To_Zip_Code__c ;
            quoteToUpdate.buildertek__SignatureBase64__c = quote.buildertek__SignatureBase64__c;
            quoteToUpdate.buildertek__Bill_To_Cell_Phone__c = quote.buildertek__Bill_To_Cell_Phone__c;
            quoteToUpdate.buildertek__Bill_To_Email_Address__c = quote.buildertek__Bill_To_Email_Address__c;
            quoteToUpdate.buildertek__Customer_Accepted_Date__c = quote.buildertek__Customer_Accepted_Date__c;
            quoteToUpdate.buildertek__Date_Accepted_by_Customer__c = quote.buildertek__Date_Accepted_by_Customer__c;
            quoteToUpdate.buildertek__Date_Sent_To_Customer__c = quote.buildertek__Date_Sent_To_Customer__c;
            quoteToUpdate.buildertek__Type__c = quote.buildertek__Type__c ;

            if(adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c != null){      
                quoteToUpdate.buildertek__Pictures__c = adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c+'/lightning/r/buildertek__Quote__c/'+quote.Id+'/related/AttachedContentDocuments/view';
            }
            quoteToUpdateList.add(quoteToUpdate);
                    
        }
            
        if(quoteToUpdateList.size() > 0){
            insert quoteToUpdateList; 
        }

        list<buildertek__Quote_Item__c> quoteItemList = [SELECT Id, Name, buildertek__Item_Name__c, buildertek__Description__c, buildertek__Quantity__c, buildertek__Unit_Price__c, 
                                                            buildertek__Total_Cost__c, buildertek__Quote__c, buildertek__Quote__r.buildertek__Opportunity__c, buildertek__Cost_Code__c, 
                                                            buildertek__Auto_Number__c, buildertek__Product__c, buildertek__Grouping__c, buildertek__UOM__c, buildertek__Vendor__c, 
                                                            buildertek__Markup__c, buildertek__Unit_Cost__c, buildertek__List_Total__c, buildertek__Net_Unit__c, buildertek__Applied_Markup__c, 
                                                            buildertek__Net_Total__c, buildertek__MFG_Discount__c, buildertek__List_Unit_Price__c, buildertek__Pricing_Method__c, buildertek__Discount__c, 
                                                            buildertek__Profit_Margin__c, buildertek__Net_Total_Price__c, buildertek__Notes__c, buildertek__Additional_Discount__c, buildertek__Purchase_Order__c 
                                                            FROM buildertek__Quote_Item__c WHERE buildertek__Quote__c IN: quoteIdsList AND buildertek__Quote__r.buildertek__Opportunity__c =:recordId ]; 

        if(quoteToUpdateList !=null){
        
            list<buildertek__Quote_Item__c> quoteitemreclst = new list<buildertek__Quote_Item__c>();
            for(buildertek__Quote_Item__c quoteitemrecs : quoteItemList){
                for(buildertek__Quote__c quoteid : quoteToUpdateList){
                    if(quoteid.buildertek__OppToQuoteId__c == quoteitemrecs.buildertek__Quote__c){
                        buildertek__Quote_Item__c quoteitem =  new buildertek__Quote_Item__c();
                        quoteitem.Name = quoteitemrecs.Name;
                        quoteitem.buildertek__Item_Name__c =quoteitemrecs.buildertek__Item_Name__c;
                        quoteitem.buildertek__Description__c = quoteitemrecs.buildertek__Description__c;
                        quoteitem.buildertek__Quantity__c = quoteitemrecs.buildertek__Quantity__c;
                        quoteitem.buildertek__Unit_Price__c =  quoteitemrecs.buildertek__Unit_Price__c;
                        quoteitem.buildertek__Quote__c = quoteid.Id;
                        quoteitem.buildertek__Cost_Code__c =  quoteitemrecs.buildertek__Cost_Code__c ;
                        quoteitem.buildertek__Product__c =  quoteitemrecs.buildertek__Product__c ;
                        quoteitem.buildertek__Grouping__c = quoteitemrecs.buildertek__Grouping__c ;
                        quoteitem.buildertek__UOM__c = quoteitemrecs.buildertek__UOM__c;
                        quoteitem.buildertek__Vendor__c = quoteitemrecs.buildertek__Vendor__c ;
                        quoteitem.buildertek__Markup__c = quoteitemrecs.buildertek__Markup__c ;
                        quoteitem.buildertek__Unit_Cost__c = quoteitemrecs.buildertek__Unit_Cost__c ;
                        quoteitem.buildertek__Applied_Markup__c = quoteitemrecs.buildertek__Applied_Markup__c ;
                        quoteitem.buildertek__Pricing_Method__c = quoteitemrecs.buildertek__Pricing_Method__c ;
                        quoteitem.buildertek__Notes__c = quoteitemrecs.buildertek__Notes__c;
                        quoteitem.buildertek__Purchase_Order__c = quoteitemrecs.buildertek__Purchase_Order__c;
                        quoteitem.buildertek__Additional_Discount__c = quoteitemrecs.buildertek__Additional_Discount__c;
                        quoteitemreclst.add(quoteitem) ;
                    }
                }  
            }
            if(quoteitemreclst.size() >0 ){
                insert quoteitemreclst;
            }
        }

        list<buildertek__Proposal_Images__c> quoteImageList = [SELECT Id, Name,buildertek__Base_URL__c, buildertek__Contact__c,buildertek__Contract__c, buildertek__Description__c,buildertek__Image__c, buildertek__Proposal__c
                                                                FROM buildertek__Proposal_Images__c WHERE buildertek__Proposal__c IN: quoteIdsList]; 

        if(quoteImageList !=null){
            list<buildertek__Proposal_Images__c> contractImagereclst = new list<buildertek__Proposal_Images__c>();
            for(buildertek__Proposal_Images__c quoteimagerecs : quoteImageList){
                for(buildertek__Quote__c quoteid : quoteToUpdateList){
                    if(quoteid.buildertek__OppToQuoteId__c == quoteimagerecs.buildertek__Proposal__c){
                        buildertek__Proposal_Images__c quoteimage =  new buildertek__Proposal_Images__c();
                        quoteimage.buildertek__Base_URL__c =quoteimagerecs.buildertek__Base_URL__c;
                        quoteimage.buildertek__Contact__c = quoteimagerecs.buildertek__Contact__c;
                        quoteimage.buildertek__Contract__c = quoteimagerecs.buildertek__Contract__c;
                        quoteimage.buildertek__Description__c =  quoteimagerecs.buildertek__Description__c;
                        quoteimage.buildertek__Proposal__c = quoteid.Id;
                        quoteimage.buildertek__Image__c =  quoteimagerecs.buildertek__Image__c;
                        contractImagereclst.add(quoteimage) ;
                    }
                }  
            }
            if(contractImagereclst.size() >0 ){
                insert contractImagereclst;
            }
        }
        transient set<Id> contentDocIDList = new set<Id>();
        Map<Id, Id> contentdocMap = new Map<Id, Id>();
        if(quoteIdsList.size() > 0){
            list<ContentDocumentLink> ContentDocumentLinklist = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility 
                                                                    FROM ContentDocumentLink WHERE LinkedEntityId IN: quoteIdsList];

            for(ContentDocumentLink conDocLink : ContentDocumentLinklist){
                contentDocIDList.add(conDocLink.ContentDocumentId);
                contentdocMap.put(conDocLink.ContentDocumentId,conDocLink.LinkedEntityId);                                                   
            }

            transient List<ContentVersion> VersionList = new List<ContentVersion>();
            transient List<ContentVersion> attachlist = new List<ContentVersion>();
            attachlist = [SELECT Title, Description, FileType, Owner.Name, VersionNumber, CreatedDate, PathOnClient, FileExtension, VersionData, ContentDocumentId 
                            FROM ContentVersion WHERE ContentDocumentId in :contentDocIDList AND IsLatest = true];
            List<ContentVersion> contentVersionToInsert = new List<ContentVersion>();
            SET<Id> quoteIds = new SET<Id>();
            for(buildertek__Quote__c quoteRec : quoteToUpdateList) {
                quoteIds.add(quoteRec.Id);
                for(ContentVersion objIndividualAttachment : attachlist) {
                    if(contentdocMap.containsKey(objIndividualAttachment.ContentDocumentId)){
                        if(quoteRec.buildertek__OppToQuoteId__c == contentdocMap.get(objIndividualAttachment.ContentDocumentId) ){
                            ContentVersion con= new contentversion();
                            con.ContentLocation = 'S'; 
                            con.PathOnClient = objIndividualAttachment.PathOnClient; 
                            con.VersionData = objIndividualAttachment.VersionData; 
                            con.Title = objIndividualAttachment.Title;
                            contentVersionToInsert.add(con);
                        }
                    }
                }
            }  

            if(contentVersionToInsert.size() > 0){
                insert contentVersionToInsert;
                
                SET<Id> contentDocumentIds = new SET<Id>();
                List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: contentVersionToInsert];
                for(ContentVersion cv : contentVersionList){
                    contentDocumentIds.add(cv.ContentDocumentId);
                }
                List<ContentDocument> conDocList = [SELECT Id,Title FROM ContentDocument WHERE Id IN:contentDocumentIds];
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                for(String quoteId : quoteIds){
                    for(ContentDocument cd : conDocList){
                        ContentDocumentLink CDL = new ContentDocumentLink();
                        CDL .ContentDocumentId = cd.Id;
                        CDL .LinkedEntityId = quoteId; 
                        CDL .ShareType = 'I'; 
                        CDL .Visibility = 'AllUsers';
                        cdlList.add(CDL);
                    }          
                }
                if(cdlList.size() > 0){
                    insert cdlList;
                }
            }
        }
        
        List<Id> createdContractCustomerToAccess = new List<Id>();
        for(buildertek__Quote__c newquote : quoteToUpdateList ){
            createdContractCustomerToAccess.add(newquote.Id);
        } 
        List<buildertek__Contract__c> newContracts = createContractsFromQuote(createdContractCustomerToAccess, adminInterfaceNodeConfigurations);
        List<buildertek__Budget__c> newBudgets = createBudgetFromQuote(createdContractCustomerToAccess);
        
        return project.Id;
    }   

    public static List<buildertek__Contract__c> createContractsFromQuote(List<Id> listQuoteIds, List<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodeConfigurations) {
        List<Id> quoteIdsList = new List<Id>(); 
        Integer intIndex = 0;
        Map<Integer, buildertek__Contract__c> mapQuoteIndex = new Map<Integer, buildertek__Contract__c>();
        Map<Integer, List<buildertek__Contract_Item__c>> mapQuoteLineIndex = new Map<Integer, List<buildertek__Contract_Item__c>>();
        List<Site> sites = [SELECT Id, Name, GuestUserId FROM Site where Status='Active' AND SiteType='Visualforce'];

        buildertek__Quote_Line_Group__c contGroup = new buildertek__Quote_Line_Group__c();

        if(!Test.isRunningTest()){
            buildertek__Quote_Line_Group__c contractGroup;
            contractGroup = [SELECT Id FROM buildertek__Quote_Line_Group__c WHERE Name ='No Grouping'];
            if(contractGroup != null){
                contGroup = contractGroup;
            }else{
                contGroup.Name = 'No Grouping';
                insert contGroup;
            }
        }
        List<buildertek__Quote__c> allQuote = getQuotesWithLines(listQuoteIds);
        string pictur = '';
        if(adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c != null){
            pictur = adminInterfaceNodeConfigurations[0].buildertek__Org_Base_URL__c;
        }

        for(buildertek__Quote__c currQuote : allQuote) {
            mapQuoteIndex.put(
                intIndex,
                new buildertek__Contract__c(
                    Name = currQuote.Name,
                    buildertek__BT_Quote__c = currQuote.Id,
                    buildertek__Pictures__c = pictur+'/lightning/r/buildertek__Quote__c/'+currQuote.buildertek__OppToQuoteId__c+'/related/AttachedContentDocuments/view',
                    buildertek__Contract_Start_Date__c = currQuote.buildertek__Start_Date__c,
                    buildertek__Email_Body__c = currQuote.buildertek__Email_Body__c,
                    buildertek__Email_Subject__c = currQuote.buildertek__Email_Subject__c,
                    buildertek__Expiration_Date__c = currQuote.buildertek__Expires_On__c,
                    buildertek__Primary_Contact__c = currQuote.buildertek__Primary_Contact__c,
                    buildertek__Project__c = currQuote.buildertek__Project__c,
                    buildertek__Start_Date__c = currQuote.buildertek__Start_Date__c,
                    buildertek__Discount__c = currQuote.buildertek__Discount__c,
                    buildertek__Tax_Rate__c = currQuote.buildertek__Tax__c,
                    buildertek__Shipping_Handling__c = currQuote.buildertek__Shipping_and_Handling__c,
                    buildertek__Notes__c = currQuote.buildertek__Notes__c,
                    buildertek__Status__c = 'Approved',
                    buildertek__Contract_File__c=currQuote.buildertek__Quote_File__c
                )
            );
            mapQuoteLineIndex.put(intIndex, new List<buildertek__Contract_Item__c>());
            quoteIdsList.add(currQuote.Id);
        }

        List<buildertek__Quote_Item__c> quoteItemList = getQuoteLines(quoteIdsList);
        for(buildertek__Quote_Item__c currQuoteItem : quoteItemList) {
            mapQuoteLineIndex.get(intIndex).add(new buildertek__Contract_Item__c(
                Name = currQuoteItem.Name,
                buildertek__Cost_Code__c = currQuoteItem.buildertek__Cost_Code__c,
                buildertek__Description__c = currQuoteItem.buildertek__Description__c,
                buildertek__Product__c = currQuoteItem.buildertek__Product__c,
                buildertek__Quantity__c = currQuoteItem.buildertek__Quantity__c,
                buildertek__Unit_Price__c = currQuoteItem.buildertek__Net_Unit__c,
                buildertek__Contract_Item_Group__c = currQuoteItem.buildertek__Grouping__c,
                buildertek__Notes__c = currQuoteItem.buildertek__Notes__c
            ));
        }

        if(!mapQuoteIndex.isEmpty()) {
            List<buildertek__Contract_Item__c> listContractLines = new List<buildertek__Contract_Item__c>();
            insert mapQuoteIndex.values();
            
            for(Integer currIndex : mapQuoteIndex.keySet()) {
                for(buildertek__Contract_Item__c currBudgetItem : mapQuoteLineIndex.get(currIndex)) {
                    currBudgetItem.buildertek__Contract__c = mapQuoteIndex.get(currIndex).Id;
                    listContractLines.add(currBudgetItem);
                }
            }
            
            if(!listContractLines.isEmpty()) {
                insert listContractLines;
            }
        }

        list<buildertek__Proposal_Images__c> quoteImageList = [SELECT Id, Name,buildertek__Base_URL__c, buildertek__Contact__c,buildertek__Contract__c, buildertek__Description__c,buildertek__Image__c, buildertek__Proposal__c
                                                                FROM buildertek__Proposal_Images__c WHERE buildertek__Proposal__c IN: listQuoteIds]; 

        if(quoteImageList !=null){
            list<buildertek__Proposal_Images__c> contractImagereclst = new list<buildertek__Proposal_Images__c>();
            for(buildertek__Proposal_Images__c quoteimagerecs : quoteImageList){
                for(buildertek__Contract__c contractRec : mapQuoteIndex.values()){
                    if(!mapQuoteIndex.isEmpty()) {
                        buildertek__Proposal_Images__c quoteimage =  new buildertek__Proposal_Images__c();
                        quoteimage.buildertek__Base_URL__c =quoteimagerecs.buildertek__Base_URL__c;
                        quoteimage.buildertek__Contact__c = quoteimagerecs.buildertek__Contact__c;
                        quoteimage.buildertek__Contract__c = contractRec.id;
                        quoteimage.buildertek__Description__c =  quoteimagerecs.buildertek__Description__c;
                        quoteimage.buildertek__Image__c =  quoteimagerecs.buildertek__Image__c ;
                        contractImagereclst.add(quoteimage) ;
                    }
                }
            }  
            if(contractImagereclst.size() >0 ){
                insert contractImagereclst;
            }
        }

        List<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodebudgetConfiguration = [SELECT Id,
                                                                                                         buildertek__Automatically_Create_Inv_from_ConSigning__c 
                                                                                                         FROM buildertek__Admin_Interface_Node_Configuration__c 
                                                                                                         WHERE Name=:'Create Contract on Quote Acceptance' LIMIT 1];
            if(adminInterfaceNodebudgetConfiguration.size()>0){
                if(adminInterfaceNodebudgetConfiguration[0].buildertek__Automatically_Create_Inv_from_ConSigning__c == true){
                    for(buildertek__Contract__c contractRec : mapQuoteIndex.values()){
                        if(!mapQuoteIndex.isEmpty()) {
                            CreateInvoiceMethod(contractRec.id);
                        }
                    }
                }
            }
        return mapQuoteIndex.values();
    }

    public static List<buildertek__Budget__c> createBudgetFromQuote(List<Id> QuoteId) {
        List<String> quoteIdsList = new List<String>();
        Integer intIndex = 0;
        Map<Integer, buildertek__Budget__c> mapBudgetIndex = new Map<Integer, buildertek__Budget__c>();
        Map<Integer, List<buildertek__Budget_Item__c>> mapBudgetLinesIndex = new Map<Integer, List<buildertek__Budget_Item__c>>();
        
        List<String> poIds=new List<String>();
        
        MAP<Integer,List<String>> idMap= new Map<Integer,List<String>>();
        Map<String,String> quoteToBudget = new Map<String,String>();
        Map<String,buildertek__Budget_Item__c> quoteToBudgetItem= new Map<String,buildertek__Budget_Item__c>();
        
        buildertek__Quote_Line_Group__c budGroup = new buildertek__Quote_Line_Group__c();
        
        buildertek__Quote_Line_Group__c budgetGroup;
        budgetGroup= [SELECT Id FROM buildertek__Quote_Line_Group__c WHERE Name ='No Grouping'];
        if(budgetGroup != null){
            budGroup = budgetGroup;    
        }else{
            budGroup.Name = 'No Grouping';
            insert budGroup;
        }    

        List<buildertek__Quote__c> allQuote = [SELECT Id, Name, buildertek__Description__c, buildertek__Quote_Amount__c, buildertek__Status__c, buildertek__Project__c, 
                                                buildertek__Auto_Number__c, buildertek__Primary__c, buildertek__Markup__c, buildertek__Shipping_and_Handling__c,
                                                buildertek__Profit_Margin__c, buildertek__Payment_Terms__c, buildertek__Discount__c, buildertek__Tax__c,
                                                buildertek__Expires_On__c, buildertek__Sales_Rep__c, buildertek__Primary_Contact__c, buildertek__Start_Date__c, 
                                                buildertek__Bill_To_Name__c, buildertek__Bill_To_Street__c, buildertek__Bill_To_City__c, buildertek__Bill_To_State__c, 
                                                buildertek__Bill_To_Country__c, buildertek__Ship_To_Name__c, buildertek__Ship_To_Street__c, buildertek__Ship_To_City__c, 
                                                buildertek__Ship_To_State__c, buildertek__Group_Line_Items__c, buildertek__Ship_To_Zip_Code__c, buildertek__Opportunity__c, 
                                                buildertek__Email_Body__c, buildertek__Email_Subject__c, buildertek__Ship_To_Country__c, buildertek__Bill_To_Zip_Code__c, 
                                                buildertek__SignatureBase64__c,buildertek__Notes__c,buildertek__Quote_File__c
                                                FROM buildertek__Quote__c WHERE Id IN : QuoteId];

        for(buildertek__Quote__c curQuote : allQuote) {
            mapBudgetIndex.put(
                intIndex,
                new buildertek__Budget__c(   
                    Name = curQuote.Name,
                    buildertek__Project__c = curQuote.buildertek__Project__c
                )
            );
            quoteIdsList.add(curQuote.Id);
            mapBudgetLinesIndex.put(intIndex, new List<buildertek__Budget_Item__c>());
        }
        
        List<buildertek__Quote_Item__c> quoteItemList = getQuoteLines(quoteIdsList);

        List<buildertek__Budget_Line_Group__c> groupList = [SELECT Id, Name FROM buildertek__Budget_Line_Group__c];

        Map<String, Id> groupMap = new Map<String, Id>();

        for (buildertek__Budget_Line_Group__c groupData : groupList) {
            groupMap.put(groupData.Name, groupData.Id);
        }

        List<buildertek__Budget_Line_Group__c> newGroupList = new List<buildertek__Budget_Line_Group__c>();
        String groupId = budGroup.Id;
        for (buildertek__Quote_Item__c quoteLine : quoteItemList) {
            if (quoteLine.buildertek__Grouping__c != null && quoteLine.buildertek__Grouping__c != groupId) {
                if (!groupMap.containsKey(quoteLine.buildertek__Grouping__r.Name)) {
                    buildertek__Budget_Line_Group__c newGroup = new buildertek__Budget_Line_Group__c();
                    newGroup.Name = quoteLine.buildertek__Grouping__r.Name;
                    newGroupList.add(newGroup);
                }
                groupId = quoteLine.buildertek__Grouping__c;
            }
        }

        if (newGroupList.size() > 0) {
            insert newGroupList;
            for (buildertek__Budget_Line_Group__c groupData : newGroupList) {
                groupMap.put(groupData.Name, groupData.Id);
            }
        }

        idMap.put(intIndex,new List<String>());
        for(buildertek__Quote_Item__c currQuoteLine : quoteItemList) {
            mapBudgetLinesIndex.get(intIndex).add(new buildertek__Budget_Item__c(
                Name = currQuoteLine.Name,
                buildertek__Product__c = currQuoteLine.buildertek__Product__c,
                buildertek__Item_Name__c = currQuoteLine.buildertek__Item_Name__c,
                buildertek__Cost_Code__c = currQuoteLine.buildertek__Cost_Code__c,
                buildertek__Quantity__c = currQuoteLine.buildertek__Quantity__c,
                buildertek__Unit_Price__c = currQuoteLine.buildertek__Unit_Cost__c,
                buildertek__Sales_Price__c = currQuoteLine.buildertek__Net_Total_Price__c, 
                buildertek__Budget_Line_Group__c = currQuoteLine.buildertek__Grouping__c,
                buildertek__Group__c = groupMap.get(currQuoteLine.buildertek__Grouping__r.Name)
            ));
            if(currQuoteLine.buildertek__Purchase_Order__c!=null){
                poIds.add(currQuoteLine.buildertek__Purchase_Order__c);    
            }
            idMap.get(intIndex).add(currQuoteLine.buildertek__Purchase_Order__c);
        }
         
        intIndex++;
        
        if(!mapBudgetIndex.isEmpty()) {
            List<buildertek__Budget_Item__c> listBudgetItems = new List<buildertek__Budget_Item__c>();
            insert mapBudgetIndex.values();

            for(Integer currIndex : mapBudgetIndex.keySet()) {
                for(buildertek__Budget_Item__c currBudgetItem : mapBudgetLinesIndex.get(currIndex)) {
                    currBudgetItem.buildertek__Budget__c = mapBudgetIndex.get(currIndex).Id;
                    listBudgetItems.add(currBudgetItem);
                }
            }
            
            if(!listBudgetItems.isEmpty()) {
                insert listBudgetItems;
                Map<Integer, List<buildertek__Budget_Item__c>> mapBudgetLines = new Map<Integer, List<buildertek__Budget_Item__c>>();
                Integer i=0;
                for(Integer currIndex : mapBudgetIndex.keySet()) {
                    
                    for(buildertek__Budget_Item__c currBudgetItem : mapBudgetLinesIndex.get(currIndex)) { 
                        if(!mapBudgetLines.containsKey(currIndex)){
                            mapBudgetLines.put(currIndex, new List<buildertek__Budget_Item__c>());
                            mapBudgetLines.get(currIndex).add(listBudgetItems[i]); 
                            i++;
                        }else{
                            mapBudgetLines.get(currIndex).add(listBudgetItems[i]);
                            i++;
                        }
                    }
                }
                
                List<buildertek__Purchase_Order__c> purchaseOrderLst = [SELECT Id,(SELECT Id,buildertek__Unit_Price__c FROM buildertek__Purchase_Order_Items__r) FROM buildertek__Purchase_Order__c WHERE Id IN :poIds];
                Map<id,buildertek__Purchase_Order__c> purchaseOrderLstMap = new Map<id,buildertek__Purchase_Order__c>();
                for(buildertek__Purchase_Order__c potemp: purchaseOrderLst){
                    purchaseOrderLstMap.put(potemp.id,potemp);
                }
                List<buildertek__PO_Item_To_Budget_Item_Link__c>  budgetItemLinkRecs= new List<buildertek__PO_Item_To_Budget_Item_Link__c>();

                for(Integer currIndex : idMap.keySet()) {
                    Integer Index=0;
                    for(String temp : idMap.get(currIndex)){
                        if(temp!=null){
                            buildertek__Purchase_Order__c purchaseOrderRec = purchaseOrderLstMap.get(temp);
                            buildertek__Budget_Item__c budgetItemRec = mapBudgetLines.get(currIndex)[Index];
                            for(buildertek__Purchase_Order_Item__c currPOLine : purchaseOrderRec.buildertek__Purchase_Order_Items__r) {
                                buildertek__PO_Item_To_Budget_Item_Link__c budgetItemLinkRec = new buildertek__PO_Item_To_Budget_Item_Link__c();
                                budgetItemLinkRec.buildertek__Approved_PO__c=currPOLine.buildertek__Unit_Price__c;
                                budgetItemLinkRec.buildertek__PO_Item__c=currPOLine.id;
                                budgetItemLinkRec.buildertek__Budget_Item__c=budgetItemRec.id;
                                budgetItemLinkRecs.add(budgetItemLinkRec);
                            }
                        }
                        index++;
                    }
                }
                if(budgetItemLinkRecs.size()>0){ 
                    insert budgetItemLinkRecs;
                }
                  
            }
        }
        
        return mapBudgetIndex.values();
    }

    public Static ResponseBase CreateInvoiceMethod(string ContractId){
        ResponseBase response = new ResponseBase();
        buildertek__Contract__c contract= [SELECT Id, Name, buildertek__Project__c, buildertek__Change_Order_Amount__c, buildertek__Change_Order__c, buildertek__Change_Order__r.Name,
                                            buildertek__Change_Order__r.buildertek__Tax_Rate__c, buildertek__Status__c, buildertek__Vendor__c, RecordTypeId, recordType.Name, 
                                                (SELECT Id, Name, buildertek__Cost_Code__c, buildertek__Description__c, buildertek__Item_Name__c, buildertek__Product__c, 
                                                buildertek__Quantity__c, buildertek__Unit_Price__c, buildertek__Notes__c FROM buildertek__Contract_Items__r), 
                                                (SELECT Id, Name FROM Buildertek__Purchase_Orders__r ORDER BY CreatedDate)
                                            FROM buildertek__Contract__c WHERE Id =: ContractId];
                                            
        string prid = '';
        list<buildertek__Purchase_Order__c> purchaselist = contract.Buildertek__Purchase_Orders__r;
        for(buildertek__Purchase_Order__c purchaseRec : purchaselist){
            prid =   purchaseRec.id;
        }
                            
        if(contract.recordType.Name == 'Prime Contract'){
            buildertek__Billings__c AR = new buildertek__Billings__c();
            AR.buildertek__Project__c = contract.buildertek__Project__c;
            AR.buildertek__Status__c = 'Open';
            AR.buildertek__Customer_Account__c = contract.buildertek__Vendor__c;
            AR.buildertek__Change_order__c = contract.buildertek__Change_Order__c;
            AR.buildertek__Tax_Rate__c = contract.buildertek__Change_Order__r.buildertek__Tax_Rate__c;
            AR.buildertek__Approved_CO__c = contract.buildertek__Change_Order_Amount__c;
            Ar.Name = contract.Name;
            Ar.buildertek__Contract__c = contract.Id;
            insert AR;
            
            List<buildertek__Billable_Lines__c> arLines = new List<buildertek__Billable_Lines__c>();

            for(buildertek__Contract_Item__c coItem : contract.buildertek__Contract_Items__r){
                buildertek__Billable_Lines__c arItem = new buildertek__Billable_Lines__c();
                arItem.buildertek__Billings__c = AR.Id;
                arItem.buildertek__Line_Title__c = coItem.buildertek__Item_Name__c;
                arItem.buildertek__Cost_Code__c = coItem.buildertek__Cost_Code__c;
                arItem.buildertek__Description__c = coItem.Name;
                arItem.buildertek__Product__c = coItem.buildertek__Product__c;
                arItem.buildertek__Unit_Price__c = coItem.buildertek__Unit_Price__c;
                arItem.buildertek__Quantity__c = coItem.buildertek__Quantity__c;
                arItem.buildertek__Notes__c = coItem.buildertek__Notes__c;
                arItem.buildertek__Contract_Line__c = coItem.Id;
                arLines.add(arItem);
            }
            insert arLines;
            
            response.strMessage = 'Success';
            response.strRecordId = AR.Id;

        } else if(contract.recordType.Name == 'Sub Contract'){
            buildertek__Account_Payable__c AP = new buildertek__Account_Payable__c();
            if(prid != null && prid != ''){
                AP.buildertek__Project__c = contract.buildertek__Project__c;
                AP.buildertek__Status__c = 'Open';
                AP.buildertek__Vendor__c = contract.buildertek__Vendor__c;
                AP.buildertek__Tax__c = contract.buildertek__Change_Order__r.buildertek__Tax_Rate__c;
                AP.buildertek__Description__c = contract.Name;
                AP.buildertek__Contract__c = contract.Id;
                AP.buildertek__Purchase_Order__c = prid;
                insert AP;

                List<buildertek__Account_Payable_Item__c> apLines = new List<buildertek__Account_Payable_Item__c>();

                for(buildertek__Contract_Item__c coItem : contract.buildertek__Contract_Items__r){
                    buildertek__Account_Payable_Item__c apItem = new buildertek__Account_Payable_Item__c();
                    apItem.buildertek__Account_Payable__c = AP.Id;
                    apItem.buildertek__Item_Title__c = coItem.buildertek__Item_Name__c;
                    apItem.buildertek__Cost_Code__c = coItem.buildertek__Cost_Code__c;
                    apItem.buildertek__Description__c = coItem.Name;
                    apItem.buildertek__Product__c = coItem.buildertek__Product__c;
                    apItem.buildertek__Unit_Price__c = coItem.buildertek__Unit_Price__c;
                    apItem.buildertek__Quantity__c = coItem.buildertek__Quantity__c;
                    apItem.buildertek__Contract_Line__c = coItem.Id;
                    apLines.add(apItem);
                }
                insert apLines;
                response.strMessage = 'Success';
                response.strRecordId = AP.Id;
            }else{
                response.strMessage = 'No PR';
                response.strRecordId = '';
            }
        }
        return response;
    }
    
    public virtual class ResponseBase {
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String strMessage;
        @AuraEnabled public String strRecordId;
    }

    public static List<buildertek__Quote__c> getQuotesWithLines(List<Id> listQuoteIds) {
        Map<String, List<buildertek__Quote_Item__c>> quoteIdQuoteLinesMap = new Map<String, List<buildertek__Quote_Item__c>>();
        List<buildertek__Quote__c> quotelist = [SELECT Id, Name, buildertek__Description__c, buildertek__Quote_Amount__c, buildertek__Status__c, buildertek__Project__c, 
                                                buildertek__Auto_Number__c, buildertek__Primary__c, buildertek__Markup__c, buildertek__Shipping_and_Handling__c,buildertek__OppToQuoteId__c,
                                                buildertek__Profit_Margin__c, buildertek__Payment_Terms__c, buildertek__Discount__c, buildertek__Tax__c,
                                                buildertek__Expires_On__c, buildertek__Sales_Rep__c, buildertek__Primary_Contact__c, buildertek__Start_Date__c, 
                                                buildertek__Bill_To_Name__c, buildertek__Bill_To_Street__c, buildertek__Bill_To_City__c, buildertek__Bill_To_State__c, 
                                                buildertek__Bill_To_Country__c, buildertek__Ship_To_Name__c, buildertek__Ship_To_Street__c, buildertek__Ship_To_City__c, 
                                                buildertek__Ship_To_State__c, buildertek__Group_Line_Items__c, buildertek__Ship_To_Zip_Code__c, buildertek__Opportunity__c, 
                                                buildertek__Email_Body__c, buildertek__Email_Subject__c, buildertek__Ship_To_Country__c, buildertek__Bill_To_Zip_Code__c, 
                                                buildertek__SignatureBase64__c,buildertek__Notes__c,buildertek__Quote_File__c
                                                FROM buildertek__Quote__c WHERE Id IN : listQuoteIds];
                
        for(buildertek__Quote__c qut : quotelist){
            quoteIdQuoteLinesMap.put(qut.Id, qut.buildertek__Quote_Items__r);        
        }
        return quotelist;
    }

    public static List<buildertek__Quote_Item__c> getQuoteLines(List<Id> quoteIds){
        List<buildertek__Quote_Item__c> quoteItemList;
       
            quoteItemList = [SELECT Id, Name, buildertek__Item_Name__c,buildertek__Description__c, buildertek__Quantity__c, buildertek__Unit_Price__c, buildertek__Total_Cost__c, 
                                buildertek__Quote__c, buildertek__Cost_Code__c, buildertek__Auto_Number__c, buildertek__Product__c, buildertek__Grouping__c, buildertek__UOM__c, 
                                buildertek__Vendor__c, buildertek__Markup__c, buildertek__Unit_Cost__c, buildertek__List_Total__c, buildertek__Net_Unit__c, buildertek__Applied_Markup__c, 
                                buildertek__Net_Total__c, buildertek__MFG_Discount__c, buildertek__List_Unit_Price__c, buildertek__Pricing_Method__c, buildertek__Discount__c, 
                                buildertek__Profit_Margin__c, buildertek__Net_Total_Price__c, buildertek__Notes__c, buildertek__Status__c, buildertek__Purchase_Order__c, buildertek__Grouping__r.Name
                                FROM buildertek__Quote_Item__c WHERE buildertek__Quote__c IN: quoteIds  And buildertek__Status__c != 'Reject'];      
        
        return quoteItemList;
              
    }

}