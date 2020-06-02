public without sharing class OpportunityService {

    public static Id find(Message incomingMessage){

        String phoneNumber       = incomingMessage.fromNumber;
        String selectedCategory  = incomingMessage.prodCategory;

        List<Opportunity> oppLst = [
            Select Id 
                 , IsClosed
              From Opportunity 
             Where Account.Phone = :phoneNumber
             AND IsClosed  = false
             ORDER BY CreatedDate DESC
             LIMIT 1
        ];

        if( oppLst.isEmpty() == false ) {
            return oppLst[0].Id;
        }

        return null;  
    }
}