public with sharing class OrderService {
    

   /* public static Boolean orderWithNoProduct (Id orderId){
         
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];

        return productCount == 0;
    }
    //liste des orders */

    public static void verifyOrderProducts(List<Order> newOrders, Map<Id, Order> oldOrderMap) {
        
        List<Order> ordersToCheck = new List<Order>();
        //Identification des commandes qui passent de draft à Active 
        for(Order newOrder : newOrders) {
            Order oldOrder = oldOrderMap.get(newOrder.Id);
            if(oldOrder.Status == 'Draft' && newOrder.Status == 'Active') {
                ordersToCheck.add(newOrder);
            }
        }
        // recuperation des commandes qui doivent etre vérifiées 
        Set<Id> orderIdsToCheck = new Set<Id>();
        for(Order order : ordersToCheck) {
            orderIdsToCheck.add(order.Id);
        }

        //Récuperation des produits pour les commandes à vérifier 
        List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIdsToCheck];
        Set<Id> orderIdsWithProducts = new Set<Id>();
        for(OrderItem oi : orderItems) {
            orderIdsWithProducts.add(oi.OrderId);
        }
        //Vérifie les commande à valider, s'il n'y a pas de produit = message d'erreur
        for(Order order : ordersToCheck) {
            if(!orderIdsWithProducts.contains(order.Id)) {
                order.addError('Veuillez saisir des produits avant d’activer l’order.');
            }
        }
    }

    

   /* // Vérifie s'il y a des orders restants pour un compte donné
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
}*/

  // Méthode pour désactiver la case Actif__c pour un compte si tous les Orders associés ont été supprimés
  public static void deactivateAccountIfNoOrders(List<Order> deletedOrders) {
    // Collecter les AccountId des Orders supprimés
    Set<Id> accountIdsToCheck = new Set<Id>();
    for (Order ord : deletedOrders) {
        accountIdsToCheck.add(ord.AccountId);
    }

    // Trouver les comptes avec des Orders restants
    List<AggregateResult> aggResults = [SELECT AccountId FROM Order WHERE AccountId IN :accountIdsToCheck GROUP BY AccountId];
    Set<Id> accountIdsWithOrders = new Set<Id>();
    for (AggregateResult ar : aggResults) {
        accountIdsWithOrders.add((Id) ar.get('AccountId'));
    }

    // Trouver les comptes à mettre à jour (ceux qui n'ont pas d'Orders restants)
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accountId : accountIdsToCheck) {
        if (!accountIdsWithOrders.contains(accountId)) {
            accountsToUpdate.add(new Account(Id = accountId, Actif__c = false)); // Désactivation de la case en conséquence 
        }
    }

    // Mise à jour des comptes
    if (accountsToUpdate.size() > 0) {
        update accountsToUpdate;
    }
}
}


    