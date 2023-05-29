/*
Copyright (c) 2017-2018, BuilderTek.
All rights reserved.

Developed By: Sagar
Date:  13-Jul-2018
*/
public without sharing class RFQResponseControllerDemo{
    public static String OBJECT_TYPE_ACCOUNT = Account.sObjectType+'';
    public static String OBJECT_TYPE_FILE = buildertek__File__c.sObjectType+'';
    public static String OBJECT_TYPE_FOLDER = buildertek__Folder__c.sObjectType+'';
    public static String OBJECT_TYPE_FILE_ACCESS_CONTROL = buildertek__File_Access_Control__c.sObjectType+'';
    public static String OBJECT_TYPE_PROJECT = buildertek__Project__c.sObjectType+'';

    public static String OBJECT_TYPE_RFQ = buildertek__RFQ__c.sObjectType+'';
    public static String OBJECT_TYPE_RFQ_ITEM = buildertek__RFQ_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_PO = buildertek__Purchase_Order__c.sObjectType+'';
    public static String OBJECT_TYPE_PO_ITEM = buildertek__Purchase_Order_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_BUDGET = buildertek__Budget__c.sObjectType+'';
    public static String OBJECT_TYPE_BUDGET_ITEM = buildertek__Budget_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_CO = buildertek__Change_Order__c.sObjectType+'';
    public static String OBJECT_TYPE_CO_ITEM = buildertek__Change_Order_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_RFQ_TO_VENDOR = buildertek__RFQ_To_Vendor__c.sObjectType+'';
    public static String OBJECT_TYPE_RFQ_TO_VENDOR_ITEM = buildertek__RFQ_Vendor_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_CONTRACT = buildertek__Contract__c.sObjectType+'';
    public static String OBJECT_TYPE_CONTRACT_ITEM = buildertek__Contract_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_QUOTE = buildertek__Quote__c.sObjectType+'';
    public static String OBJECT_TYPE_QUOTE_ITEM = buildertek__Quote_Item__c.sObjectType+'';
    public static String OBJECT_TYPE_PROJECT_TASK = buildertek__Project_Task__c.sObjectType+'';
    public static String OBJECT_TYPE_SCHEDULE = buildertek__Schedule__c.sObjectType+'';
    public static String OBJECT_TYPE_SECTION = buildertek__Section__c.sObjectType+'';
    public static String OBJECT_TYPE_QUESTION_GROUP = buildertek__Question_Group__c.sObjectType+'';
    public static String OBJECT_TYPE_QUESTION = buildertek__Question__c.sObjectType+'';

    public static Map<String, String> OBJECT_NAMESPACE_MAP =
        new Map<String, String>
        {
             'Account' => OBJECT_TYPE_ACCOUNT,
             'buildertek__File__c' => OBJECT_TYPE_FILE,
             'buildertek__Folder__c' => OBJECT_TYPE_FOLDER,
             'buildertek__File_Access_Control__c' => OBJECT_TYPE_FILE_ACCESS_CONTROL,
             'buildertek__Quote_Item__c' => OBJECT_TYPE_QUOTE_ITEM,
             'buildertek__Quote__c' => OBJECT_TYPE_QUOTE,
             'buildertek__Contract_Item__c' => OBJECT_TYPE_CONTRACT_ITEM,
             'buildertek__Contract__c' => OBJECT_TYPE_CONTRACT,
             'buildertek__RFQ_Vendor_Item__c' => OBJECT_TYPE_RFQ_TO_VENDOR_ITEM,
             'buildertek__RFQ_To_Vendor__c' => OBJECT_TYPE_RFQ_TO_VENDOR,
             'buildertek__Change_Order_Item__c' => OBJECT_TYPE_CO_ITEM,
             'buildertek__Change_Order__c' => OBJECT_TYPE_CO,
             'buildertek__Budget_Item__c' => OBJECT_TYPE_BUDGET_ITEM,
             'buildertek__Budget__c' => OBJECT_TYPE_BUDGET,
             'buildertek__Purchase_Order_Item__c' => OBJECT_TYPE_PO_ITEM,
             'buildertek__RFQ_Item__c' => OBJECT_TYPE_RFQ_ITEM,
             'buildertek__Project__c' => OBJECT_TYPE_PROJECT,
             'buildertek__Project_Task__c' => OBJECT_TYPE_PROJECT_Task,
             'buildertek__RFQ__c' => OBJECT_TYPE_RFQ
        };
    public Id gcId{get;set;}
    public String fldid{get;set;}
    public String callfunc{get;set;}
    public String fname{get;set;}
    public transient Blob fbody{get;set;}
    public String filerecdescription{get;set;}
    public String calltoclose {get;set;}
    public boolean showCreateRFI {get;set;}
    public string companycurrency {get;set;}
    public boolean multicurrency {get;set;}
    public Attachment attachRec {
    get {
    if (attachRec == null)
    attachRec = new Attachment();
    return attachRec;
    }
    set;
    }

    public boolean displayPopup {get;set;} 
    public void closePopup() 
    {
        displayPopup = false; 
    } 
    public void showPopup() 
    {
        displayPopup = true; 
    } 


public Boolean displayPopup1 {get;set;}

    public string rfqVendorId{ get; set; }

    public string rfqId{ get; set; }

    public string rfiId{ get; set; }

    public string projectId{ get; set; }

    public Boolean isErrorMessage{ get; set; }
    public Boolean rfisaved{ get; set; }

    public String errorMessage{ get; set; }

    public Boolean isReload{ get; set; }

    public buildertek__RFQ_To_Vendor__c rfqToVendor{ get; set; }
    public buildertek__RFI__c newrfi{ get; set; }
    public buildertek__RFQ__c rfqrec1{ get; set; }

    public Map<Integer, Id> rfqToVendorItemMap{ get; set; }

    public String uploadFileURL{ get; set; }

    public string selectedFolder{ get; set; }

    public string parentFolder{ get; set; }

    public string mainObjectFieldAPI{ get; set; }

    public string mainObjectId{ get; set; }

    public string otherObjectFieldAPI{ get; set; }

    public string otherObjectId{ get; set; }

    public buildertek__Project__c project{ get; set; }

    public List<buildertek__File__c> files{ get; set; }

    public List<buildertek__File__c> fileList{ get; set; }

    public List<FileWrapper> fileWrapperClass{ get; set; }

    public List<WrapperVerdorLineList> wrapList{ get; set; }

    public Integer rowToRemove{ get; set; }

    public string selectedBucket{ get; set; }

    public string filename{ get; set; }

    public string filekey{ get; set; }

    public string s3AccessKey{ get; set; }

    public string policy{ get; set; }

    public string signedPolicy{ get; set; }

    public string redirectUrl{ get; set; }

    public string latestFileName { get; set; }
    transient String fileContents { get; set; }
    public string fileType { get; set; }
    public Integer fileSize { get; set; }
    public string rfqcontact {get;set;}

    public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
    }



    public RFQResponseControllerDemo(){
        displayPopUp = false;
        isErrorMessage = false;
        rfisaved = false;
        showCreateRFI = false;
        errorMessage = '';
        wrapList = new List<WrapperVerdorLineList>();
        newrfi = new buildertek__RFI__c();
        companycurrency = UserInfo.getDefaultCurrency();
        multicurrency = UserInfo.isMultiCurrencyOrganization();
        rfqToVendorItemMap = new Map<Integer, Id>();
        rfqVendorId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
        rfqToVendor = new buildertek__RFQ_To_Vendor__c();
        rfqrec1 = new buildertek__RFQ__c();
        files = new List<buildertek__File__c>();
        try{
            String query = 'Select buildertek__RFQ__r.buildertek__Due_Date__c,buildertek__RFQ__r.Name,buildertek__RFQ__r.buildertek__RFQ_Details__c,buildertek__RFQ__r.buildertek__Auto_Number__c,buildertek__RFQ__r.buildertek__Project__c,buildertek__RFQ__r.buildertek__Project__r.Name,' + getQueryStringForObjectWithAllFields('buildertek__RFQ_To_Vendor__c')+',(Select id,Name,buildertek__Item_Name__c,buildertek__Vendor_Note__c,buildertek__Estimated_Work_Days__c,buildertek__Quantity__c,buildertek__Unit_Price__c,buildertek__Total_Price__c,buildertek__Description__c,buildertek__Budget_Line_Amount__c, buildertek__RFQ_Item__c from buildertek__Vendor_Items__r),(Select Id, Name, buildertek__File__r.Name, buildertek__File__r.buildertek__File_Presigned_URL__c,buildertek__File__r.buildertek__Description__c,buildertek__File__r.buildertek__Download_Link__c,buildertek__File__r.buildertek__Download_Link1__c from buildertek__RFQ_To_Vendor_Document_Links__r), (Select Id, Name, buildertek__File_Presigned_URL__c,buildertek__Description__c from buildertek__Files__r) From buildertek__RFQ_To_Vendor__c where ID =:rfqVendorId order by Name';
                rfqToVendor = (buildertek__RFQ_To_Vendor__c)Database.query(query)[0];
                System.debug('rfqToVendor new '+rfqToVendor);
                rfqId = rfqToVendor.buildertek__RFQ__c;
                rfqcontact=rfqToVendor.buildertek__Contact__c;
                projectId =rfqToVendor.buildertek__RFQ__r.buildertek__Project__c;

                rfqrec1 = [ Select Id, Name, OwnerId, Owner.Name,buildertek__RFI_Owner__c  From buildertek__RFQ__c Where Id=:rfqId];
                newrfi.buildertek__RFI_Assigned_To__c = rfqrec1.OwnerId;

            Integer count = 0;
            for (buildertek__RFQ_Vendor_Item__c rfqToVendorItem : rfqToVendor.buildertek__Vendor_Items__r){
                rfqToVendorItemMap.put(count, rfqToVendorItem.Id);
                rfqToVendorItem.Id = null;
                count++;
            }
            List<buildertek__Folder__c> defaultBucketFolders;
            if (Schema.sObjectType.buildertek__Folder__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__Folder__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__Folder__c.fields.buildertek__Description__c.isAccessible()){
                defaultBucketFolders = [Select Id, Name
                                        From buildertek__Folder__c
                                        Where buildertek__Default__c = true AND buildertek__Active__c = true];
            }
            if (defaultBucketFolders != null && !defaultBucketFolders.isEmpty()){
                String folderId = defaultBucketFolders[0].Id;
                String selectedBucketId = defaultBucketFolders[0].Id;
                selectedBucket = defaultBucketFolders[0].Name;
                parentFolder = defaultBucketFolders[0].Id;
                selectedFolder = defaultBucketFolders[0].Id;
                mainObjectFieldAPI = 'buildertek__RFQ_To_Vendor__c';
                mainObjectId = rfqToVendor.Id;
                uploadFileURL = '/apex/buildertek__BT_UploadFile?sf=' + folderId + '&clr=false&sb=' + selectedBucketId;
                uploadFileURL += '&mofa=buildertek__RFQ_To_Vendor__c&moi=' + rfqToVendor.Id;
                uploadFileURL += '&retURL=/apex/buildertek__rfqresponse?id=' + rfqVendorId;
            }
            files = rfqToVendor.buildertek__Files__r;
            fileWrapperClass = new List<FileWrapper>();
            List<ContentDistribution> conVersion = [Select Id, DistributionPublicUrl, ContentVersion.Title, ContentVersion.FirstPublishLocationId,RelatedRecordId
                                                    FROM ContentDistribution
                                                    WHERE RelatedRecordId = :rfqId];
            for (ContentDistribution rec : conVersion){
                FileWrapper wrapperClass = new FileWrapper();
                wrapperClass.imgUrl = rec.DistributionPublicUrl;
                wrapperClass.imgTitle = rec.ContentVersion.Title;
                fileWrapperClass.add(wrapperClass);
            }


            buildertek__RFI_Settings__c rfiSettings = null;
            List<buildertek__RFI_Settings__c> rfiSettingsList = [Select Id,Name,
                                                                 buildertek__Using_Communities__c,
                                                                 buildertek__Using_Email__c,
                                                                 buildertek__New_RFI_Notification_Template__c
                                                                 from buildertek__RFI_Settings__c
                                                                 WHERE Name ='RFI Settings'];
            system.debug('rfiSettingsList-------'+rfiSettingsList);
            if(rfiSettingsList.size() > 0){
                rfiSettings = rfiSettingsList[0];
               if(rfiSettings.buildertek__Using_Email__c!=null){
                    showCreateRFI = rfiSettings.buildertek__Using_Email__c;
                }
            }


        } catch (Exception e) {
            System.debug('Error Message => '+e.getMessage());
            System.debug('Error Line no => '+e.getLineNumber());
            String data = 'Error Message => '+e.getMessage() + 'Error Line no => '+e.getLineNumber();
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            String[] sendingTo = new String[]{'krunal.l@mvclouds.com'};
            semail.setToAddresses(sendingTo);
            semail.setSubject('RFQResponseController Fail');
            semail.setPlainTextBody('RFQResponseController method fail in RFQResponseController class || '+data);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }
    }


    public void submintQuote(){
        try {


        buildertek__RFQ__c rfqrerec;
        System.debug('rfqrerec ==> '+rfqrerec);
            rfqrerec = [SELECT Id, Name, buildertek__Due_Date__c
                                        FROM buildertek__RFQ__c
                                        WHERE Id = :rfqToVendor.buildertek__RFQ__c];
            if(rfqrerec.buildertek__Due_Date__c < system.today()){
                isErrorMessage = true;
                errorMessage = 'You can not submit this RFQ , because the Due Date of this RFQ is expired. Please Contact System Administrate.';
                isReload = false;
            }else{
        if (rfqToVendor.buildertek__Status__c != 'Quote Submitted'){
                system.debug('***'+rfqToVendor.buildertek__Status__c);
                system.debug('***'+rfqToVendor.buildertek__Status__c);
                Integer numberOfDays = 0;
                Integer countEmptyFields = 0;
                Date acceptedDate;
                Date submittedDate;
                if (rfqToVendor.buildertek__Accepted_Date__c != null){
                    acceptedDate = rfqToVendor.buildertek__Accepted_Date__c.Date();
                }
                if (rfqToVendor.buildertek__Submitted_Date__c != null){
                    submittedDate = rfqToVendor.buildertek__Submitted_Date__c.Date();
                }
                if (acceptedDate != null && submittedDate != null){
                    numberOfDays = submittedDate.daysBetween(acceptedDate);
                }
                rfqToVendor.buildertek__Days_Outstanding__c = numberOfDays;

                for (Integer i = 0; i < rfqToVendor.buildertek__Vendor_Items__r.size(); i++){

                    buildertek__RFQ_Vendor_Item__c vendorItem = rfqToVendor.buildertek__Vendor_Items__r[i];
                    System.debug('vendorItem ==> '+vendorItem);

                    if (rfqToVendor.buildertek__Vendor_Items__r[i].buildertek__Quantity__c == null || rfqToVendor.buildertek__Vendor_Items__r[i].buildertek__Unit_Price__c == null || rfqToVendor.buildertek__Vendor_Items__r[i].buildertek__Unit_Price__c <= 0 || rfqToVendor.buildertek__Vendor_Items__r[i].buildertek__Quantity__c <= 0){
                        countEmptyFields++;
                    }
                }
                system.debug('%%%%%%%%'+countEmptyFields);
                if (countEmptyFields == 0){


                    system.debug('%%%%%%%%');
                    countEmptyFields = 0;
                    List<buildertek__RFQ_Vendor_Item__c> RecordsToBeInserted = new List<buildertek__RFQ_Vendor_Item__c>();
                    if (wrapList != null && !wrapList.isEmpty()){
                        for (WrapperVerdorLineList eachRecord : wrapList){
                            if (eachRecord.record.buildertek__Quantity__c == null || eachRecord.record.buildertek__Unit_Price__c == null  ){
                                countEmptyFields++;
                            }
                            buildertek__RFQ_Vendor_Item__c lineRec = eachRecord.record;
                            lineRec.buildertek__Vendor__c = rfqVendorId;
                            RecordsToBeInserted.add(lineRec);
                        }
                        if (countEmptyFields == 0){
                            for (Integer i = 0; i < rfqToVendor.buildertek__Vendor_Items__r.size(); i++){
                                rfqToVendor.buildertek__Vendor_Items__r[i].Id = rfqToVendorItemMap.get(i);
                            }
                            rfqToVendor.buildertek__Submitted_Date__c = system.now();
                            rfqToVendor.buildertek__Status__c = 'Quote Submitted';
                            system.debug('%%%%%%%%'+rfqToVendor.buildertek__Status__c);
                            update rfqToVendor;
                            update rfqToVendor.buildertek__Vendor_Items__r;
                                insert RecordsToBeInserted;

                            refreshFiles();
                            wrapList = new List<WrapperVerdorLineList>();
                            if (rfqToVendor.buildertek__RFQ__c != null){
                                List<buildertek__RFQ__c> rfqreclst;
                                if (Schema.sObjectType.buildertek__RFQ__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__RFQ__c.fields.buildertek__RFQ_s_Replied_To__c.isAccessible()){
                                    rfqreclst = [SELECT Id, Name, buildertek__RFQ_s_Replied_To__c
                                                FROM buildertek__RFQ__c
                                                WHERE Id = :rfqToVendor.buildertek__RFQ__c];
                                    system.debug('rfqreclst'+rfqreclst);
                                }
                                if (rfqreclst.size() > 0){
                                    if (rfqreclst[0].buildertek__RFQ_s_Replied_To__c != null){
                                        rfqreclst[0].buildertek__RFQ_s_Replied_To__c += 1;
                                    } else{
                                        rfqreclst[0].buildertek__RFQ_s_Replied_To__c = 1;
                                    }
                                    //if (Schema.sObjectType.buildertek__RFQ__c.fields.buildertek__RFQ_s_Replied_To__c.isUpdateable()){
                                    system.debug('***********'+rfqreclst);
                                    update rfqreclst;
                                    isErrorMessage = false;
                                // isReload = true;
                                    //}
                                }
                            }
                        }
                        else{
                            isErrorMessage = true;
                            errorMessage = 'Please add required fields.';
                            isReload = false;
                        }
                    } else{
                        for (Integer i = 0; i < rfqToVendor.buildertek__Vendor_Items__r.size(); i++){
                                rfqToVendor.buildertek__Vendor_Items__r[i].Id = rfqToVendorItemMap.get(i);
                            }
                        rfqToVendor.buildertek__Submitted_Date__c = system.now();
                        rfqToVendor.buildertek__Status__c = 'Quote Submitted';
                        system.debug('***********rfqToVendor'+rfqToVendor);
                        update rfqToVendor;
                        update rfqToVendor.buildertek__Vendor_Items__r;
                        if (rfqToVendor.buildertek__RFQ__c != null){
                            List<buildertek__RFQ__c> rfqreclst;
                            rfqreclst = [SELECT Id, Name, buildertek__RFQ_s_Replied_To__c
                                        FROM buildertek__RFQ__c
                                        WHERE Id = :rfqToVendor.buildertek__RFQ__c];
                            if (rfqreclst.size() > 0){
                                if (rfqreclst[0].buildertek__RFQ_s_Replied_To__c != null){
                                    rfqreclst[0].buildertek__RFQ_s_Replied_To__c += 1;
                                } else{
                                    rfqreclst[0].buildertek__RFQ_s_Replied_To__c = 1;
                                }
                                update rfqreclst;
                            }
                        }
                    }
                }
            else{
                    isErrorMessage = true;
                    errorMessage = 'Please add required fields.';
                    isReload = false;
                }
            } else{
                isErrorMessage = true;
                errorMessage = 'Quote already submitted!.';
                isReload = false;
            }
            }

        } catch (Exception e) {
            System.debug('Error Message => '+e.getMessage());
            System.debug('Error Line no => '+e.getLineNumber());
            String data = 'Error Message => '+e.getMessage() + 'Error Line no => '+e.getLineNumber();
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            String[] sendingTo = new String[]{'krunal.l@mvclouds.com'};
            semail.setToAddresses(sendingTo);
            semail.setSubject('RFQResponseController Fail');
            semail.setPlainTextBody('submintQuote method fail in RFQResponseController class || '+data);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }
    }

    public pagereference uploadDocument(){
        return new pagereference('/' + uploadFileURL);
    }


    public void refreshFiles(){
        try{
            String query = 'Select buildertek__RFQ__r.buildertek__Due_Date__c,buildertek__RFQ__r.Name,buildertek__RFQ__r.buildertek__RFQ_Details__c,buildertek__RFQ__r.buildertek__Auto_Number__c,buildertek__RFQ__r.buildertek__Project__r.Name'+getQueryStringForObjectWithAllFields('buildertek__RFQ_To_Vendor__c')+',(Select id,Name,buildertek__Item_Name__c,buildertek__Vendor_Note__c,buildertek__Estimated_Work_Days__c,buildertek__Quantity__c,buildertek__Unit_Price__c,buildertek__Total_Price__c,buildertek__Description__c,buildertek__Budget_Line_Amount__c, buildertek__RFQ_Item__c from buildertek__Vendor_Items__r),(Select Id, Name, buildertek__File__r.Name, buildertek__File__r.buildertek__File_Presigned_URL__c,buildertek__File__r.buildertek__Description__c,buildertek__File__r.buildertek__Download_Link__c,buildertek__File__r.buildertek__Download_Link1__c from buildertek__RFQ_To_Vendor_Document_Links__r), (Select Id, Name, buildertek__File_Presigned_URL__c,buildertek__Description__c from buildertek__Files__r) From buildertek__RFQ_To_Vendor__c where ID =:rfqVendorId order by Name';
            buildertek__RFQ_To_Vendor__c rfqToVendor1;
                rfqToVendor1 = (buildertek__RFQ_To_Vendor__c)Database.query(query)[0];
                System.debug('rfqToVendor new '+rfqToVendor);
            rfqToVendor = rfqToVendor1;
            files = rfqToVendor1.buildertek__Files__r;
            Integer count = 0;
            rfqToVendorItemMap = new Map<Integer, Id>();
            for (buildertek__RFQ_Vendor_Item__c rfqToVendorItem : rfqToVendor.buildertek__Vendor_Items__r){
                rfqToVendorItemMap.put(count, rfqToVendorItem.Id);
                rfqToVendorItem.Id = null;
                count++;
            }
        } catch (Exception ex){
            // throw exception
        }
    }

    public void removefile(){
        String fileid = ApexPages.CurrentPage().getParameters().Get('fileid');
        //if (File__c.sObjectType.getDescribe().isDeletable()){
            delete [Select Id
                    from buildertek__File__c
                    where Id = :fileid];
       // }
        refreshFiles();
    }

    public void removeRowFromList(){
        wrapList.remove(rowToRemove);
    }

    public void addNewRowToAccList(){
        WrapperVerdorLineList newRecord = new WrapperVerdorLineList();
        buildertek__RFQ_Vendor_Item__c newItemRecord = new buildertek__RFQ_Vendor_Item__c();
        newRecord.record = newItemRecord;
        newRecord.index = wrapList.size();
        wrapList.add(newRecord);
        system.debug('wrapList -----------> ' + wrapList);
    }

    public class WrapperVerdorLineList{
        public Integer index{ get; set; }

        public buildertek__RFQ_Vendor_Item__c record{ get; set; }
    }

    public void gets3Key(){

    }

    public static String getUpdatedPolicy1(Boolean isPublicOnAmazon, String selectedBucket){
        Datetime expire = system.now().addDays(1);
        String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T' + expire.formatGmt('HH:mm:ss')+'.' + expire.formatGMT('SSS')+'Z';
        return '{ "expiration": "' + formattedexpire + '","conditions": [' +
            '{"bucket": "' + selectedBucket + '" },' +
            '{ "acl": "' + (isPublicOnAmazon ? 'public-read' : 'private')+'" },' +                                                       //'{"success_action_status": "201" },'+
            '{"success_action_redirect":""},' +
            '["starts-with", "$key", ""] ]}';
    }

    public static String make_sig1(string canonicalBuffer){
        String macUrl;
        return macUrl;
    }

    public void insertFile(){
        String fileObjJSON = ApexPages.currentPage().getParameters().get('fileJSON');
        system.debug('---fileObjJSON---' + fileObjJSON);

        Id fileId = insertFiles((File)JSON.deserializeStrict(fileObjJSON, File.class), mainObjectFieldAPI, mainObjectId);
        system.debug('fileId ---------> ' + fileId);

    }

    public Id insertFiles(File fileObj, String mainObjectFieldAPI, String mainObjectId){
        List<buildertek__File_Access_Control__c> fileAccessControls = new List<buildertek__File_Access_Control__c>();


        // If file is replaced delete old file. skip trigger.
        if (fileObj.Replace){
            Set<String> allFileAccessControlFields = buildertek__File_Access_Control__c.sObjectType.getDescribe().fields.getMap().keySet();
            List<String> fields = new List<String>();
            fields.addAll(allFileAccessControlFields);

        }

        buildertek__File__c newFile = new buildertek__File__c();
        newFile.Name = fileObj.Name;
        newFile.buildertek__Folder__c = fileObj.Folder;
        newFile.buildertek__Bucket_Name__c = fileObj.BucketName;
        newFile.buildertek__Extension__c = fileObj.Extension;
        newFile.buildertek__Size__c = Decimal.valueOf(fileObj.size);
        newFile.buildertek__Content_Type__c = fileObj.ContentType;

        newFile.buildertek__Public_On_Amazon__c = fileObj.PublicOnAmazon;
        newFile.buildertek__Allow_to_Download_by_Presigned_URL__c = fileObj.AllowShareViaURL;
        newFile.buildertek__Track_Download_History__c = fileObj.TrackDownload;
        newFile.buildertek__Allow_to_Copy_Move__c = fileObj.AllowCopy;
        newFile.buildertek__Access_Type__c = fileObj.AccessType;
        newFile.buildertek__Parent_Object_API_Name__c = mainObjectFieldAPI;
        newFile.buildertek__Track_Download_History__c = true;

        // File needs to be linked to the passed salesforce record ID
        if (mainObjectFieldAPI != null && mainObjectFieldAPI != '' && mainObjectFieldAPI != 'null'){
            newFile.put(mainObjectFieldAPI, mainObjectId);
        }

        insert newFile;
        Id newFileId = newFile.Id;


        return newFileId;
    }

    public void insertFileInS3(){
        system.debug(latestFileName);
        fileContents = Apexpages.currentpage().getparameters().get('secondParam');
        system.debug(fileContents);
        fileContents = EncodingUtil.urlDecode(fileContents, 'UTF-8');
        Blob blobValue = EncodingUtil.base64Decode(fileContents);
        system.debug('blobValue --------> '+blobValue);
        String attachmentBody = EncodingUtil.base64Encode(blobValue);
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        List<Buildertek__Folder__c> folderList = [Select Id, Name From buildertek__Folder__c Where buildertek__Default__c = true AND buildertek__Active__c = true];
        //String filename = contentVer.Title;
        latestFileName = latestFileName.replaceAll('\\s', '');
        latestFileName = EncodingUtil.urlEncode(latestFileName, 'UTF-8');
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setEndpoint('callout:buildertek__AWS_S3/'+folderList[0].Name+'/'+latestFileName);
        //req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'base64');
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString);
        req.setHeader('ACL', 'public-read-write');
        req.setBodyAsBlob(blobValue);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('Response ------> '+res.getBody());
        system.debug('Response ------> '+res.getStatusCode());
        system.debug('Response ------> '+res.getStatus());
        if(res.getStatusCode() == 200){
            buildertek__File__c newFile = new buildertek__File__c();
            newFile.Name = EncodingUtil.urlDecode(latestFileName, 'UTF-8');
            newFile.buildertek__Folder__c = folderList[0].Id;
            newFile.buildertek__Bucket_Name__c = folderList[0].Name;
            newFile.buildertek__Extension__c = fileType;
            newFile.buildertek__Size__c = fileSize;
            newFile.buildertek__Content_Type__c = fileType;
            newFile.buildertek__Allow_to_Copy_Move__c = true;
            newFile.buildertek__Presigned_URL_Frequency__c = 'Every Month';
            newFile.buildertek__Public_On_Amazon__c = true;
            newFile.buildertek__Allow_to_Download_by_Presigned_URL__c = true;
            newFile.buildertek__Track_Download_History__c = true;
            newFile.buildertek__Allow_to_Copy_Move__c = true;
            newFile.buildertek__Access_Type__c = 'Public';
            newFile.buildertek__File_Presigned_URL__c = 'https://s3.amazonaws.com/'+folderList[0].Name+'/'+EncodingUtil.urlDecode(latestFileName, 'UTF-8');
            newFile.buildertek__Parent_Object_API_Name__c = Id.valueOf(rfqVendorId).getSObjectType().getDescribe().getName();
            newFile.buildertek__RFQ_To_Vendor__c = rfqVendorId;
            insert newFile;
        }
        ContentVersion contentToInsert =new ContentVersion();
        contentToInsert.Title =EncodingUtil.urlDecode(latestFileName, 'UTF-8');
        contentToInsert.VersionData = EncodingUtil.base64Decode(attachmentBody);
        contentToInsert.PathOnClient='/' + EncodingUtil.urlDecode(latestFileName, 'UTF-8') ;
        contentToInsert.IsMajorVersion = false;
        insert contentToInsert;

        contentToInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: contentToInsert.Id];
        ContentDocumentLink cl = new ContentDocumentLink();
        cl.ContentDocumentId = contentToInsert.ContentDocumentId;
        cl.LinkedEntityId = rfqVendorId;
        cl.ShareType = 'V';
        cl.Visibility = 'AllUsers';
        insert cl;
    }

    /*
File object that is used to pass file detail from page to controller.
*/
    public class File{
        Public Integer Size{ get; set; }

        Public String Name{ get; set; }

        Public String Extension{ get; set; }

        Public String ContentType{ get; set; }

        Public String BucketName;
        Public String Folder;
        Public Boolean Replace;
        Public String AccessType;
        Public Boolean PublicOnAmazon;
        Public Boolean AllowCopy;
        Public Boolean AllowShareViaURL;
        Public Boolean TrackDownload;

        public File(){
        }
    }

    public class FileWrapper{
        public String imgUrl{ get; set; }

        public String imgTitle{ get; set; }
    }
   public PageReference openNewVFpage(){
        pageReference pg = new pageReference('/apex/NewRFIVF');
        Map<String,String> parameters = new Map<String,String>{
                'Id' =>rfqId,
                'contact'=>rfqcontact
                };

                    pg.getParameters().putAll(parameters);
        return pg.setRedirect(true);

    }


    public void createRFI(){
        try{

           system.debug('newrfi--->'+newrfi);
           //buildertek__RFI__c newrfi = new buildertek__RFI__c ();
           contact cont = [Select Id from contact limit 1];
           newrfi.buildertek__RFQ__c = rfqId;
           newrfi.buildertek__Status__c = 'RFI Sent';
           newrfi.buildertek__Assigned_To__c = cont.Id;
           newrfi.buildertek__Submitted_By2__c = rfqcontact;
          // newrfi.buildertek__Project__c = projectId;
           newrfi.buildertek__RFI_From_Site__c = true;
           //newrfi.buildertek__Project__c = 'a1Q1K000004OIswUAG';
           newrfi.buildertek__RFI_Assigned_To__c  = rfqrec1.buildertek__RFI_Owner__c;
           upsert newrfi;
           system.debug('newrfi'+newrfi);
           //rfisaved = true;
           isErrorMessage = true;
           errorMessage = 'RFI created successfully.';
           //isReload = true;
           //rfiId = newrfi.Id;



           system.debug('rfiId--'+newrfi.Id);


           system.debug('attachRec--->'+attachRec);
           if(attachRec.body!=null){
               attachRec.ParentId =  newrfi.Id;
               insert attachRec;
               system.debug('attachRec--'+attachRec);


                List<ContentVersion> contentVersionToInsert = new List<ContentVersion>();
                ContentVersion con= new contentversion();
                con.ContentLocation = 'S';
                con.PathOnClient = attachRec.name;
                con.VersionData = attachRec.body;
                con.Title = attachRec.name;
                contentVersionToInsert.add(con);

                if(contentVersionToInsert.size() > 0){
                    insert contentVersionToInsert;
                    SET<Id> contentDocumentIds = new SET<Id>();
                    List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: contentVersionToInsert];
                    for(ContentVersion cv : contentVersionList){
                        contentDocumentIds.add(cv.ContentDocumentId);
                    }
                    List<ContentDocument> conDocList = [SELECT Id,Title FROM ContentDocument WHERE Id IN:contentDocumentIds];
                    List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                    for(ContentDocument cd : conDocList){
                        ContentDocumentLink CDL = new ContentDocumentLink();
                        CDL .ContentDocumentId = cd.Id;
                        CDL .LinkedEntityId =  newrfi.Id;
                        CDL .ShareType = 'I';
                        CDL .Visibility = 'AllUsers';
                        cdlList.add(CDL);
                    }
                    if(cdlList.size() > 0){
                        insert cdlList;
                        attachRec = new Attachment();
                    }
                }
            }

             buildertek__RFI_Settings__c rfiSettings = new buildertek__RFI_Settings__c();
                 string notificationtemplate='New RFI notification';
                    List<buildertek__RFI_Settings__c> rfiSettingsList = [Select Id,Name,
                                                                         buildertek__Using_Communities__c,
                                                                         buildertek__Using_Email__c,
                                                                         buildertek__New_RFI_Notification_Template__c
                                                                         from buildertek__RFI_Settings__c
                                                                         WHERE Name ='RFI Settings'];
                system.debug('rfiSettingsList-------'+rfiSettingsList);
                if(rfiSettingsList.size() > 0){
                    rfiSettings = rfiSettingsList[0];
                    if(rfiSettings.buildertek__New_RFI_Notification_Template__c!=null){
                         notificationtemplate = rfiSettings.buildertek__New_RFI_Notification_Template__c;
                    }
                }


            buildertek__RFI__c rfiRec = [select id,Name,buildertek__RFQ__c,buildertek__Subject__c,buildertek__Project__c,buildertek__Project__r.Name,
                                         buildertek__Due_Date__c, buildertek__Assigned_To__c, buildertek__Assigned_To__r.Name,buildertek__Question__c,
                                         buildertek__RFI_Assigned_To__c,buildertek__RFI_Assigned_To__r.Email,buildertek__RFI_Assigned_To__r.Name
                                         from buildertek__RFI__c where Id =:newrfi.Id ];
            Contact con1;
            string msg='';
            con1 = [select id, Email
                   from Contact
                   where email != null
                   order by createddate desc
                   limit 1];
            string theTemplate;
            theTemplate = [SELECT Id
                           FROM EmailTemplate
                           WHERE Name  = :notificationtemplate].Id;
            if( rfiRec.buildertek__RFI_Assigned_To__c != null){


                try{


                               List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage message = new        Messaging.SingleEmailMessage();

                message.toAddresses = new String[] { rfiRec.buildertek__RFI_Assigned_To__r.Email};
                    message.setTemplateID(theTemplate);
                message.setSaveAsActivity(false);
                message.setWhatId(rfiRec.Id);
                //message.setSubject('New RFI Notification - [ref:'+newrfi.Id+']');
                message.setTargetObjectId(rfiRec.buildertek__RFI_Assigned_To__c);
                messageList.add(message);

                Savepoint sp = Database.setSavepoint();

                Messaging.sendEmail(messageList);

                Database.rollback(sp);


                             EmailServicesAddress eServices;
                        eServices = [SELECT Id, AuthorizedSenders, EmailDomainName, IsActive, LocalPart
                                     FROM EmailServicesAddress
                                     where LocalPart = 'projects'];

                        String fromAddress = eServices.LocalPart + '@' + eServices.EmailDomainName;


                          List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();

                // loop through the previous message list and set the email fields
                for (Messaging.SingleEmailMessage email : messageList) {
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSaveAsActivity(false);
                    emailToSend.setSubject(email.getSubject()+' - [ref:'+newrfi.Id+']');
                                         emailToSend.setReplyTo(fromAddress);

                    //emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    emailToSend.setFileAttachments(email.getFileAttachments());
                    actualMessageList.add(emailToSend);
                }

                try{
                    Messaging.SendEmailResult [] serList = Messaging.sendEmail(actualMessageList);
                    System.debug('The email was sent successfully.');
                }catch(Exception e){
                     System.debug('The email failed to send: ');
                    //}

                }



                }
                catch (exception e){
                    system.debug('error--->'+e.getMessage()+'line no-->'+e.getLineNumber());
                    msg = e.getMessage()+'-'+e.getLineNumber();
                }

            }
              //  isErrorMessage = false;



           system.debug(attachRec);

        } catch (Exception ex){
            // throw exception
            system.debug(ex.getMessage()+'---->'+ex.getLineNumber());
        }
    }


   public String filename1{get;set;}
    public String ResponseText;
    public string contentVerid{get;set;}
    public string Value2{get;set;}
    public void UploadFileonClick(){
        system.debug('UploadFileonClick Method');

        contentVerid = apexpages.currentPage().getParameters().get('firstvalue');
        Value2 = apexpages.currentPage().getParameters().get('secondvalue');
        ContentVersion contentVer = [select id ,title from contentVersion where id =:contentVerid];
        system.debug('contentVer======>'+contentVer);
        ContentDocumentLink link=new ContentDocumentLink();
            link.LinkedEntityId= rfqId;
            link.contentdocumentid=[select contentdocumentid from contentversion where id =:contentVer.id].contentdocumentId;
            link.ShareType = 'V';

        insert link;

        String title = Value2;
        contentVer.Description =Value2;
        title = title.substringBeforeLast('.');
        contentVer.Title = title;
        system.debug('fldid2222--->'+ fldid);

        update contentVer;

    }
    public void CallFunction(){
        callfunc='<script> CloseWindow(); </script>';
    }

    public void storeFiles(){
        List<Object> fileListParam = new List<Object>();
        System.debug('file List PARAM ==> '+fileListParam);
    }

    public static string getQueryStringForObjectWithAllFields(String objectType){
        String queryString;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.Sobjecttype sot = getObjectTypeFromTypeName(objectType);
        if (sot != null){
            Schema.DescribeSObjectResult dr = sot.getDescribe();
            // all fields of attestation object
            Map<String, Schema.SObjectField> fields = dr.fields.getMap();
            integer i = 0;
            queryString = ' ';
            for (String field : fields.keyset()){
                if (i == 0){
                    queryString += field;
                } else{
                    queryString += ', ' + field;
                }
                i++;
            }
        }
        system.debug('queryString ----------> ' + queryString);
        return queryString;
    }

    public static Schema.Sobjecttype getObjectTypeFromTypeName(String typeName){
        return getObjectTypeFromTypeName(typeName, false);
    }

    public static Schema.Sobjecttype getObjectTypeFromTypeName(String typeName, Boolean nullOk){
        String updatedTypeName = OBJECT_NAMESPACE_MAP.get(typeName);
        if (updatedTypeName == null){
            updatedTypeName = typeName;
        }
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.Sobjecttype st = gd.get(updatedTypeName);
        return st;
    }

}