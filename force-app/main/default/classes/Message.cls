public without sharing class Message {
    
    public static final String INCOMING = 'Incoming';
    public static final String OUTGOING = 'Outgoing';

    public Message(String fromNum,String toNumb,String message){
        this.fromNumber = fromNum;
        this.toNumber   = toNumb;
        this.message    = message;
    }

    public String fromNumber {set;get;} 
    public String toNumber	  {set;get;} 
    public String message	  {set;get;}
    public Id parentRecordId   {set;get;}
}