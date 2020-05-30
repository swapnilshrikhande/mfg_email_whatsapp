@RestResource(urlMapping='/pushmessage/*')
global class IncomingWhatsAppService {
    
    
    public static final String MESSAGE_BODY='Body';
    public static final String MESSAGE_FROM='From';
    public static final String MESSAGE_TO='To';
    
    @HttpGet
    global static String doGet() {
        return 'hello world';
    }
    
    @HttpPost
    global static void doPost() {

        
    	RestRequest req = RestContext.request;
	    RestResponse res = Restcontext.response;
        
        Utils.debugMap('Header',req.headers);
        Utils.debugMap('Param',req.params);
        
        String fromNumber  = extractNumber(
            req.params.get(MESSAGE_FROM)
        );

        String toNumber  = extractNumber(
            req.params.get(MESSAGE_TO)
        );

        //Get Message Body
        String messageBody = req.params.get(MESSAGE_BODY);
        messageBody        = Utils.sanitize(messageBody);

        String returnMessage = MessageService.saveMessage(new Message(
                fromNumber
            ,   toNumber  
            ,   messageBody
        ));


        setResponse( res, returnMessage );
        
        return;
    }

    public static String extractNumber(String phoneString){
        phoneString = Utils.sanitize(phoneString);
        return String.isBlank(phoneString) ? '' : phoneString.split(':')[1].trim();
    }

    public static void setResponse( RestResponse res  , String message ){
        res.addHeader('Content-Type', 'text/plain');
        message = Utils.sanitize(message);
        res.responseBody = Blob.valueOf( message );
    }
    
}