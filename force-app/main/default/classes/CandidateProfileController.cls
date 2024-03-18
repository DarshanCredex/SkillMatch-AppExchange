/**
 * @description       :
 * @author            : Sagar Medatwal
 * @group             :
 * @last modified on  : 03-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public without sharing class CandidateProfileController {
  @AuraEnabled
  public static void attachFileToCandidate(
    string emailId,
    String fileName,
    String base64Data,
    String contentType
  ) {
    System.debug('fileName-->' + fileName);
    System.debug('base64Data-->' + base64Data);
    System.debug('contentType-->' + contentType);
    try {
      List<Candidate_Details__c> currentCandidate = [
        SELECT Id
        FROM Candidate_Details__c
        WHERE Candidate_Email__c = :emailId
      ];
      Attachment attachment = new Attachment();
      attachment.ParentId = currentCandidate[0].Id;
      attachment.Name = fileName;
      attachment.Body = EncodingUtil.base64Decode(base64Data);
      attachment.ContentType = contentType;
      insert attachment;
    } catch (Exception e) {
      throw new AuraHandledException('Error attaching file: ' + e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static Candidate_Details__c getCandidateDetails(string emailId) {
    system.debug('emailid----->' + emailId);
    try {
      List<Candidate_Details__c> currentCandidate = [
        SELECT
          Id,
          Profile_Picture__c,
          Name,
          Candidate_Email__c,
          CTC__c,
          Date_of_birth__c,
          About__c,
          Phone_Number__c,
          Skills__c,
          Experience__c,
          City__c,
          Country__c,
          (
            SELECT
              Id,
              Name,
              Organisation__c,
              From_Date__c,
              To_Date__c,
              City__c,
              Country__c
            FROM Work_Experience__r
            ORDER BY From_Date__c DESC
          )
        FROM Candidate_Details__c
        WHERE Candidate_Email__c = :emailId
      ];
      if (currentCandidate.size() > 0) {
        return currentCandidate[0];
      } else {
        return new Candidate_Details__c();
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static String getIdFromEmail(String email) {
    Candidate_Details__c candidate = [
      SELECT Id
      FROM Candidate_Details__c
      WHERE Candidate_Email__c = :email
      LIMIT 1
    ];
    if (candidate != null) {
      return candidate.Id;
    }
    return null;
  }

  @AuraEnabled
  public static void addCandidateExperience(
    string organisation,
    date fromDate,
    date toDate,
    string city,
    string country,
    boolean checkboxValue,
    Id candidateId,
    string Designation
  ) {
    Work_Experience__c experience = new Work_Experience__c();
    list<Work_Experience__c> expList = new List<Work_Experience__c>();

    experience.Organisation__c = organisation;
    experience.From_Date__c = fromDate;
    experience.To_Date__c = toDate;
    experience.City__c = city;
    experience.Country__c = country;
    experience.Is_Current_Company__c = checkboxValue;
    experience.CandidateId__c = candidateId;
    experience.Name = Designation;

    expList.add(experience);
    try {
      if (!expList.IsEmpty()) {
        insert expList;
      }
    } catch (Exception e) {
      system.debug(
        'errror------>' + e.getMessage() + '------->' + e.getLineNumber()
      );
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static string workExp(Id workId) {
    list<Work_Experience__c> expList = new List<Work_Experience__c>();

    Work_Experience__c experience = [
      SELECT
        City__c,
        Country__c,
        Name,
        From_Date__c,
        Is_Current_Company__c,
        Organisation__c,
        To_Date__c,
        Id
      FROM Work_Experience__c
      WHERE id = :workId
    ];
    expList.add(experience);

    return JSON.serialize(expList);
  }

  @AuraEnabled
  public static void updateWorkExp(
    string organisation,
    date fromDate,
    date toDate,
    string city,
    string country,
    boolean checkboxValue,
    Id workExperienceId,
    string designation
  ) {
    try {
      Work_Experience__c experience = [
        SELECT
          Organisation__c,
          City__c,
          Country__c,
          From_Date__c,
          To_Date__c,
          CandidateId__c,
          Is_Current_Company__c
        FROM Work_Experience__c
        WHERE Id = :workExperienceId
      ];

      experience.Organisation__c = organisation;
      experience.City__c = city;
      experience.Country__c = country;
      experience.From_Date__c = fromDate;
      experience.To_Date__c = toDate;
      experience.Is_Current_Company__c = checkboxValue;
      experience.Name = designation;

      update experience;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static string fetchDetailsForEditDisplay(string email) {
    try {
      list<Candidate_Details__c> candidateDetailsList = new List<Candidate_Details__c>();
      Candidate_Details__c candidate = [
        SELECT
          Id,
          Profile_Picture__c,
          Name,
          Candidate_Email__c,
          CTC__c,
          Date_of_birth__c,
          About__c,
          Phone_Number__c,
          Skills__c,
          Experience__c,
          City__c,
          Country__c
        FROM Candidate_Details__c
        WHERE Candidate_Email__c = :email
      ];
      candidateDetailsList.add(candidate);
      system.debug('candidateDetailsList------>' + candidateDetailsList);
      return JSON.serialize(candidateDetailsList);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static void UpdateCandidateDetails(
    string setAbout,
    string setPhoneNumber,
    string setSkills,
    Integer setExperience,
    string setCity_1,
    string setCountry_1,
    string email
  ) {
    try {
      Candidate_Details__c candidate = [
        SELECT
          Id,
          Profile_Picture__c,
          Name,
          Candidate_Email__c,
          CTC__c,
          Date_of_birth__c,
          About__c,
          Phone_Number__c,
          Skills__c,
          Experience__c,
          City__c,
          Country__c
        FROM Candidate_Details__c
        WHERE Candidate_Email__c = :email
      ];
      candidate.About__c = setAbout;
      candidate.Phone_Number__c = setPhoneNumber;
      candidate.Skills__c = setSkills;
      candidate.Experience__c = setExperience;
      candidate.City__c = setCity_1;
      candidate.Country__c = setCountry_1;

      update candidate;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
