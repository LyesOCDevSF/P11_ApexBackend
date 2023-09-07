public with sharing class OrderService {
    
        // Methode pour récupérer les ID des orders ayant des OrderItems associés
        public static Set<Id> getOrderWithItems(Set<Id> orderIds){
            //requete pour recuperer les id des order associé a un ou plusieurs orderitem
            List<OrderItem> items = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIds ];
            //instanciation de la liste des id 
            Set<Id> ordersWithItems = new Set<Id>();
            // boucle for pour ajouter ajouter chaque orrder id associé a un order item 
        for(OrderItem item : items) {
            ordersWithItems.add(item.OrderId);
        }
        return ordersWithItems;
    }
}