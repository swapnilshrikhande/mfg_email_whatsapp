public class SendWhatsappNotification {
    
    @future(callout=true)
    public static void sendMessage(String fromNumber, String toNumber, String message){
        
        Twillio_Config__c config = Twillio_Config__c.getInstance();	
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(config.Endpoint__c);
        req.setMethod('POST');
        
        String username = config.Account_SID__c;
        String password = config.Auth_Token__c;
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        if( !toNumber.startsWith('+'))
            toNumber = '+'+toNumber;
        
        if( !fromNumber.startsWith('+'))
            fromNumber = '+'+fromNumber;
        
        toNumber   =  EncodingUtil.urlEncode('whatsapp:'+toNumber, 'UTF-8');
		fromNumber =  EncodingUtil.urlEncode('whatsapp:'+fromNumber, 'UTF-8');        
        message    =  EncodingUtil.urlEncode(message, 'UTF-8');
            
        String requestBody = String.format( 
              'To={0}&From={1}&Body={2}' 
            , new List<String>{toNumber, fromNumber, message }
        );
        
        req.setBody(requestBody);
        
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
    }
}