public with sharing class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact contactRecived, String stateRecived) {
        contact = contactRecived;
        state = stateRecived;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE BillingState = :state
            LIMIT 200
        ];
        if(!accounts.isEmpty()){
            List<Contact> contactList = new List<Contact>();
            for(Account acc : accounts){
                Contact newContact = contact.clone();
                newContact.AccountId = acc.Id;
                contactList.add(newContact);
            }
            insert contactList;
        }
    }
}