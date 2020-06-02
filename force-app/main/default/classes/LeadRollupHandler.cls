public class LeadRollupHandler {
    public static void execute(Map<Id,Lead> oldMap, List<Lead> leadLst){
        
        //just support one record for demo purpose
       	Lead leadRecord = leadLst.get(0);
        
        if( 	leadRecord.Activity_Count_Updated_On__c == null
          ) {
              
             Lead leadRecordDB = [SELECT Id
              ,(Select Id from Messages__r)
              ,(Select Id from Email_Messages__r) 
              From Lead 
             Where Id = :leadRecord.Id
                  limit 1
                  ]; 
              
              
              
              leadRecord.Total_Email_Count__c = leadRecordDB.Email_Messages__r.size();
              leadRecord.Total_Message_Count__c = leadRecordDB.Messages__r.size();
              //System.assert(false,'Total Message count = '+leadRecord.Total_Message_Count__c);
              
          }
        
    }
}