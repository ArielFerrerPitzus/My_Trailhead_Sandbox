@isTest
private class LeadProcessorTest {
    @testSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(
                new Lead(
                    LastName='testLead ' + i,
                    Company='Acme'
                )
            );
        }
        insert leads;
    }

    @isTest 
    private static void WhenExecuteBatch_UpdateNoDreamforceLeads() {
        Test.startTest();
        LeadProcessor leadProcessorBatch = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessorBatch);
        Test.stopTest();
        
        List<Lead> updatedLeads = [
            SELECT Id 
            FROM Lead 
            WHERE LeadSource = 'Dreamforce'
        ];
        System.AssertEquals(true, updatedLeads.size() != 0, 'LeadSource was not correctly updated');
    }
}