public without sharing class LeadService {

    public static final String LEAD_STATUS_CONTACTED = 'Contacted';
	
    public static Id find(String phoneNumber){
        List<Lead> leadLst = [
            Select Id 
              From Lead
             Where Phone = :phoneNumber
             Order By CreatedDate DESC
             Limit 1
        ];
        
        if( leadLst.isEmpty() == false ) {
            return leadLst.get(0).Id;
        }
        
        return null;
    }

    public static Lead fetchLead(Id leadId){
        List<Lead> leadLst = [
            Select Id  
                  , ConvertedOpportunityId
                  , IsConverted
              From Lead
             Where Id = :leadId
             Limit 1
        ];
        
        if( leadLst.isEmpty() == false ) {
            return leadLst.get(0);
        }
        
        return null;
    }

    public static Id create(Message msg){

        Lead leadRecord  = new Lead(
              Company='Unknown'
            , LastName=msg.fromNumber
            , Phone=msg.fromNumber
        );

        insert leadRecord;

        return leadRecord.Id;
    }

    public static Id createFromEmail(String fromEmail){

        EmailComponents emailCmp = parseEmailComponents(fromEmail);

        Lead leadRecord  = new Lead(
            Company     =   emailCmp.Company
          , FirstName   =   emailCmp.FirstName
          , LastName    =   emailCmp.LastName
          , Email       =   fromEmail
      );

      insert leadRecord;


      return leadRecord.Id; 
    }

    public class EmailComponents {
        public String Company {set;get;}
        public String FirstName {set;get;}
        public String LastName  {set;get;}
    }

    public static  EmailComponents parseEmailComponents(String fromEmail){

        EmailComponents emailCmp = new EmailComponents();

        List<String> emailComponents = fromEmail.split('@');
        emailCmp.Company = emailComponents[1];

        if( emailComponents[0].contains('.')) {
            List<String> nameComponents =  emailComponents[0].split('\\.');
            emailCmp.FirstName = nameComponents[0];
            emailCmp.LastName = nameComponents[1];
        } else {
            emailCmp.LastName  = emailComponents[0];
        }

        return emailCmp;
    }
    
}