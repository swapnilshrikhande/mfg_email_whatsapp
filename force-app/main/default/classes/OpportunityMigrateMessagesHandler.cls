public with sharing class OpportunityMigrateMessagesHandler {
    public OpportunityMigrateMessagesHandler() {

    }

    public static void migrateMessages(List<Opportunity> oppLst) {
        //this handler only handles single record conversion scenario :O
        Opportunity opprRecord = oppLst[0];
        migrateMessagesFromLead(opprRecord.Id);
    }

    @future
    public static void migrateMessagesFromLead(String opprId){
        List<Lead> leadRecords = [
            SELECT Id
                 , (Select Id From Messages__r)
            FROM Lead
            WHERE ConvertedOpportunityId = :opprId
            LIMIT 1
        ];

        if( !leadRecords.isEmpty() ) {
            List<Message__c> msgLst = leadRecords[0].Messages__r;

            for(Message__c msg : msgLst  ) {
                msg.RFQ__c = opprId;
            }

            update msgLst;
        } else {
            ///nop
        }
    }
}