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

   
    /*//preciser update 
    Order currentOrder = Trigger.new[0];
    Boolean orderHasNoProduct = OrderService.orderWithNoProduct(currentOrder.Id);

   if(currentOrder.Status == 'Activated' && orderHasNoProduct){
    currentOrder.addError('La commande doit avoir au moins un orderItem associé');
   }

   if(Trigger.isAfter && Trigger.isDelete){
   Order deletedOrder = Trigger.old[0];
    Id associatedAccountId = deletedOrder.AccountId;
    
    if (associatedAccountId != null) {
        OrderService.deactivateAccountIfNoOrders(associatedAccountId);
    }

   }*/
   
