/**
 * @description       : To extract the picklist field values in job custom object
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JobPicklistController {
  public List<String> getPicklistValues(
    String objectApiName,
    String fieldName
  ) {
    List<String> picklistValues = new List<String>();

    try {
      Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe()
        .get(objectApiName)
        .getDescribe()
        .fields.getMap()
        .get(fieldName)
        .getDescribe();
      for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
        picklistValues.add(entry.getLabel());
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage()+e.getLineNumber());
    }

    return picklistValues;
  }

  @AuraEnabled
  public static List<String> experienceFieldValues() {

    String fieldName = 'experience__c';
    String objectApiName = 'Job__c';

    JobPicklistController controller = new JobPicklistController();

    List<String> picklistValues = controller.getPicklistValues(
      objectApiName,
      fieldName
    );

    return picklistValues;
  }
  @AuraEnabled
  public static list<string> typePickListValues() {
    String fieldName = 'type__c';
    String objectApiName = 'Job__c';

    JobPicklistController controller = new JobPicklistController();

    List<String> picklistValues = controller.getPicklistValues(objectApiName,fieldName);

    return picklistValues;
}
@AuraEnabled
  public static list<string> IndustryPickListValues() {
    String fieldName = 'Industry__c';
    String objectApiName = 'Job__c';
    JobPicklistController controller = new JobPicklistController();
    List<String> picklistValues = controller.getPicklistValues(objectApiName,fieldName);
    return picklistValues;
}

@AuraEnabled
  public static list<string> TimingsPickListValues() {
    String fieldName = 'Test_Timing__c';
    String objectApiName = 'Job__c';
    JobPicklistController controller = new JobPicklistController();
    List<String> picklistValues = controller.getPicklistValues(objectApiName,fieldName);
    return picklistValues;
  }
}