trigger OrderTrigger on Order (before update, after delete) {

    // Pour la vérification des produits lors du passage de Draft à Active
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.verifyOrderProducts(Trigger.new, Trigger.oldMap);
    }

    // Pour la vérification des Orders restants lors de la suppression
    if (Trigger.isAfter && Trigger.isDelete) {
        OrderService.deactivateAccountIfNoOrders(Trigger.old);
    }
}

   
    
   
