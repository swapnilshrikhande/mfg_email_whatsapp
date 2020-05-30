trigger Message on Message__c (after insert) {
	MessageHandler.execute(Trigger.oldMap, Trigger.new);
}