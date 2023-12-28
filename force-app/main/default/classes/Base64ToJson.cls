/**
 * @description       : Convert base64 to json string
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-22-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class Base64ToJson {
    @AuraEnabled(cacheable=true)
    public static void Base64ToJsonMethod(Blob base64Data) {
        system.debug('base64Blob------>'+ base64Data);

        String jsonString = base64Data.toString();
        Object parsedObject = JSON.deserializeUntyped(jsonString);
        String parsedJsonString = JSON.serialize(parsedObject);

        system.debug('parsedJsonString------->'+parsedJsonString);
    }
}