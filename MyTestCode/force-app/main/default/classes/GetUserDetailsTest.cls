
@isTest
private class GetUserDetailsTest {
    @TestSetup
    static void setup() {
        /* Insert Test User record */
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com',
            Username = 'testcontact@example.com',
            Alias = 'tuser',
            ProfileId = profile.Id,
            IsActive = true,
            EmailEncodingKey = 'UTF-8',
            TimeZoneSidKey = 'Europe/London',
            LocaleSidKey = 'en_GB',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
    }
    @IsTest
    static void testGetUserByEmail() {
        Test.startTest();
        /* Test Success scenario to get user record by email */
        GetUserDetails.UserDetailsWrapper result = GetUserDetails.getUserRecordByEmail('testcontact@example.com');
        Test.stopTest();
        Assert.areNotEqual(null, result, 'User record should exist for the Contact');
        Assert.areEqual('Test Contact', result.name,'User Name should match');
    }
    @IsTest
    static void testNoUserByEmail() {
        Test.startTest();
         /* Test scenario No user record for the email */
        GetUserDetails.UserDetailsWrapper result = GetUserDetails.getUserRecordByEmail('testcontact123@example.com');
        Test.stopTest();
        Assert.areEqual(null, result, 'No user record should exist for the Contact');
    }

}