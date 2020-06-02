trigger LeadAfterUpdate on Lead (before update) {
	LeadRollupHandler.execute(Trigger.oldMap,Trigger.new);
}