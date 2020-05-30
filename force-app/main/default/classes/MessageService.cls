public without sharing class MessageService {
    
    //@TODO move to custom label
    public static final String DEFAULT_MSG = 'Thank you for your message. Our customer rep will soon attend you.';

    public static String saveMessage(Message incomingMsg){

        String responseMessage = DEFAULT_MSG;
        
        if( incomingMsg == null )
            return null;

        incomingMsg.parentRecordId = findRecord(incomingMsg);
        
        //responseMessage += 'record found'+incomingMsg.parentRecordId;
	
        if( incomingMsg.parentRecordId == null ){
            // create new lead
            incomingMsg.parentRecordId = LeadService.create(incomingMsg);
        }
        
        create(incomingMsg);
        
        return responseMessage;
    }

    public static Id findRecord(Message incomingMsg){

        //find  existing opportunity record 
        Id recordId = OpportunityService.find(incomingMsg.fromNumber);
        
        if( recordId == null ) {
            recordId = LeadService.find(incomingMsg.fromNumber);
        }

        return recordId;
    }

    public static Id create(Message msg){

        Message__c msgRecord =  new Message__c(
                From_Number__c = msg.fromNumber
            ,   To_Number__c   = msg.toNumber 
            ,   Message__c     = msg.message
            ,   Type__c        = Message.INCOMING 
        );

        String pId = ''+msg.parentRecordId;

        if( pId.startsWith('006') ) {
            msgRecord.RFQ__c    = msg.parentRecordId;    
        } else {
            msgRecord.Lead__c   = msg.parentRecordId;    
        }
        

        insert msgRecord;

        return msgRecord.Id;
    }
}