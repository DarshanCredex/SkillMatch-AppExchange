/**
 * @description       : this class contains a method used to calculate the age group of applicant using dob
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class calculateAge {
  
  public static String calculateAgeMethod(Date dateOfBirth) {
    if (dateOfBirth == null) {
      return null;
    }

    Date today = Date.today();
    Integer birthYear = dateOfBirth.year();
    Integer birthMonth = dateOfBirth.month();
    Integer birthDay = dateOfBirth.day();

    Integer todayYear = today.year();
    Integer todayMonth = today.month();
    Integer todayDay = today.day();

    Integer age = todayYear - birthYear;

    if (
      todayMonth < birthMonth ||
      (todayMonth == birthMonth &&
      todayDay < birthDay)
    ) {
      age--;
    }
    string ageGroup;

    if (age < 10) {
      ageGroup = 'Less than 10 years';
    } else if (age >= 10 && age < 20) {
      ageGroup = 'Tens';
    } else if (age >= 20 && age < 30) {
      ageGroup = 'Twenties';
    } else if (age > 30 && age < 40) {
      ageGroup = 'Thirties';
    } else if (age >= 40 && age < 50) {
      ageGroup = 'Forties';
    } else if (age >= 50 && age < 60) {
      ageGroup = 'Fifties';
    } else if (age >= 60 && age < 70) {
      ageGroup = 'Sixties';
    } else if (age >= 70 && age < 80) {
      ageGroup = 'Seventies';
    } else if (age >= 80 && age < 90) {
      ageGroup = 'Eighties';
    } else if (age >= 90) {
      ageGroup = 'Greater than 90';
    }
    return ageGroup;
  }
}