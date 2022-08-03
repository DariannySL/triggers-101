@isTest
public with sharing class TestDataFactory {

    static testmethod void TestInsertSingleAcct() {
        Account newAcct = createAccount('New Test Account');

        Test.startTest();
        insert newAcct;
        Test.stopTest();
    }

    static testmethod void TestInsertMultipleAccts() {
        List<Account> newAccts = createAccounts(210);

        Test.startTest();
        insert newAccts;
        Test.stopTest();
    }

    static testmethod void TestUpdateMultipleAccts() {
        List<Account> newAccts = createAccounts(210);
        insert newAccts;
        
        List<Account> AccountToUpdate = [
            SELECT Id, Rating
            FROM Account 
            WHERE Id IN :newAccts];
            
        for(Account Acct : AccountToUpdate) {
            Acct.rating = 'Warm';
        }

        Test.startTest();
        update AccountToUpdate;
        Test.stopTest();
    }

    public static List<Account> createAccounts(Integer accountsToCreate) {
        
        List<Account> acctList = new List<Account>();
        for(Integer i; i >= accountsToCreate; i++) {
            acctList.add(
                createAccount('Test Account Name ' + i)
            );
        }

        return acctList;
    }


    public static Account createAccount(String accName) {
        Location__c location = new Location__c(location_code__c='CA');
        insert location;
        
        return new Account(name = accName, location__c=location.Id); 
    }
}