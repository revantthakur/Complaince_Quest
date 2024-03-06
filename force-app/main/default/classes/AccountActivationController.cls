public with sharing class AccountActivationController {

    @AuraEnabled
    public static void activateAccount(Id recordId, String activationSummary) {
        try {
            Account acc = [SELECT Id, Active__c, Account_Activation_Summary__c FROM Account WHERE Id = :recordId LIMIT 1];
            acc.Active__c = true;
            acc.Account_Activation_Summary__c = activationSummary;
            update acc;
        } catch (Exception e) {
            throw new AuraHandledException('Error activating account: ' + e.getMessage());
        }
    }
}