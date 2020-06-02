public without sharing class MessageService {
    
    //@TODO move to custom label
    public static final String DEFAULT_MSG = 'Thank you! We have registered your request, our customer executive will soon contact you.';

    public static String saveMessage(Message incomingMsg){

        String responseMessage = DEFAULT_MSG;
        
        if( incomingMsg == null )
            return 'Sorry, invalid message!';

        //if reset message, delete all records for the current number to restart the demo
        Boolean isReset = 'reset'.equals(incomingMsg.message);

        if( isReset ) {
            Database.delete( LeadService.findAll(incomingMsg) );
            return 'Hi';
        }

        Boolean isCategorySelection =  LeadService.productCategoryMap.keySet().contains(incomingMsg.message);
        Boolean isProductSelection =  LeadService.productIdMap.keySet().contains(incomingMsg.message);

        incomingMsg.parentRecordId = findRecord(incomingMsg);
            
        if( incomingMsg.parentRecordId == null ){
            
            //if new lead show category selection option
            responseMessage = LeadService.CATEGORY_SELECTION_MESSAGE;
            // create new lead
            incomingMsg.parentRecordId = LeadService.create(incomingMsg);

            //responseMessage += 'new lead : '+incomingMsg.parentRecordId;

        } else {
            //responseMessage += 'record found :'+incomingMsg.parentRecordId;

            //if  product  selected find existing record 
            if( isCategorySelection ) {
                //send product selection
                String productList = Utils.join(LeadService.productMap.get(incomingMsg.message),' ');
                responseMessage = String.format(LeadService.PROD_SELECTION_MESSAGE,new List<String>{productList});

                incomingMsg.prodCategory = LeadService.productCategoryMap.get(incomingMsg.message);

                incomingMsg.message = 'Selected Category : '+incomingMsg.prodCategory;

            } else if( isProductSelection ) {

                incomingMsg.product      = LeadService.productIdMap.get(incomingMsg.message);  
                String parentCategory    = LeadService.parentCategoryMap.get(incomingMsg.message); 
                incomingMsg.prodCategory = LeadService.productCategoryMap.get(parentCategory);

                incomingMsg.message = 'Selected Product : '+incomingMsg.product;
            } else {
                //normal message
            }

        }
        
        if( ! String.isBlank( incomingMsg.parentRecordId )   )
            create(incomingMsg);
        
        return responseMessage;
    }

    public static Id findRecord(Message incomingMsg){

        //find  existing opportunity record 
        Id recordId = OpportunityService.find(incomingMsg);
        
        if( recordId == null ) {
            recordId = LeadService.find(incomingMsg);
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
        
        if( msgRecord.Lead__c != null ){
        	update new Lead(Id=msgRecord.Lead__c,Activity_Count_Updated_On__c=null);    
        }
        
        return msgRecord.Id;
    }
}