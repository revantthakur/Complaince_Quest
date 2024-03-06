@isTest
public class TestAccountTriggerHandler {
    @isTest
    static void testTriggerOnInsert() {
        // Create test account with the required fields
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer - Direct',
            Active__c = true,
            Company_Email__c = 'test@example.com',
            Phone = '1234567890',
            Account_Activation_Summary__c = 'account is activated'
        );
        insert testAccount;
        
        // Invoke the trigger handler method
        List<Account> newAccounts = new List<Account>{testAccount};
        AccountTriggerHandler.triggerOnInsert(newAccounts);
        
        // Verify that the contact has been inserted
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, contactCount, 'Contact not created for the account');
    }
    
    @isTest
    static void testTriggerOnUpdate() {
        // Create test account with the required fields
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer - Direct',
            Active__c = true,
            Company_Email__c = 'test@example.com',
            Phone = '1234567890',
            Account_Activation_Summary__c = 'account is activated'
        );
        insert testAccount;
        
        // Invoke the trigger handler method
        Map<Id, Account> newAccountsMap = new Map<Id, Account>{testAccount.Id => testAccount};
        AccountTriggerHandler.triggerOnUpdate(newAccountsMap);
        
        // Verify that the contact has been inserted
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, contactCount, 'Contact not created for the account');
        
        // Test when the contact already exists
        Contact existingContact = new Contact(
            FirstName = 'Test Account',
            LastName = 'Customer Representative',
            AccountId = testAccount.Id,
            Email = 'test@example.com',
            Phone = '1234567890'
        );
        insert existingContact;
        
        newAccountsMap.clear();
        newAccountsMap.put(testAccount.Id, testAccount);
        
        // Invoke the trigger handler method
        AccountTriggerHandler.triggerOnUpdate(newAccountsMap);
        
        // Verify that no new contact is inserted
        contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, contactCount, 'New contact inserted even when one already exists');
    }
}