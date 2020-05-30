public without sharing class OpportunityService {

    public static Id find(String fromPhoneNumber){
        List<Opportunity> oppLst = [
            Select Id 
                 , IsClosed
              From Opportunity 
             Where Account.Phone = :fromPhoneNumber
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