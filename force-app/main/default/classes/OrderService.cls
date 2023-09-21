public with sharing class OrderService {
    

   /* public static Boolean orderWithNoProduct (Id orderId){
         
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];

        return productCount == 0;
    }
    //liste des orders */

    public static void verifyOrderProducts(List<Order> newOrders, Map<Id, Order> oldOrderMap) {
        
        List<Order> ordersToCheck = new List<Order>();
        
        for(Order newOrder : newOrders) {
            Order oldOrder = oldOrderMap.get(newOrder.Id);
            if(oldOrder.Status == 'Draft' && newOrder.Status == 'Active') {
                ordersToCheck.add(newOrder);
            }
        }
        
        Set<Id> orderIdsToCheck = new Set<Id>();
        for(Order order : ordersToCheck) {
            orderIdsToCheck.add(order.Id);
        }
        
        List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIdsToCheck];
        Set<Id> orderIdsWithProducts = new Set<Id>();
        for(OrderItem oi : orderItems) {
            orderIdsWithProducts.add(oi.OrderId);
        }
        
        for(Order order : ordersToCheck) {
            if(!orderIdsWithProducts.contains(order.Id)) {
                order.addError('Veuillez saisir des produits avant d’activer l’order.');
            }
        }
    }

    

    // Vérifie s'il y a des orders restants pour un compte donné
    public static Boolean hasRemainingOrders(Id accountId) {
        Integer orderCount = [SELECT COUNT() FROM Order WHERE AccountId = :accountId];
        return orderCount > 0;
    }

    // Décoche la case Active__c sur le compte si nécessaire
    public static void deactivateAccountIfNoOrders(Id accountId) {
        if (!hasRemainingOrders(accountId)) {
            Account acctToUpdate = new Account(Id = accountId, Actif__c = false);
            update acctToUpdate;
        }
}
}
    