public class AccountTriggerHandler {
    public static void triggerOnInsert(List<Account> newAccounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Account acc : newAccounts) {
            if (acc.Type != null && acc.Type.contains('Customer') && acc.Active__c) {
                Contact newContact = new Contact(
                    FirstName = acc.Name,
                    LastName = 'Customer Representative',
                    AccountId = acc.Id,
                    Email = acc.Company_Email__c,
                    Phone = acc.Phone
                );
                contactsToInsert.add(newContact);
            }
        }
        
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
    
    public static void triggerOnUpdate(Map<Id, Account> newAccountsMap) {
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Account acc : newAccountsMap.values()) {
            if (acc.Type != null && acc.Type.contains('Customer') && acc.Active__c) {
                // Check if there are any related contacts
                if ([SELECT COUNT() FROM Contact WHERE AccountId = :acc.Id] == 0) {
                    Contact newContact = new Contact(
                        FirstName = acc.Name,
                        LastName = 'Customer Representative',
                        AccountId = acc.Id,
                        Email = acc.Company_Email__c,
                        Phone = acc.Phone
                    );
                    contactsToInsert.add(newContact);
                }
            }
        }
        
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}