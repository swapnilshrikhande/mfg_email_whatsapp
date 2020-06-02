public without sharing class LeadService {

    public static final Map<String,String> productCategoryMap = new Map<String,String>{
        '1' => 'Glass Lined Equipment',
        '2' => 'Filtration And Drying Equipment',
        '3' => 'Mixing Systems',
        '4' => 'Engineered Systems',
        '5' => 'Other Enquiry',
        '6' => 'Product Issue'
    };

    public static final String CATEGORY_SELECTION_MESSAGE = 
        'Hi, Please select a product category from below list to continue:\n'
    	+' 1. Glass Lined Equipment\n'
        +' 2. Filtration And Drying Equipment\n'
        +' 3. Mixing Systems\n'
        +' 4. Engineered Systems\n'
        +' 5. Other Enquiry\n'
        +' 6. Product Issue\n'
        +'Reply with the option number.';


    public static final String PROD_SELECTION_MESSAGE = 
        'Thanks!, Please select a product from below list to continue:\n'
    	+' {0} \n'
        +'Reply with the option number.';
    
    public static final Map<String,String> productIdMap = new Map<String,String>{
        '7' => 'Glass Lined Reactors',
        '8' => 'Next Generation Mixing Systems',
        '9' => 'Agitating Nozzles',
        '10' => 'Glass Lined Storage Tanks',
        '11' => 'Glass Steel',
        '12' => 'Accessories',
        '13' => 'Mavazwag®agitated Nutsche Filters & Filter Dryers',
        '14' => 'Funda® Centrifugal Disc Filters',
        '15' => 'Economix® Mixing Systems',
        '16' => 'Mavadrive® Magnetic Agitators',
        '17' => 'Wiped Film Evaporators',
        '18' => 'Single Fluid Heating & Cooling Systems'
    };

    public static final Map<String,String> parentCategoryMap = new Map<String,String>{
        '7' => '1',
        '8' => '1',
        '9' => '1',
        '10' => '1',
        '11' => '1',
        '12' => '1',
        '13' => '2',
        '14' => '2',
        '15' => '3',
        '16' => '3',
        '17' => '4',
        '18' => '4'
    };

    public static final Map<String,List<String>> productMap = new Map<String,List<String>>{
        '1' => new List<String>{'7. Glass Lined Reactors\n',
                                '8. Next Generation Mixing Systems\n',
                                '9. Agitating Nozzles\n',
                                '10. Glass Lined Storage Tanks\n',
                                '11. Glass Steel\n',
                                '12. Accessories\n'
                            },
        '2' => new List<String>{'13. Mavazwag®agitated Nutsche Filters & Filter Dryers\n',
                                '14. Funda® Centrifugal Disc Filters\n'
                            },
        '3' => new List<String>{'15. Economix® Mixing Systems\n',
                                '16. Mavadrive® Magnetic Agitators\n'
                            },
        '4' => new List<String>{'17. Wiped Film Evaporators\n',
                                '18. Single Fluid Heating & Cooling Systems\n'}
    };

    public static final String LEAD_STATUS_CONTACTED = 'Contacted';
	
    public static Id find(Message incomingMessage){

        String phoneNumber       = incomingMessage.fromNumber;
        String selectedCategory  = incomingMessage.prodCategory;

        List<Lead> leadLst = [
            Select Id 
              From Lead
             Where Phone = :phoneNumber
               AND IsConverted = false
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
            , Interested_In_Product_Category__c=msg.prodCategory
            , Interested_Product__c=msg.product
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

    public static List<Sobject> findAll(Message incomingMessage){

        String phoneNumber       = incomingMessage.fromNumber;

        List<Opportunity> oppLst = [
            Select Id 
                 , IsClosed
              From Opportunity 
             Where Account.Phone = :phoneNumber
             AND IsClosed  = false
        ];

        if( ! oppLst.isEmpty() )
            return oppLst;

        List<Lead> leadLst = [
            Select Id 
              From Lead
             Where Phone = :phoneNumber
               AND IsConverted = false
        ];

        return leadLst;
        
    }
    
}