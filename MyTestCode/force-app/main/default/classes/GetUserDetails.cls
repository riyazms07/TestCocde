 /* With sharing is used as best pratice and because OWD = Public Read Only for User object */
public with sharing class GetUserDetails {
    @AuraEnabled
    public static UserDetailsWrapper getUserRecordByEmail(string contactEmail){
        try {
            List<User> user = [SELECT Name,Email, UserRole.Name,Profile.Name
                                FROM User
                                WHERE Email =: contactEmail

            ];
            /* If User record doesn't exits for the email , return null */
            if(user.isEmpty()){
                return null;
            }
            /* Return User record using the wrapper class */
            return new UserDetailsWrapper(user[0]);            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     /* Wrapper class to return user record to LWC  */
    public class UserDetailsWrapper{
        @AuraEnabled public string name ;
        @AuraEnabled public string email;
        @AuraEnabled public String roleName;
        @AuraEnabled public String profileName;
        Public UserDetailsWrapper(User user){    
            name = user.Name;
            email = user.Email;
            roleName = user.UserRole.Name;
            profileName = user.Profile.Name;
        }   
    }
}