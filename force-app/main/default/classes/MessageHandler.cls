public without sharing class MessageHandler {
    public static void execute(Map<Id,Message__c> msgOldMap,List<Message__c> msgListNew){
        //actually send message by consuming the  whatsapp API
        sendMessage(msgListNew);
        updateParentLeadAsContacted(msgListNew);
    }

    public static void sendMessage(List<Message__c> msgListNew){
        //Get the default from number from custom 
        Twillio_Config__c config = Twillio_Config__c.getInstance();

        for(Message__c msg : msgListNew) {

            if( Message.INCOMING.equalsIgnoreCase(msg.Type__c) ) {
                continue;
            }

            //process only outgoing messages
			String fromNumber = config.Default_From__c;
            String toNumber   = msg.Send_To__c;
            String message    = msg.Message__c;

            SendWhatsappNotification.sendMessage(fromNumber, toNumber, message);
        }
    }

    public static void updateParentLeadAsContacted(List<Message__c> msgListNew){

        List<Lead> leadsToUpdate = new List<Lead>();

        for(Message__c msg : msgListNew) {
            if( msg.Lead__c != null ) {
                leadsToUpdate.add(new Lead(
                        Id = msg.Lead__c
                    ,   Status = LeadService.LEAD_STATUS_CONTACTED
                ));
            }
        }

        update leadsToUpdate;
    }
}