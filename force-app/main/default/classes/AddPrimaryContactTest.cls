@isTest
public with sharing class AddPrimaryContactTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(
                new Account(
                    Name='Test Account' + i,
                    BillingState = i < 50 ? 'NY' : 'CA'
                )
            );
        }
        insert accounts;

        Contact aTestContact = new Contact(LastName = 'TestContact');
        insert aTestContact;
    }

    @isTest
    static void WhenEnqueueJob_ContactsForAccountsShouldBeCreated() {
        String stateToCheck = 'CA';
        Contact testContact = [
            SELECT id, LastName
            FROM Contact 
            LIMIT 1
        ];
        AddPrimaryContact addContactQueueable = new AddPrimaryContact(testContact, stateToCheck);

        Test.startTest();
        System.enqueueJob(addContactQueueable);
        Test.stopTest();
        
        List<Contact> createdContacts = [
            SELECT Id
            FROM Contact
            WHERE Account.BillingState = 'CA'
        ];
        System.AssertEquals(50, createdContacts.size(), 'A Contact for each CA Account should be created.');
    }
}