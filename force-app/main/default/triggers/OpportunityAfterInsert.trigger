trigger OpportunityAfterInsert on Opportunity (after insert) {
    OpportunityMigrateMessagesHandler.migrateMessages(Trigger.new);
}