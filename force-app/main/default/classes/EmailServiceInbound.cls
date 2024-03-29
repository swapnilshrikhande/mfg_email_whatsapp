/** Class Name   : EmailServiceInbound 
*  Description  : For all incoming email messages , this class invoke.
*  Created By   : Shridhar Gaikwad
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
global class EmailServiceInbound implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String myPlainText= '';
        // Add the email plain text into the local variable 
        myPlainText = email.plainTextBody;        
        system.debug('####unique message ID##'+email.messageId);
        
        // For storing Relation Id
        string oppcid ='';
        
        string sss= email.subject;
        System.debug('sss '+ sss);
        string subrecid;

        if( sss.contains('(') ) {
            string [] a = sss.split('\\(');
            system.debug('a0 ='+ a[0]);
            //system.debug('a1 a[1]);

            if( a[1].contains(')') ) {
                string [] bb = a[1].split('\\)');
                system.debug('bb>>>Final ID>>>> '+bb[0] );
                subrecid = bb[0] ; 
            }
        }

        //@TODO subrecid Check if the record is deleted, if yes create a new lead
        
        

        //if email for lead but lead is converted attach to opportunity
        if( !String.isBlank(subrecid) && subrecid.startsWith('00Q')) {
            Lead leadRecord = LeadService.fetchLead(subrecid);

            //if no record found, probably the record is deleted.
            if( leadRecord == null ) {
                subrecid = ''; // create new lead;
            } else if( leadRecord.IsConverted ) {
                subrecid =  leadRecord.ConvertedOpportunityId;
            }
        }

        //if blank create new Lead
        if( String.isBlank(subrecid) ) {
            subrecid = LeadService.createFromEmail(email.FromAddress);    
        }
        
        If (subrecid.startsWith('003')){
            //Add Inbound Email Message for contact
            EmailMessage conEmailMessage = new EmailMessage();
            conEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            conEmailMessage.FromAddress = email.FromAddress;
            conEmailMessage.FromName = email.FromName;
            conEmailMessage.Subject = email.subject;
            conEmailMessage.status = '2';
            conEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            conEmailMessage.Incoming= True;
            conEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            conEmailMessage.Contact__c =subrecid;
            insert conEmailMessage;
            System.debug('Reply Email: ' + conEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = conEmailMessage.id;
            emr.RelationId = subrecid;// user id of the sender
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            system.debug('>>>>>=='+ emr );
        }
        
        else if(subrecid.startsWith('00Q')) {
            //Add Inbound Email Message for Lead
            EmailMessage leadEmailMessage = new EmailMessage();
            leadEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            leadEmailMessage.FromAddress =  email.FromAddress;
            leadEmailMessage.FromName = email.FromName;
            leadEmailMessage.Subject = email.subject;
            leadEmailMessage.status = '2';
            leadEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            leadEmailMessage.Incoming= True;
            leadEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            leadEmailMessage.Lead__c = subrecid;
            insert leadEmailMessage;
            System.debug('Reply Email: ' + leadEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = leadEmailMessage.id;
            emr.RelationId = subrecid; 
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            
            if( leadEmailMessage.Lead__c != null ){
                update new Lead(Id=leadEmailMessage.Lead__c,Activity_Count_Updated_On__c=null);    
            }
            
            system.debug('>>>>>=='+ emr );
        }
        
        /* else if(subrecid.startsWith('001')) {
            //Add Inbound Email Message for Account
            EmailMessage accEmailMessage = new EmailMessage();
            accEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            accEmailMessage.FromAddress =  email.FromAddress;
            accEmailMessage.FromName = email.FromName;
            accEmailMessage.Subject = email.subject;
            accEmailMessage.status = '2';
            accEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            accEmailMessage.Incoming= True;
            accEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            accEmailMessage.Account__c = subrecid;
            insert accEmailMessage;
            System.debug('Reply Email: ' + accEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = accEmailMessage.id;
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
             List<Account>accid = [SELECT Id, (SELECT Contact.Id, Contact.Name,Contact.Email FROM AccountContactRelations) FROM Account where id =: subrecid LIMIT 1 ];
                for (Account acc:accid){
                    for (AccountContactRelation actr : acc.AccountContactRelations ){
                        system.debug('act.Contact.Email = '+actr.Contact.Id);
                        oppcid = actr.Contact.Id;
                    }
                }
            emr.RelationId = oppcid ;
            insert emr; 
            system.debug('>>>>>=='+ emr );
        }*/
        
      /*  else if(subrecid.startsWith('006')){
            //Add Inbound Email Message for Opportunity
            EmailMessage oppEmailMessage = new EmailMessage();
            oppEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            oppEmailMessage.FromAddress =  email.FromAddress;
            oppEmailMessage.FromName = email.FromName;
            oppEmailMessage.Subject = email.subject;
            oppEmailMessage.status = '2';
            oppEmailMessage.HtmlBody = email.htmlBody;
            oppEmailMessage.Incoming= True;
            oppEmailMessage.TextBody = email.plainTextBody;
            oppEmailMessage.Opportunity__c = subrecid;
            insert oppEmailMessage;
            System.debug('Reply Email: ' + oppEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = oppEmailMessage.id;
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            List<OpportunityContactRole>passid = [select id,ContactId,IsPrimary,OpportunityId,Role from OpportunityContactRole where OpportunityId=: subrecid];
            for (OpportunityContactRole opc : passid ){
                oppcid = opc.ContactId;
            }
            system.debug('#####'+ oppcid);
            emr.RelationId = oppcid;
            
            insert emr;  
            system.debug('>>>>>=='+ emr );           
        }*/
        
        else if(subrecid.startsWith('0Q0')){
            //Add Inbound Email Message for Quote
            EmailMessage quoEmailMessage = new EmailMessage();
            quoEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            quoEmailMessage.FromAddress =  email.FromAddress;
            quoEmailMessage.FromName = email.FromName;
            quoEmailMessage.Subject = email.subject;
            quoEmailMessage.status = '2';
            quoEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            quoEmailMessage.Incoming= True;
            quoEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            quoEmailMessage.Quote__c = subrecid;
            insert quoEmailMessage;
            System.debug('Reply Email: ' + quoEmailMessage );  
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = quoEmailMessage.id;
            List<Quote>quoid = [select id,Name,ContactId from Quote where id =: subrecid LIMIT 1];
            for (Quote opc : quoid ){
                oppcid = opc.ContactId;
            }
            system.debug('#####'+ oppcid);
            if(oppcid !=null){
                emr.RelationId = oppcid;
            }
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            system.debug('>>>>>=='+ emr );            
        }
        return result;
    }
}