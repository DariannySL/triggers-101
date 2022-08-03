public with sharing class ContactTriggerHandler extends TriggerHandler {
    
    public override void afterInsert() {
        
        Set<id> accountIds = new Set<id>();
        for(Contact ct : (List<Contact>) Trigger.new) {
            
            if(ct.status__c == 'Active') {
                accountIds.add(ct.accountId);
            }
        }

        updateActiveContacts(accountIds);
    }

    public override void afterUpdate(){

        Contact oldContact;
        Set<id> accountIds = new Set<id>();

        for(Contact ct : (List<Contact>) Trigger.new) {
            oldContact = (Contact) Trigger.oldMap.get(ct.Id);

            if(ct.Status__c != oldContact.Status__c) {
                accountIds.add(ct.accountId);
            }
        }

        if(!accountIds.isEmpty()) {
            updateActiveContacts(accountIds);
        }
    }

    private static void updateActiveContacts(Set<Id> accountIds) {

        List<AggregateResult> filteredResults = [
            SELECT AccountId, COUNT(Id) activeContacts 
            FROM Contact
            WHERE AccountId IN : accountIds AND Status__c = 'Active'
            GROUP BY AccountId
        ];

        List<Account> acctListToUpdate = new List<Account>();
        Account Acct;

        for (AggregateResult ag : filteredResults) {
            Acct = new Account();
            acct.id = (Id) ag.get('accountId');
            acct.Active_Contacts__c = (Integer) ag.get('activeContacts');

            acctListToUpdate.add(Acct);
        }

        if(acctListToUpdate.size() > 0) {
            update acctListToUpdate;
        }
    }
}
