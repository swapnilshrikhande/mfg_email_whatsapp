trigger creatingOrderLineItems on Order (after insert) {
    // Get all related opportunities from orders
    Set<Id> opportunityIds = new Set<Id>();
    List<Order> orderList = new List<Order>();
    for(Order o : Trigger.new)
    {
        if(o.RFQ__c!= NULL)
        {  
            system.debug('o.Contract.RFQ__c'+o.RFQ__c);
            opportunityIds.add(o.RFQ__c);
            orderList.add(o);
        }
    }
  system.debug('orderList'+orderList);
    // Query for all opportunities with their related opportunity line items
    Map<Id, Opportunity> oppsWithLineItems = new Map<Id, Opportunity>([SELECT Id, (SELECT Description,Id,ListPrice,Name,PricebookEntryId ,OpportunityId,Product2Id,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItems) FROM Opportunity WHERE Id IN :opportunityIds]);

    if(opportunityIds.size() > 0)
    {
        // Loop through orders
        List<OrderItem> orderItemsForInsert = new List<OrderItem>();
        for(Order o : Trigger.new)
        {
            // For each order get the related opportunity and line items, loop through the line items and add a new order line item to the order line item list for each matching opportunity line item
            Opportunity oppWithLineItem = oppsWithLineItems.get(o.RFQ__c);
            for(OpportunityLineItem oli : oppWithLineItem.OpportunityLineItems)
            { 
                orderItemsForInsert.add(new OrderItem(OrderId=o.Id,
                                                        PricebookEntryId = oli.PricebookEntryId,
                                                        Product2Id = oli.Product2Id,
                                                        Quantity = oli.Quantity,
                                                        UnitPrice = oli.UnitPrice ));
            }
        }
        // If we have order line items, insert data
        if(orderItemsForInsert.size() > 0)
        {
            insert orderItemsForInsert;
        }
    }
}