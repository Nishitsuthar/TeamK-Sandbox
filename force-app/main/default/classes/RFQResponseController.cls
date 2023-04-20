/*
Copyright (c) 2017-2018, BuilderTek.
All rights reserved.

Developed By: Sagar
Date:  13-Jul-2018
*/
public without sharing class RFQResponseController{
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

    public Boolean displayPopUp{ get; set; }

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



    public RFQResponseController(){
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
            String query = 'Select RFQ__r.Due_Date__c,RFQ__r.Name,RFQ__r.RFQ_Details__c,RFQ__r.Auto_Number__c,RFQ__r.Project__c,buildertek__RFQ__r.Project__r.Name,' + BT_Utils.getQueryStringForObjectWithAllFields('buildertek__RFQ_To_Vendor__c')+',(Select id,Name,Item_Name__c,Vendor_Note__c,buildertek__Estimated_Work_Days__c,Quantity__c,Unit_Price__c,Total_Price__c,Description__c,Budget_Line_Amount__c, buildertek__RFQ_Item__c from Vendor_Items__r),(Select Id, Name, File__r.Name, File__r.File_Presigned_URL__c,File__r.Description__c,File__r.Download_Link__c,File__r.Download_Link1__c from RFQ_To_Vendor_Document_Links__r), (Select Id, Name, File_Presigned_URL__c,Description__c from Files__r) From buildertek__RFQ_To_Vendor__c where ID =:rfqVendorId order by Name';
            if (Schema.sObjectType.buildertek__RFQ_To_Vendor__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor__c.fields.buildertek__Contact__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor__c.fields.buildertek__Status__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor__c.fields.buildertek__Quote_Amount__c.isAccessible() && Schema.sObjectType.buildertek__RFQ__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__RFQ__c.fields.buildertek__Vendor__c.isAccessible() && Schema.sObjectType.buildertek__RFQ__c.fields.buildertek__Status__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Item_Name__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Quantity__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Unit_Price__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Total_Price__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Description__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Budget_Line_Amount__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Vendor_Note__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_Vendor_Item__c.fields.buildertek__Estimated_Work_Days__c.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor_Document_Link__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor_Document_Link__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__RFQ_To_Vendor_Document_Link__c.fields.buildertek__File__c.isAccessible() && Schema.sObjectType.buildertek__File__c.fields.Id.isAccessible() && Schema.sObjectType.buildertek__File__c.fields.Name.isAccessible() && Schema.sObjectType.buildertek__File__c.fields.buildertek__File_Presigned_URL__c.isAccessible() && Schema.sObjectType.buildertek__File__c.fields.buildertek__Download_Link__c.isAccessible() && Schema.sObjectType.buildertek__File__c.fields.buildertek__Download_Link1__c.isAccessible()){
                rfqToVendor = (buildertek__RFQ_To_Vendor__c)Database.query(query)[0];
                rfqId = rfqToVendor.buildertek__RFQ__c;
                rfqcontact=rfqToVendor.buildertek__Contact__c;
                projectId =rfqToVendor.buildertek__RFQ__r.buildertek__Project__c;

                rfqrec1 = [ Select Id, Name, OwnerId, Owner.Name,buildertek__RFI_Owner__c  From buildertek__RFQ__c Where Id=:rfqId];
                newrfi.buildertek__RFI_Assigned_To__c = rfqrec1.OwnerId;

            }
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


        } catch (Exception ex){
            throw ex;
            // throw exception
        }
    }


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



    public void showPopup()
    {

    displayPopup1 = true;


    }

    public void closePopup1() {
        displayPopup1 = false;

    }

    public void redirectPopup()
    {
    displayPopup1 = false;
        //Please uncomment below 3 statements and replace YourObjectId
       // PageReference p=new Pagereference('/'+YourObjectId);
       //  p.setRedirect(true);
       //  return p;

    }

    public class WrapperVerdorLineList{
        public Integer index{ get; set; }

        public buildertek__RFQ_Vendor_Item__c record{ get; set; }
    }
}