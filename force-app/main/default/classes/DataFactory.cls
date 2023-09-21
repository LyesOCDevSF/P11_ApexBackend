public with sharing class DataFactory {

    public static List<Account> createAccounts(Integer numAccounts) {   
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++){
            Account account = new Account(Name = 'Test Account ' + i);
            accounts.add(account);
        }
        return accounts;
    }

    public static List<Contract> createContracts(Integer numContracts, Id accountId) {   
        List<Contract> contracts = new List<Contract>();
        for(Integer i = 0; i < numContracts; i++) {
            contracts.add(new Contract(
                AccountId = accountId,
                StartDate = System.today(),
                ContractTerm = 12,
                Status = 'Draft'
            ));
        }
        return contracts;
    }

    public static List<Product2> createProducts(Integer numProducts) {
        List<Product2> products = new List<Product2>();
        for(Integer i = 0; i < numProducts; i++) {
            products.add(new Product2(Name = 'Test Product ' + i, IsActive = true));
        }
        return products;
    }

    public static List<PricebookEntry> createPricebookEntries(Integer numEntries, Id productId, Decimal price) {   
        Id standardPricebookId = Test.getStandardPricebookId();  
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for(Integer i = 0; i < numEntries; i++) {
            pbeList.add(new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = productId,
                UnitPrice = price,
                IsActive = true
            ));
        }
        return pbeList;
    }

    public static List<Order> createOrders(Integer numOrders, Id accountId) {
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < numOrders; i++) {
            orders.add(new Order(
                AccountId = accountId,
                Status = 'Draft',
                EffectiveDate = System.today(),
                Pricebook2Id = standardPricebookId
            ));
        }
        return orders;
    }

    public static List<OrderItem> createOrderItems(Integer numOrderItems, Id orderId, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for(Integer i = 0; i < numOrderItems; i++) {
            orderItems.add(new OrderItem(
                OrderId = orderId,
                PricebookEntryId = pricebookEntryId,
                Quantity = quantity,
                UnitPrice = unitPrice
            ));
        }
        return orderItems;
    }
}
