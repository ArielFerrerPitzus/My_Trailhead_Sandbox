public with sharing class LeadProcessor implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, LeadSource ' +
            'FROM Lead ' +
            'WHERE LeadSource != \'Dreamforce\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead aLead : scope) {
            aLead.LeadSource = 'Dreamforce';
            leadsToUpdate.add(aLead);
        }

        update leadsToUpdate;
    }

    public void finish(Database.BatchableContext bc){

    }
}