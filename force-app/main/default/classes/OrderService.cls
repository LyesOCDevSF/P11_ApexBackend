public with sharing class OrderService {
    

    public static Boolean orderWithNoProduct (Id orderId){
         
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];

        return productCount == 0;
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
    