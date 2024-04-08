/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class calculateAgeTest {
  @isTest
  static void testCalculateAgeMethod() {
    date date_1 = Date.newInstance(2001, 11, 20);
    date date_2 = Date.newInstance(1990, 11, 20);
    date date_3 = Date.newInstance(1980, 11, 20);
    date date_4 = Date.newInstance(1970, 11, 20);
    date date_5 = Date.newInstance(1960, 11, 20);
    date date_6 = Date.newInstance(1950, 11, 20);
    date date_7 = Date.newInstance(1940, 11, 20);
    date date_8 = Date.newInstance(1930, 11, 20);
    date date_9 = Date.newInstance(2010, 11, 20);
    date date_10 = Date.newInstance(2016, 11, 20);

    string result_1 = calculateAge.calculateAgeMethod(date_1);
    string result_2 = calculateAge.calculateAgeMethod(date_2);
    string result_3 = calculateAge.calculateAgeMethod(date_3);
    string result_4 = calculateAge.calculateAgeMethod(date_4);
    string result_5 = calculateAge.calculateAgeMethod(date_5);
    string result_6 = calculateAge.calculateAgeMethod(date_6);
    string result_7 = calculateAge.calculateAgeMethod(date_7);
    string result_8 = calculateAge.calculateAgeMethod(date_8);
    string result_9 = calculateAge.calculateAgeMethod(date_9);
    string result_10 = calculateAge.calculateAgeMethod(date_10);

    System.assertEquals('Twenties', result_1);
    System.assertEquals('Thirties', result_2);
    System.assertEquals('Forties', result_3);
    System.assertEquals('Fifties', result_4);
    System.assertEquals('Sixties', result_5);
    System.assertEquals('Seventies', result_6);
    System.assertEquals('Eighties', result_7);
    System.assertEquals('Greater than 90', result_8);
    System.assertEquals('Tens', result_9);
    System.assertEquals('Less than 10 years', result_10);
  }
}