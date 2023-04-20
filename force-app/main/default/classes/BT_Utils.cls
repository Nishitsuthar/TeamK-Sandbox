/* **************************************************************************
 * Copyright 2016-2017, BuilderTek
 * All rights reserved
 *
 * Util Class: BT_Utils
 * Created by Sagar: 06/05/2017
 *
 * - All util functions..

 * - Modifications:
 * - Sagar, 06/05/2017 – Initial Development
 ************************************************************************** */
public with sharing class BT_Utils{

    public static Schema.Sobjecttype getObjectTypeFromTypeName(String typeName){
        return getObjectTypeFromTypeName(typeName, false);
    }

    /*
     *   Executed:   From any class.
     *   Purpose:    Funxtion will return the Object type using object name
     *   Parameters: object name
     *   UnitTests:
     */
    public static Schema.Sobjecttype getObjectTypeFromTypeName(String typeName, Boolean nullOk){
        String updatedTypeName = BT_Constants.OBJECT_NAMESPACE_MAP.get(typeName);
        if (updatedTypeName == null){
            updatedTypeName = typeName;
        }
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.Sobjecttype st = gd.get(updatedTypeName);
        return st;
    }

    //Return SobjectField usign object and field name.
    public static Schema.SObjectField getField(String objectName, String fieldName){
        Schema.Sobjecttype sot = getObjectTypeFromTypeName(objectName);

        if (sot != null){
            Schema.DescribeSObjectResult dr = sot.getDescribe();
            Map<String, Schema.SObjectField> fields = dr.fields.getMap();
            return fields.get(fieldName);
        }
        return null;
    }

    
    public static string getQueryStringForObjectWithAllFields(String objectType){
        String queryString;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.Sobjecttype sot = BT_Utils.getObjectTypeFromTypeName(objectType);
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

    public class GlobalUtilityException extends Exception{
    }
}