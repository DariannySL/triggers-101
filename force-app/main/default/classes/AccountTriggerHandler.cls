public with sharing class AccountTriggerHandler extends TriggerHandler {

    public override void beforeInsert(){
        updateFavoriteColor(Trigger.new);
    }

    public override void beforeUpdate(){
        updateFavoriteColor(Trigger.new);
    }

    private static void updateFavoriteColor(List<Account> accounts) {
        Map<Id,User> userFavColor = getUserFavoriteColor();

        for(Account acct : accounts) {
            User userColor = userFavColor.get(acct.OwnerId);

            if(!String.isBlank(userColor.Favorite_Color__c)) {
                acct.User_Favorite_Color__c = userColor.Favorite_Color__c;
            }
            else {
                acct.addError('The account owner doesn\'t have a favorite color define');
            }
        }
    }

    private static Map<Id,User> getUserFavoriteColor() {
        Map<Id,User> usersFavoriteColor = new Map<Id,User>([
            SELECT Id, Favorite_Color__c 
            FROM User
        ]);

        return usersFavoriteColor;
    }
}
